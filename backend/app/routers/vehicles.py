from typing import List, Optional
from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from app.database import get_db
from app.models.vehicle import Vehicle, VehicleModel, Manufacturer, VehicleRarity
from app.schemas import VehicleSummarySchema, VehicleDetailSchema
from app.routers.helpers import serialize_vehicle_summary, serialize_vehicle_detail

router = APIRouter(prefix="/vehicles", tags=["Vehicles"])

@router.get("", response_model=List[VehicleSummarySchema])
def list_vehicles(
    tier: Optional[str] = Query(None, description="Filter by rarity tier (COMMON, RARE, etc.)"),
    country: Optional[str] = Query(None, description="Filter by country of origin"),
    search: Optional[str] = Query(None, description="Search canonical name, make, model"),
    db: Session = Depends(get_db)
):
    query = db.query(Vehicle)
    
    if tier:
        query = query.join(Vehicle.rarity).filter(VehicleRarity.tier == tier.upper())

    vehicles = query.all()
    results = []
    for v in vehicles:
        summary = serialize_vehicle_summary(v)
        if country and summary["country"].lower() != country.lower():
            continue
        if search:
            term = search.lower()
            if (term not in summary["canonical_name"].lower() and
                term not in summary["make"].lower() and
                term not in summary["model"].lower()):
                continue
        results.append(summary)

    return results

@router.get("/{vehicle_id}", response_model=VehicleDetailSchema)
def get_vehicle_detail(vehicle_id: str, db: Session = Depends(get_db)):
    v = db.query(Vehicle).filter(Vehicle.id == vehicle_id).first()
    if not v:
        raise HTTPException(status_code=404, detail=f"Vehicle '{vehicle_id}' not found.")
    return serialize_vehicle_detail(v)
