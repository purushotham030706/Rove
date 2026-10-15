import uuid
from datetime import datetime
from sqlalchemy import Column, String, Integer, DateTime, ForeignKey
from sqlalchemy.orm import relationship
from app.database import Base
from app.core.branding import get_title_for_level

class User(Base):
    __tablename__ = "users"

    id = Column(String(64), primary_key=True, default=lambda: str(uuid.uuid4()))
    username = Column(String(64), nullable=False, unique=True)
    created_at = Column(DateTime, default=datetime.utcnow)
    avatar_pixel_art = Column(String(256), default="pixel_avatar_driver_01")

    progression = relationship("UserProgression", back_populates="user", uselist=False, cascade="all, delete-orphan")
    encounters = relationship("Encounter", back_populates="user")
    collections = relationship("UserCollection", back_populates="user")
    achievements = relationship("UserAchievement", back_populates="user")


class UserProgression(Base):
    __tablename__ = "user_progressions"

    id = Column(String(64), primary_key=True, default=lambda: str(uuid.uuid4()))
    user_id = Column(String(64), ForeignKey("users.id"), nullable=False, unique=True)
    level = Column(Integer, default=1)
    current_xp = Column(Integer, default=0)
    title = Column(String(64), default="NOVICE SPOTTER")
    total_encounters = Column(Integer, default=0)
    unique_vehicles = Column(Integer, default=0)
    common_count = Column(Integer, default=0)
    uncommon_count = Column(Integer, default=0)
    rare_count = Column(Integer, default=0)
    epic_count = Column(Integer, default=0)
    legendary_count = Column(Integer, default=0)
    mythic_count = Column(Integer, default=0)
    cities_discovered = Column(Integer, default=1)
    manufacturers_discovered = Column(Integer, default=0)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    user = relationship("User", back_populates="progression")

    def update_title(self):
        self.title = get_title_for_level(self.level)
