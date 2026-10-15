"""Achievement evaluation service for ROVE."""

from typing import List
from sqlalchemy.orm import Session
from app.models.achievement import Achievement, UserAchievement
from app.models.encounter import UserCollection, Encounter
from app.models.vehicle import Vehicle, Variant, Generation, VehicleModel, Manufacturer, VehicleRarity

DEFAULT_ACHIEVEMENTS = [
    {
        "id": "FIRST_CAPTURE",
        "title": "FIRST ROVE",
        "description": "Capture and archive your very first vehicle encounter.",
        "category": "MILESTONE",
        "badge_pixel_icon": "pixel_badge_ignition",
        "xp_reward": 50,
        "requirement_type": "TOTAL_UNIQUE",
        "requirement_value": 1,
    },
    {
        "id": "SPOTTER_10",
        "title": "STREET SCOUT",
        "description": "Archive 10 unique vehicles in your personal collection.",
        "category": "MILESTONE",
        "badge_pixel_icon": "pixel_badge_keychain",
        "xp_reward": 100,
        "requirement_type": "TOTAL_UNIQUE",
        "requirement_value": 10,
    },
    {
        "id": "ARCHIVIST_50",
        "title": "ASPHALT ARCHIVIST",
        "description": "Archive 50 unique vehicles in your personal collection.",
        "category": "MILESTONE",
        "badge_pixel_icon": "pixel_badge_trophy",
        "xp_reward": 250,
        "requirement_type": "TOTAL_UNIQUE",
        "requirement_value": 50,
    },
    {
        "id": "FIRST_RARE",
        "title": "BLUE SPARK",
        "description": "Discover your first RARE tier vehicle.",
        "category": "RARITY",
        "badge_pixel_icon": "pixel_badge_rare_star",
        "xp_reward": 75,
        "requirement_type": "RARITY_TIER",
        "requirement_value": 1,
    },
    {
        "id": "FIRST_EPIC",
        "title": "ROYAL HOMOLOGATION",
        "description": "Discover your first EPIC tier high-performance icon.",
        "category": "RARITY",
        "badge_pixel_icon": "pixel_badge_epic_crest",
        "xp_reward": 150,
        "requirement_type": "RARITY_TIER",
        "requirement_value": 1,
    },
    {
        "id": "FIRST_LEGENDARY",
        "title": "HOLY GRAIL",
        "description": "Encounter a LEGENDARY tier automotive masterpiece.",
        "category": "RARITY",
        "badge_pixel_icon": "pixel_badge_legendary_crown",
        "xp_reward": 350,
        "requirement_type": "RARITY_TIER",
        "requirement_value": 1,
    },
    {
        "id": "JDM_HUNTER",
        "title": "KANJO SCOUT",
        "description": "Discover 3 iconic Japanese domestic machines.",
        "category": "STYLE",
        "badge_pixel_icon": "pixel_badge_jdm_flag",
        "xp_reward": 100,
        "requirement_type": "COUNTRY_COUNT",
        "requirement_value": 3,
    },
    {
        "id": "ROAD_TRIPPER",
        "title": "CROSS COUNTRY",
        "description": "Record car encounters across 3 or more distinct cities.",
        "category": "REGION",
        "badge_pixel_icon": "pixel_badge_compass",
        "xp_reward": 120,
        "requirement_type": "CITY_COUNT",
        "requirement_value": 3,
    },
    {
        "id": "HOT_HATCH",
        "title": "POCKET ROCKET",
        "description": "Archive a legendary hot hatchback icon.",
        "category": "STYLE",
        "badge_pixel_icon": "pixel_badge_turbo",
        "xp_reward": 80,
        "requirement_type": "CATEGORY",
        "requirement_value": 1,
    },
]

class AchievementService:
    @staticmethod
    def ensure_default_achievements(db: Session):
        for ach in DEFAULT_ACHIEVEMENTS:
            existing = db.query(Achievement).filter(Achievement.id == ach["id"]).first()
            if not existing:
                record = Achievement(**ach)
                db.add(record)
        db.commit()

    @staticmethod
    def evaluate_new_unlocks(db: Session, user_id: str) -> List[Achievement]:
        """Checks if any new achievements have been achieved by user and awards them."""
        # Unlocked achievement IDs
        unlocked_ids = {
            ua.achievement_id for ua in
            db.query(UserAchievement).filter(UserAchievement.user_id == user_id).all()
        }

        # User stats
        collections = db.query(UserCollection).filter(UserCollection.user_id == user_id).all()
        unique_count = len(collections)
        
        # Vehicle details
        vehicle_ids = [c.vehicle_id for c in collections]
        vehicles = db.query(Vehicle).filter(Vehicle.id.in_(vehicle_ids)).all() if vehicle_ids else []
        
        # Encounters for cities
        encounters = db.query(Encounter).filter(Encounter.user_id == user_id).all()
        distinct_cities = {e.approximate_city for e in encounters if e.approximate_city}

        new_unlocks: List[Achievement] = []

        all_achievements = db.query(Achievement).all()
        for ach in all_achievements:
            if ach.id in unlocked_ids:
                continue

            satisfied = False
            if ach.id == "FIRST_CAPTURE" and unique_count >= 1:
                satisfied = True
            elif ach.id == "SPOTTER_10" and unique_count >= 10:
                satisfied = True
            elif ach.id == "ARCHIVIST_50" and unique_count >= 50:
                satisfied = True
            elif ach.id == "FIRST_RARE":
                satisfied = any(v.rarity and v.rarity.tier in ("RARE", "EPIC", "LEGENDARY", "MYTHIC") for v in vehicles)
            elif ach.id == "FIRST_EPIC":
                satisfied = any(v.rarity and v.rarity.tier in ("EPIC", "LEGENDARY", "MYTHIC") for v in vehicles)
            elif ach.id == "FIRST_LEGENDARY":
                satisfied = any(v.rarity and v.rarity.tier in ("LEGENDARY", "MYTHIC") for v in vehicles)
            elif ach.id == "ROAD_TRIPPER" and len(distinct_cities) >= 3:
                satisfied = True
            elif ach.id == "JDM_HUNTER":
                jdm_count = sum(
                    1 for v in vehicles
                    if v.variant and v.variant.generation and v.variant.generation.model
                    and v.variant.generation.model.manufacturer
                    and v.variant.generation.model.manufacturer.country == "Japan"
                )
                satisfied = jdm_count >= 3
            elif ach.id == "HOT_HATCH":
                hatch_count = sum(
                    1 for v in vehicles
                    if v.variant and v.variant.generation and v.variant.generation.model
                    and v.variant.generation.model.category == "Hatchback"
                )
                satisfied = hatch_count >= 1

            if satisfied:
                user_ach = UserAchievement(
                    user_id=user_id,
                    achievement_id=ach.id,
                )
                db.add(user_ach)
                new_unlocks.append(ach)

        if new_unlocks:
            db.commit()

        return new_unlocks
