from typing import Optional
from fastapi import APIRouter, Depends, Query, HTTPException
from sqlalchemy.orm import Session
from app.database import get_db
from app.models.user import User, UserProgression
from app.schemas import StatsResponseSchema
from app.core.config import settings

router = APIRouter(prefix="/stats", tags=["Stats & Profile"])

@router.get("", response_model=StatsResponseSchema)
def get_user_stats(
    user_id: Optional[str] = Query(None),
    db: Session = Depends(get_db)
):
    uid = user_id or settings.DEFAULT_USER_ID
    user = db.query(User).filter(User.id == uid).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    prog = db.query(UserProgression).filter(UserProgression.user_id == uid).first()
    if not prog:
        prog = UserProgression(user_id=uid)
        db.add(prog)
        db.commit()

    return StatsResponseSchema(
        username=user.username,
        level=prog.level,
        title=prog.title,
        current_xp=prog.current_xp,
        total_encounters=prog.total_encounters,
        unique_vehicles=prog.unique_vehicles,
        common_count=prog.common_count,
        uncommon_count=prog.uncommon_count,
        rare_count=prog.rare_count,
        epic_count=prog.epic_count,
        legendary_count=prog.legendary_count,
        mythic_count=prog.mythic_count,
        cities_discovered=prog.cities_discovered,
        manufacturers_discovered=prog.manufacturers_discovered
    )
