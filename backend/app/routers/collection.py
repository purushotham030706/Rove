from typing import List, Optional
from fastapi import APIRouter, Depends, Query
from sqlalchemy.orm import Session
from app.database import get_db
from app.models.encounter import UserCollection
from app.models.vehicle import Vehicle, VehicleRarity
from app.schemas import CollectionItemSchema
from app.routers.helpers import serialize_vehicle_summary
from app.core.config import settings

router = APIRouter(prefix="/collection", tags=["Collection"])

@router.get("", response_model=List[CollectionItemSchema])
def get_user_collection(
    user_id: Optional[str] = Query(None),
    tier: Optional[str] = Query(None),
    search: Optional[str] = Query(None),
    db: Session = Depends(get_db)
):
    uid = user_id or settings.DEFAULT_USER_ID
    query = db.query(UserCollection).filter(UserCollection.user_id == uid)

    if tier:
        query = query.join(Vehicle, UserCollection.vehicle_id == Vehicle.id)\
                     .join(VehicleRarity, Vehicle.id == VehicleRarity.vehicle_id)\
                     .filter(VehicleRarity.tier == tier.upper())

    items = query.order_by(UserCollection.latest_discovered_at.desc()).all()

    results = []
    for item in items:
        vehicle = db.query(Vehicle).filter(Vehicle.id == item.vehicle_id).first()
        if not vehicle:
            continue
        v_summary = serialize_vehicle_summary(vehicle)
        if search:
            s = search.lower()
            if (s not in v_summary["canonical_name"].lower() and
                s not in v_summary["make"].lower() and
                s not in v_summary["model"].lower()):
                continue

        results.append(
            CollectionItemSchema(
                vehicle=v_summary,
                encounter_count=item.encounter_count,
                first_discovered_at=item.first_discovered_at,
                latest_discovered_at=item.latest_discovered_at,
                primary_photo_url=item.primary_photo_url,
                first_city=item.first_city,
                latest_city=item.latest_city
            )
        )

    return results
