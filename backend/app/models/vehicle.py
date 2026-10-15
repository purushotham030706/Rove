import uuid
from datetime import datetime
from sqlalchemy import Column, String, Integer, Float, ForeignKey, DateTime, Text, JSON
from sqlalchemy.orm import relationship
from app.database import Base

class Manufacturer(Base):
    __tablename__ = "manufacturers"

    id = Column(String(64), primary_key=True, default=lambda: str(uuid.uuid4()))
    name = Column(String(128), nullable=False, unique=True)
    country = Column(String(64), nullable=False)
    founded_year = Column(Integer, nullable=True)
    logo_pixel_art = Column(String(256), nullable=True)

    models = relationship("VehicleModel", back_populates="manufacturer", cascade="all, delete-orphan")


class VehicleModel(Base):
    __tablename__ = "models"

    id = Column(String(64), primary_key=True, default=lambda: str(uuid.uuid4()))
    manufacturer_id = Column(String(64), ForeignKey("manufacturers.id"), nullable=False)
    name = Column(String(128), nullable=False)
    category = Column(String(64), nullable=False, default="Sedan")  # Sports, Coupe, Hatchback, SUV, etc.

    manufacturer = relationship("Manufacturer", back_populates="models")
    generations = relationship("Generation", back_populates="model", cascade="all, delete-orphan")


class Generation(Base):
    __tablename__ = "generations"

    id = Column(String(64), primary_key=True, default=lambda: str(uuid.uuid4()))
    model_id = Column(String(64), ForeignKey("models.id"), nullable=False)
    code = Column(String(64), nullable=False)  # e.g., "E46", "R32", "Mk1", "992"
    name = Column(String(128), nullable=True)
    start_year = Column(Integer, nullable=False)
    end_year = Column(Integer, nullable=True)

    model = relationship("VehicleModel", back_populates="generations")
    variants = relationship("Variant", back_populates="generation", cascade="all, delete-orphan")


class Variant(Base):
    __tablename__ = "variants"

    id = Column(String(64), primary_key=True, default=lambda: str(uuid.uuid4()))
    generation_id = Column(String(64), ForeignKey("generations.id"), nullable=False)
    name = Column(String(128), nullable=False)  # e.g., "M3", "M3 CSL", "V-Spec II", "GT3 RS"
    badge = Column(String(64), nullable=True)

    generation = relationship("Generation", back_populates="variants")
    vehicles = relationship("Vehicle", back_populates="variant", cascade="all, delete-orphan")


class Vehicle(Base):
    __tablename__ = "vehicles"

    id = Column(String(64), primary_key=True, default=lambda: str(uuid.uuid4()))
    variant_id = Column(String(64), ForeignKey("variants.id"), nullable=False)
    canonical_name = Column(String(128), nullable=False)  # e.g. "BMW M3 E46"
    display_year_range = Column(String(32), nullable=False)  # "2000–2006"
    photo_url = Column(String(512), nullable=True)  # Default real photograph
    pixel_art_sprite = Column(String(512), nullable=True)  # Pixel-art car side/3/4 view
    created_at = Column(DateTime, default=datetime.utcnow)

    variant = relationship("Variant", back_populates="vehicles")
    specifications = relationship("VehicleSpecification", back_populates="vehicle", uselist=False, cascade="all, delete-orphan")
    rarity = relationship("VehicleRarity", back_populates="vehicle", uselist=False, cascade="all, delete-orphan")
    lore = relationship("VehicleLore", back_populates="vehicle", uselist=False, cascade="all, delete-orphan")
    encounters = relationship("Encounter", back_populates="vehicle")


class VehicleSpecification(Base):
    __tablename__ = "vehicle_specifications"

    id = Column(String(64), primary_key=True, default=lambda: str(uuid.uuid4()))
    vehicle_id = Column(String(64), ForeignKey("vehicles.id"), nullable=False, unique=True)
    engine = Column(String(128), nullable=False)        # "3.2L S54 Naturally Aspirated I6"
    displacement = Column(String(32), nullable=True)    # "3246 cc"
    cylinders = Column(String(16), nullable=True)       # "Inline-6"
    aspiration = Column(String(32), nullable=True)      # "Naturally Aspirated" / "Twin Turbo"
    horsepower = Column(Integer, nullable=False)        # 343
    torque_nm = Column(Integer, nullable=True)          # 365
    transmission = Column(String(64), nullable=False)   # "6-Speed Manual"
    drivetrain = Column(String(32), nullable=False)     # "RWD", "AWD", "FWD"
    curb_weight_kg = Column(Integer, nullable=True)     # 1570
    top_speed_kmh = Column(Integer, nullable=True)      # 250
    zero_to_hundred_sec = Column(Float, nullable=True)  # 5.1
    production_years = Column(String(32), nullable=True)# "2000-2006"

    vehicle = relationship("Vehicle", back_populates="specifications")


class VehicleRarity(Base):
    __tablename__ = "vehicle_rarity"

    id = Column(String(64), primary_key=True, default=lambda: str(uuid.uuid4()))
    vehicle_id = Column(String(64), ForeignKey("vehicles.id"), nullable=False, unique=True)
    tier = Column(String(32), nullable=False)           # COMMON, UNCOMMON, RARE, EPIC, LEGENDARY, MYTHIC
    rarity_score = Column(Float, nullable=False)        # 0.0 to 100.0 computed score
    production_volume = Column(Integer, nullable=True)  # e.g., 85000 or 106 (McLaren F1)
    estimated_current_prevalence = Column(String(64), nullable=True) # High, Moderate, Low, Very Rare, Ultra Rare
    age_years = Column(Integer, nullable=True)
    regional_availability = Column(String(128), nullable=True)       # Global, JDM only, Europe only, India only
    variant_rarity_factor = Column(Float, default=1.0)
    encounter_frequency_score = Column(Float, default=50.0)

    vehicle = relationship("Vehicle", back_populates="rarity")


class VehicleLore(Base):
    __tablename__ = "vehicle_lore"

    id = Column(String(64), primary_key=True, default=lambda: str(uuid.uuid4()))
    vehicle_id = Column(String(64), ForeignKey("vehicles.id"), nullable=False, unique=True)
    documented_nicknames = Column(JSON, default=list)  # e.g. ["Godzilla", "The Beast from the East"]
    community_nicknames = Column(JSON, default=list)   # e.g. ["Clown Shoe", "Batmobile"]
    history = Column(Text, nullable=False)
    motorsport = Column(Text, nullable=True)
    interesting_facts = Column(JSON, default=list)
    trivia = Column(JSON, default=list)

    vehicle = relationship("Vehicle", back_populates="lore")
