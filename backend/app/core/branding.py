"""Centralized branding for ROVE.
All product names, taglines, color tokens, and tier definitions are declared here.
"""

from typing import Dict, Any

BRAND_NAME = "ROVE"
BRAND_TAGLINE = "Real-World Automotive Discovery & Archive"
BRAND_SUBTITLE = "The Retro Automotive Field Collector"
APP_VERSION = "1.0.0"

# Retro Automotive Color Palette (Hex)
COLOR_PALETTE = {
    "cream": "#F4F1EA",          # Warm retro off-white
    "canvas_dark": "#16181A",    # Muted deep charcoal / black
    "surface": "#22252A",        # Dark retro panel surface
    "surface_light": "#2F343B",  # Lighter panel / border
    "steel_blue": "#4A6B82",     # Cool steel blue
    "retro_green": "#4B8B3B",    # Muted arcade / racing green
    "amber": "#D99B26",          # Retro gauge amber
    "racing_red": "#C83E34",     # Muted vintage racing red
    "signal_orange": "#E06D28",  # Retro warning / highlight
    "asphalt_grey": "#69717D",   # Muted road grey
    "pixel_border": "#0D0E10",   # Solid outline for pixel edges
}

# Rarity Tiers and their visual identity
RARITY_CONFIGS: Dict[str, Dict[str, Any]] = {
    "COMMON": {
        "name": "COMMON",
        "stars": 1,
        "color": "#8E9AA8",       # Steel grey
        "badge_symbol": "[ C ]",
        "base_xp": 10,
        "encounter_odds": "Everyday road sight",
    },
    "UNCOMMON": {
        "name": "UNCOMMON",
        "stars": 2,
        "color": "#4B8B3B",       # Racing green
        "badge_symbol": "[ U ]",
        "base_xp": 25,
        "encounter_odds": "Enthusiast sighting",
    },
    "RARE": {
        "name": "RARE",
        "stars": 3,
        "color": "#2C75D8",       # Arcade blue
        "badge_symbol": "[ R ]",
        "base_xp": 50,
        "encounter_odds": "Uncommon sports / classic",
    },
    "EPIC": {
        "name": "EPIC",
        "stars": 4,
        "color": "#9447D1",       # Royal purple
        "badge_symbol": "[ E ]",
        "base_xp": 100,
        "encounter_odds": "High-performance homologation",
    },
    "LEGENDARY": {
        "name": "LEGENDARY",
        "stars": 5,
        "color": "#E5A912",       # Vintage gold
        "badge_symbol": "[ L ]",
        "base_xp": 250,
        "encounter_odds": "Holy grail / hypercar / icon",
    },
    "MYTHIC": {
        "name": "MYTHIC",
        "stars": 6,
        "color": "#E53E3E",       # Crimson spark
        "badge_symbol": "[ M ]",
        "base_xp": 500,
        "encounter_odds": "1-of-1 or legendary prototype",
    },
}

# Progression Titles based on Level
LEVEL_TITLES = [
    (1, "NOVICE SPOTTER"),
    (3, "STREET SCOUT"),
    (6, "CURB DETECTIVE"),
    (10, "ROAD HUNTER"),
    (15, "PADDOCK SCOUT"),
    (20, "CAR CONNOISSEUR"),
    (30, "ASPHALT ARCHIVIST"),
    (50, "APEX LEGEND"),
]

def get_title_for_level(level: int) -> str:
    title = LEVEL_TITLES[0][1]
    for min_lvl, name in LEVEL_TITLES:
        if level >= min_lvl:
            title = name
        else:
            break
    return title
