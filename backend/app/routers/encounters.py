from typing import List, Optional
from fastapi import APIRouter, Depends, Query
from sqlalchemy.orm import Session
from app.database import get_db
from app.models.encounter import Encounter
from app.models.vehicle import Vehicle
from app.schemas import EncounterMapMarkerSchema
from app.core.branding import RARITY_CONFIGS
from app.core.config import settings

router = APIRouter(prefix="/encounters", tags=["Encounters & Map"])

@router.get("")
def list_encounters(
    user_id: Optional[str] = Query(None),
    limit: int = 50,
    db: Session = Depends(get_db)
):
    uid = user_id or settings.DEFAULT_USER_ID
    encounters = db.query(Encounter)\
        .filter(Encounter.user_id == uid)\
        .order_by(Encounter.timestamp.desc())\
        .limit(limit)\
        .all()

    results = []
    for e in encounters:
        v = e.vehicle
        tier = v.rarity.tier if v and v.rarity else "COMMON"
        tier_cfg = RARITY_CONFIGS.get(tier, RARITY_CONFIGS["COMMON"])
        results.append({
            "id": e.id,
            "vehicle_id": e.vehicle_id,
            "vehicle_name": v.canonical_name if v else "Unknown",
            "tier": tier,
            "tier_color": tier_cfg["color"],
            "timestamp": e.timestamp,
            "city": e.approximate_city,
            "region": e.approximate_region,
            "latitude": e.latitude,
            "longitude": e.longitude,
            "photo_url": e.captured_image_url,
            "is_new_discovery": e.is_new_discovery,
            "xp_awarded": e.xp_awarded
        })
    return results

@router.get("/map", response_model=List[EncounterMapMarkerSchema])
def get_map_markers(
    user_id: Optional[str] = Query(None),
    db: Session = Depends(get_db)
):
    uid = user_id or settings.DEFAULT_USER_ID
    encounters = db.query(Encounter)\
        .filter(Encounter.user_id == uid)\
        .filter(Encounter.latitude.isnot(None))\
        .order_by(Encounter.timestamp.desc())\
        .all()

    # Pre-populate sample coordinates for demo if none have GPS yet
    demo_coords = [
        (12.2958, 76.6394, "Mysuru (Palace Grounds)"),
        (12.3052, 76.6552, "Mysuru (Chamundi Hill)"),
        (12.9716, 77.5946, "Bengaluru (MG Road)"),
        (12.9352, 77.6245, "Bengaluru (Koramangala)"),
        (13.0827, 80.2707, "Chennai (Marina Bay)"),
        (19.0760, 72.8777, "Mumbai (Marine Drive)"),
    ]

    results = []
    for idx, e in enumerate(encounters):
        v = e.vehicle
        tier = v.rarity.tier if v and v.rarity else "COMMON"
        tier_cfg = RARITY_CONFIGS.get(tier, RARITY_CONFIGS["COMMON"])
        
        lat = e.latitude or demo_coords[idx % len(demo_coords)][0]
        lng = e.longitude or demo_coords[idx % len(demo_coords)][1]
        city = e.approximate_city or demo_coords[idx % len(demo_coords)][2]

        results.append(
            EncounterMapMarkerSchema(
                id=e.id,
                vehicle_id=e.vehicle_id,
                vehicle_name=v.canonical_name if v else "Unknown",
                tier=tier,
                tier_color=tier_cfg["color"],
                latitude=lat,
                longitude=lng,
                city=city,
                timestamp=e.timestamp,
                photo_url=e.captured_image_url
            )
        )
    return results
