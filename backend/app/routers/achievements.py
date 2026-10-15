from typing import List, Optional
from fastapi import APIRouter, Depends, Query
from sqlalchemy.orm import Session
from app.database import get_db
from app.models.achievement import Achievement, UserAchievement
from app.schemas import AchievementResponseSchema
from app.core.config import settings

router = APIRouter(prefix="/achievements", tags=["Achievements"])

@router.get("", response_model=List[AchievementResponseSchema])
def list_achievements(
    user_id: Optional[str] = Query(None),
    db: Session = Depends(get_db)
):
    uid = user_id or settings.DEFAULT_USER_ID
    all_ach = db.query(Achievement).all()
    user_unlocks = {
        ua.achievement_id: ua.unlocked_at
        for ua in db.query(UserAchievement).filter(UserAchievement.user_id == uid).all()
    }

    results = []
    for a in all_ach:
        unlocked = a.id in user_unlocks
        results.append(
            AchievementResponseSchema(
                id=a.id,
                title=a.title,
                description=a.description,
                category=a.category,
                badge_pixel_icon=a.badge_pixel_icon,
                xp_reward=a.xp_reward,
                is_unlocked=unlocked,
                unlocked_at=user_unlocks.get(a.id)
            )
        )
    return results
