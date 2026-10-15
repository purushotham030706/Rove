from fastapi import APIRouter
from app.core.branding import (
    BRAND_NAME,
    BRAND_TAGLINE,
    BRAND_SUBTITLE,
    APP_VERSION,
    COLOR_PALETTE,
    RARITY_CONFIGS,
    LEVEL_TITLES
)

router = APIRouter(prefix="/branding", tags=["Branding"])

@router.get("")
def get_branding():
    return {
        "brand_name": BRAND_NAME,
        "tagline": BRAND_TAGLINE,
        "subtitle": BRAND_SUBTITLE,
        "version": APP_VERSION,
        "palette": COLOR_PALETTE,
        "rarities": RARITY_CONFIGS,
        "level_titles": LEVEL_TITLES
    }
