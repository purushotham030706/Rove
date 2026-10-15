from typing import List, Optional, Dict, Any
from pydantic import BaseModel
from datetime import datetime

class SpecificationSchema(BaseModel):
    engine: str
    displacement: Optional[str] = None
    cylinders: Optional[str] = None
    aspiration: Optional[str] = None
    horsepower: int
    torque_nm: Optional[int] = None
    transmission: str
    drivetrain: str
    curb_weight_kg: Optional[int] = None
    top_speed_kmh: Optional[int] = None
    zero_to_hundred_sec: Optional[float] = None
    production_years: Optional[str] = None

class RaritySchema(BaseModel):
    tier: str
    rarity_score: float
    production_volume: Optional[int] = None
    estimated_current_prevalence: Optional[str] = None
    age_years: Optional[int] = None
    regional_availability: Optional[str] = None
    color: str
    badge_symbol: str
    base_xp: int
    stars: int

class LoreSchema(BaseModel):
    documented_nicknames: List[str] = []
    community_nicknames: List[str] = []
    history: str
    motorsport: Optional[str] = None
    interesting_facts: List[str] = []
    trivia: List[str] = []

class VehicleSummarySchema(BaseModel):
    id: str
    canonical_name: str
    display_year_range: str
    make: str
    model: str
    generation_code: str
    variant_name: str
    country: str
    category: str
    tier: str
    rarity_color: str
    rarity_stars: int
    photo_url: Optional[str] = None
    pixel_art_sprite: Optional[str] = None

class VehicleDetailSchema(VehicleSummarySchema):
    specifications: Optional[SpecificationSchema] = None
    rarity: Optional[RaritySchema] = None
    lore: Optional[LoreSchema] = None

class IdentifyRequestSchema(BaseModel):
    image_base64: Optional[str] = None
    image_name_hint: Optional[str] = None
    force_low_confidence: Optional[bool] = False
    latitude: Optional[float] = None
    longitude: Optional[float] = None
    city: Optional[str] = "Mysuru"
    region: Optional[str] = "Karnataka"

class CandidateAlternative(BaseModel):
    make: str
    model: str
    generation: str
    variant: str
    confidence: float

class IdentifyResponseSchema(BaseModel):
    matched_vehicle: Optional[VehicleDetailSchema] = None
    confidence: float
    is_low_confidence: bool
    alternative_candidates: List[CandidateAlternative] = []
    notes: str
    ai_provider: str

class CaptureConfirmRequestSchema(BaseModel):
    vehicle_id: str
    user_id: Optional[str] = None
    captured_image_url: Optional[str] = None
    latitude: Optional[float] = None
    longitude: Optional[float] = None
    city: Optional[str] = "Mysuru"
    region: Optional[str] = "Karnataka"
    ai_confidence: Optional[float] = 0.95

class CaptureConfirmResponseSchema(BaseModel):
    encounter_id: str
    vehicle: VehicleDetailSchema
    is_new_discovery: bool
    encounter_count: int
    xp_awarded: int
    new_total_xp: int
    current_level: int
    title: str
    level_progress_percent: float
    unlocked_achievements: List[Dict[str, Any]] = []

class CollectionItemSchema(BaseModel):
    vehicle: VehicleSummarySchema
    encounter_count: int
    first_discovered_at: datetime
    latest_discovered_at: datetime
    primary_photo_url: str
    first_city: str
    latest_city: str

class EncounterMapMarkerSchema(BaseModel):
    id: str
    vehicle_id: str
    vehicle_name: str
    tier: str
    tier_color: str
    latitude: float
    longitude: float
    city: str
    timestamp: datetime
    photo_url: str

class StatsResponseSchema(BaseModel):
    username: str
    level: int
    title: str
    current_xp: int
    total_encounters: int
    unique_vehicles: int
    common_count: int
    uncommon_count: int
    rare_count: int
    epic_count: int
    legendary_count: int
    mythic_count: int
    cities_discovered: int
    manufacturers_discovered: int

class AchievementResponseSchema(BaseModel):
    id: str
    title: str
    description: str
    category: str
    badge_pixel_icon: str
    xp_reward: int
    is_unlocked: bool
    unlocked_at: Optional[datetime] = None
