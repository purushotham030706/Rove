from app.models.vehicle import Vehicle
from app.core.branding import RARITY_CONFIGS

def serialize_vehicle_summary(v: Vehicle) -> dict:
    variant = v.variant
    generation = variant.generation if variant else None
    model = generation.model if generation else None
    mfg = model.manufacturer if model else None

    tier = v.rarity.tier if v.rarity else "COMMON"
    tier_cfg = RARITY_CONFIGS.get(tier, RARITY_CONFIGS["COMMON"])

    return {
        "id": v.id,
        "canonical_name": v.canonical_name,
        "display_year_range": v.display_year_range,
        "make": mfg.name if mfg else "Unknown",
        "model": model.name if model else "Unknown",
        "generation_code": generation.code if generation else "",
        "variant_name": variant.name if variant else "",
        "country": mfg.country if mfg else "Unknown",
        "category": model.category if model else "Sedan",
        "tier": tier,
        "rarity_color": tier_cfg["color"],
        "rarity_stars": tier_cfg["stars"],
        "photo_url": v.photo_url,
        "pixel_art_sprite": v.pixel_art_sprite,
    }

def serialize_vehicle_detail(v: Vehicle) -> dict:
    data = serialize_vehicle_summary(v)
    
    tier = data["tier"]
    tier_cfg = RARITY_CONFIGS.get(tier, RARITY_CONFIGS["COMMON"])

    if v.specifications:
        s = v.specifications
        data["specifications"] = {
            "engine": s.engine,
            "displacement": s.displacement,
            "cylinders": s.cylinders,
            "aspiration": s.aspiration,
            "horsepower": s.horsepower,
            "torque_nm": s.torque_nm,
            "transmission": s.transmission,
            "drivetrain": s.drivetrain,
            "curb_weight_kg": s.curb_weight_kg,
            "top_speed_kmh": s.top_speed_kmh,
            "zero_to_hundred_sec": s.zero_to_hundred_sec,
            "production_years": s.production_years,
        }
    else:
        data["specifications"] = None

    if v.rarity:
        r = v.rarity
        data["rarity"] = {
            "tier": r.tier,
            "rarity_score": r.rarity_score,
            "production_volume": r.production_volume,
            "estimated_current_prevalence": r.estimated_current_prevalence,
            "age_years": r.age_years,
            "regional_availability": r.regional_availability,
            "color": tier_cfg["color"],
            "badge_symbol": tier_cfg["badge_symbol"],
            "base_xp": tier_cfg["base_xp"],
            "stars": tier_cfg["stars"],
        }
    else:
        data["rarity"] = None

    if v.lore:
        l = v.lore
        data["lore"] = {
            "documented_nicknames": l.documented_nicknames or [],
            "community_nicknames": l.community_nicknames or [],
            "history": l.history,
            "motorsport": l.motorsport,
            "interesting_facts": l.interesting_facts or [],
            "trivia": l.trivia or [],
        }
    else:
        data["lore"] = None

    return data
