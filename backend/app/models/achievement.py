import uuid
from datetime import datetime
from sqlalchemy import Column, String, Integer, ForeignKey, DateTime, Boolean, Text
from sqlalchemy.orm import relationship
from app.database import Base

class Achievement(Base):
    __tablename__ = "achievements"

    id = Column(String(64), primary_key=True)  # e.g., "FIRST_CAPTURE"
    title = Column(String(128), nullable=False)
    description = Column(Text, nullable=False)
    category = Column(String(64), default="MILESTONE")  # MILESTONE, RARITY, BRAND, REGION, STYLE
    badge_pixel_icon = Column(String(128), nullable=False)  # identifier for pixel art badge
    xp_reward = Column(Integer, default=50)
    requirement_type = Column(String(64), nullable=False)
    requirement_value = Column(Integer, default=1)

    user_achievements = relationship("UserAchievement", back_populates="achievement")


class UserAchievement(Base):
    __tablename__ = "user_achievements"

    id = Column(String(64), primary_key=True, default=lambda: str(uuid.uuid4()))
    user_id = Column(String(64), ForeignKey("users.id"), nullable=False)
    achievement_id = Column(String(64), ForeignKey("achievements.id"), nullable=False)
    unlocked_at = Column(DateTime, default=datetime.utcnow)
    is_claimed = Column(Boolean, default=True)

    user = relationship("User", back_populates="achievements")
    achievement = relationship("Achievement", back_populates="user_achievements")
