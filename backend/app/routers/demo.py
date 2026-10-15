from datetime import datetime, timedelta
from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from app.database import get_db
from app.models.encounter import Encounter, UserCollection
from app.models.user import User, UserProgression
from app.models.achievement import UserAchievement
from app.models.vehicle import Vehicle
from app.seed.seed_data import seed_database_catalogue
from app.services.achievement_service import AchievementService
from app.core.config import settings

router = APIRouter(prefix="/demo", tags=["Demo Management"])

@router.post("/reset")
def reset_demo_state(db: Session = Depends(get_db)):
    """Cleans up all encounters, collections, user achievements, and resets user stats."""
    db.query(Encounter).delete()
    db.query(UserCollection).delete()
    db.query(UserAchievement).delete()

    prog = db.query(UserProgression).filter(UserProgression.user_id == settings.DEFAULT_USER_ID).first()
    if prog:
        prog.level = 1
        prog.current_xp = 0
        prog.title = "NOVICE SPOTTER"
        prog.total_encounters = 0
        prog.unique_vehicles = 0
        prog.common_count = 0
        prog.uncommon_count = 0
        prog.rare_count = 0
        prog.epic_count = 0
        prog.legendary_count = 0
        prog.mythic_count = 0
        prog.cities_discovered = 1
        prog.manufacturers_discovered = 0

    db.commit()
    return {"status": "success", "message": "Demo data reset to clean state."}


@router.post("/seed-starter")
def seed_starter_encounters(db: Session = Depends(get_db)):
    """Populates initial starter discoveries for instant rich UX presentation."""
    # Ensure database is seeded with vehicles
    seed_database_catalogue(db)

    # Starter encounters:
    starters = [
        {
            "v_id": "bmw_m3_e46",
            "city": "Mysuru",
            "region": "Karnataka",
            "lat": 12.2958,
            "lng": 76.6394,
            "hours_ago": 2,
            "count": 4,
            "photo": "https://images.unsplash.com/photo-1580273916550-e323be2ae537?auto=format&fit=crop&w=1200&q=80",
        },
        {
            "v_id": "porsche_911_gt3_992",
            "city": "Bengaluru",
            "region": "Karnataka",
            "lat": 12.9716,
            "lng": 77.5946,
            "hours_ago": 26,
            "count": 1,
            "photo": "https://images.unsplash.com/photo-1614162692292-7ac56d7f7f1e?auto=format&fit=crop&w=1200&q=80",
        },
        {
            "v_id": "maruti_suzuki_swift_mk1",
            "city": "Mysuru",
            "region": "Karnataka",
            "lat": 12.3052,
            "lng": 76.6552,
            "hours_ago": 48,
            "count": 8,
            "photo": "https://images.unsplash.com/photo-1549399542-7e3f8b79c341?auto=format&fit=crop&w=1200&q=80",
        },
        {
            "v_id": "nissan_skyline_gtr_r32",
            "city": "Chennai",
            "region": "Tamil Nadu",
            "lat": 13.0827,
            "lng": 80.2707,
            "hours_ago": 72,
            "count": 1,
            "photo": "https://images.unsplash.com/photo-1552519507-da3b142c6e3d?auto=format&fit=crop&w=1200&q=80",
        },
        {
            "v_id": "mclaren_f1_road",
            "city": "Mumbai",
            "region": "Maharashtra",
            "lat": 19.0760,
            "lng": 72.8777,
            "hours_ago": 120,
            "count": 1,
            "photo": "https://images.unsplash.com/photo-1542282088-72c9c27ed0cd?auto=format&fit=crop&w=1200&q=80",
        }
    ]

    user_id = settings.DEFAULT_USER_ID
    for s in starters:
        v = db.query(Vehicle).filter(Vehicle.id == s["v_id"]).first()
        if not v:
            continue

        ts = datetime.utcnow() - timedelta(hours=s["hours_ago"])
        existing_col = db.query(UserCollection).filter(
            UserCollection.user_id == user_id,
            UserCollection.vehicle_id == v.id
        ).first()

        if not existing_col:
            col = UserCollection(
                user_id=user_id,
                vehicle_id=v.id,
                first_discovered_at=ts,
                latest_discovered_at=ts,
                encounter_count=s["count"],
                primary_photo_url=s["photo"],
                first_city=s["city"],
                latest_city=s["city"]
            )
            db.add(col)

        enc = Encounter(
            user_id=user_id,
            vehicle_id=v.id,
            timestamp=ts,
            latitude=s["lat"],
            longitude=s["lng"],
            approximate_city=s["city"],
            approximate_region=s["region"],
            captured_image_url=s["photo"],
            ai_confidence=0.96,
            is_new_discovery=True,
            xp_awarded=50
        )
        db.add(enc)

    # Re-evaluate user achievements
    AchievementService.evaluate_new_unlocks(db, user_id)
    db.commit()

    return {"status": "success", "message": "Starter discovery archive seeded."}
