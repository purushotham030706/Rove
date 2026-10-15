from datetime import datetime
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.database import get_db
from app.models.vehicle import Vehicle, VehicleModel, Manufacturer, Generation
from app.models.user import User, UserProgression
from app.models.encounter import Encounter, UserCollection
from app.schemas import (
    IdentifyRequestSchema,
    IdentifyResponseSchema,
    CaptureConfirmRequestSchema,
    CaptureConfirmResponseSchema,
    CandidateAlternative
)
from app.services.vision_ai_service import vision_service
from app.services.xp_service import XPService
from app.services.achievement_service import AchievementService
from app.routers.helpers import serialize_vehicle_detail
from app.core.config import settings

router = APIRouter(tags=["Identification & Capture"])

@router.post("/identify", response_model=IdentifyResponseSchema)
async def identify_car(
    req: IdentifyRequestSchema,
    db: Session = Depends(get_db)
):
    # 1. Run vision AI identification (supports mock demo or real model)
    ai_result = await vision_service.identify(
        image_name_hint=req.image_name_hint,
        force_low_confidence=req.force_low_confidence or False
    )

    # 2. Match against database catalogue
    # Try exact or partial matches
    matched_vehicle = None
    all_vehicles = db.query(Vehicle).all()
    for v in all_vehicles:
        variant = v.variant
        gen = variant.generation if variant else None
        model = gen.model if gen else None
        mfg = model.manufacturer if model else None

        if not mfg or not model:
            continue

        if (mfg.name.lower() == ai_result.make.lower() and
            model.name.lower() in ai_result.model.lower()):
            matched_vehicle = v
            # If generation matches too, it's exact
            if gen and gen.code.lower() == ai_result.generation.lower():
                matched_vehicle = v
                break

    # Fallback to first vehicle if none matched
    if not matched_vehicle and all_vehicles:
        matched_vehicle = all_vehicles[0]

    detail = serialize_vehicle_detail(matched_vehicle) if matched_vehicle else None

    # Alternative candidates formatted
    alternatives = [
        CandidateAlternative(
            make=alt.get("make", ""),
            model=alt.get("model", ""),
            generation=alt.get("generation", ""),
            variant=alt.get("variant", ""),
            confidence=alt.get("confidence", 0.5)
        )
        for alt in ai_result.alternative_candidates
    ]

    return IdentifyResponseSchema(
        matched_vehicle=detail,
        confidence=ai_result.confidence,
        is_low_confidence=ai_result.is_low_confidence,
        alternative_candidates=alternatives,
        notes=ai_result.notes,
        ai_provider=settings.AI_PROVIDER
    )


@router.post("/capture/confirm", response_model=CaptureConfirmResponseSchema)
def confirm_capture(
    req: CaptureConfirmRequestSchema,
    db: Session = Depends(get_db)
):
    user_id = req.user_id or settings.DEFAULT_USER_ID
    user = db.query(User).filter(User.id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    prog = db.query(UserProgression).filter(UserProgression.user_id == user_id).first()
    if not prog:
        prog = UserProgression(user_id=user_id)
        db.add(prog)
        db.flush()

    vehicle = db.query(Vehicle).filter(Vehicle.id == req.vehicle_id).first()
    if not vehicle:
        raise HTTPException(status_code=404, detail=f"Vehicle '{req.vehicle_id}' not found")

    # Check if this vehicle is already in user's collection
    existing_collection = db.query(UserCollection).filter(
        UserCollection.user_id == user_id,
        UserCollection.vehicle_id == req.vehicle_id
    ).first()

    is_new = existing_collection is None
    city = req.city or "Mysuru"
    region = req.region or "Karnataka"
    photo = req.captured_image_url or vehicle.photo_url or "https://images.unsplash.com/photo-1580273916550-e323be2ae537?w=800"

    tier = vehicle.rarity.tier if vehicle.rarity else "COMMON"
    xp_awarded = XPService.calculate_xp_for_discovery(tier, is_new=is_new)

    if is_new:
        collection_entry = UserCollection(
            user_id=user_id,
            vehicle_id=vehicle.id,
            first_discovered_at=datetime.utcnow(),
            latest_discovered_at=datetime.utcnow(),
            encounter_count=1,
            primary_photo_url=photo,
            first_city=city,
            latest_city=city
        )
        db.add(collection_entry)
        encounter_count = 1

        # Increment tier counters
        prog.unique_vehicles += 1
        tier_upper = tier.upper()
        if tier_upper == "COMMON":
            prog.common_count += 1
        elif tier_upper == "UNCOMMON":
            prog.uncommon_count += 1
        elif tier_upper == "RARE":
            prog.rare_count += 1
        elif tier_upper == "EPIC":
            prog.epic_count += 1
        elif tier_upper == "LEGENDARY":
            prog.legendary_count += 1
        elif tier_upper == "MYTHIC":
            prog.mythic_count += 1
    else:
        existing_collection.encounter_count += 1
        existing_collection.latest_discovered_at = datetime.utcnow()
        existing_collection.latest_city = city
        encounter_count = existing_collection.encounter_count

    # Create encounter history record
    encounter = Encounter(
        user_id=user_id,
        vehicle_id=vehicle.id,
        timestamp=datetime.utcnow(),
        latitude=req.latitude,
        longitude=req.longitude,
        approximate_city=city,
        approximate_region=region,
        captured_image_url=photo,
        ai_confidence=req.ai_confidence or 0.95,
        is_new_discovery=is_new,
        xp_awarded=xp_awarded
    )
    db.add(encounter)

    # Update Progression
    prog.total_encounters += 1
    prog.current_xp += xp_awarded
    new_lvl, in_lvl, needed_lvl, pct, title = XPService.calculate_level_from_xp(prog.current_xp)
    prog.level = new_lvl
    prog.title = title

    db.commit()

    # Check achievements
    new_achievements = AchievementService.evaluate_new_unlocks(db, user_id)
    unlocked_dicts = [
        {
            "id": a.id,
            "title": a.title,
            "description": a.description,
            "badge_pixel_icon": a.badge_pixel_icon,
            "xp_reward": a.xp_reward
        }
        for a in new_achievements
    ]

    return CaptureConfirmResponseSchema(
        encounter_id=encounter.id,
        vehicle=serialize_vehicle_detail(vehicle),
        is_new_discovery=is_new,
        encounter_count=encounter_count,
        xp_awarded=xp_awarded,
        new_total_xp=prog.current_xp,
        current_level=prog.level,
        title=prog.title,
        level_progress_percent=pct,
        unlocked_achievements=unlocked_dicts
    )
