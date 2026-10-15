import uuid
from datetime import datetime
from sqlalchemy import Column, String, Integer, Float, ForeignKey, DateTime, Boolean, Text
from sqlalchemy.orm import relationship
from app.database import Base

class Encounter(Base):
    __tablename__ = "encounters"

    id = Column(String(64), primary_key=True, default=lambda: str(uuid.uuid4()))
    user_id = Column(String(64), ForeignKey("users.id"), nullable=False)
    vehicle_id = Column(String(64), ForeignKey("vehicles.id"), nullable=False)
    timestamp = Column(DateTime, default=datetime.utcnow, nullable=False)
    
    # Approximate location for privacy
    latitude = Column(Float, nullable=True)
    longitude = Column(Float, nullable=True)
    approximate_city = Column(String(128), default="Mysuru")
    approximate_region = Column(String(128), default="Karnataka")
    
    captured_image_url = Column(String(512), nullable=False)
    ai_confidence = Column(Float, default=0.92)
    is_new_discovery = Column(Boolean, default=True)
    xp_awarded = Column(Integer, default=50)
    notes = Column(Text, nullable=True)

    user = relationship("User", back_populates="encounters")
    vehicle = relationship("Vehicle", back_populates="encounters")


class UserCollection(Base):
    __tablename__ = "user_collections"

    id = Column(String(64), primary_key=True, default=lambda: str(uuid.uuid4()))
    user_id = Column(String(64), ForeignKey("users.id"), nullable=False)
    vehicle_id = Column(String(64), ForeignKey("vehicles.id"), nullable=False)
    
    first_discovered_at = Column(DateTime, default=datetime.utcnow)
    latest_discovered_at = Column(DateTime, default=datetime.utcnow)
    encounter_count = Column(Integer, default=1)
    
    primary_photo_url = Column(String(512), nullable=False)
    first_city = Column(String(128), default="Mysuru")
    latest_city = Column(String(128), default="Mysuru")

    user = relationship("User", back_populates="collections")
    vehicle = relationship("Vehicle")
