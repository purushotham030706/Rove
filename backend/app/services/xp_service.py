"""XP and Progression Service for ROVE.
Handles configurable XP allocation, duplicate discoveries, level scaling, and title calculation.
"""

from typing import Tuple, Dict, Any
from app.core.branding import RARITY_CONFIGS, get_title_for_level

DUPLICATE_XP = 25

class XPService:
    @staticmethod
    def calculate_xp_for_discovery(tier: str, is_new: bool) -> int:
        if not is_new:
            return DUPLICATE_XP
        
        tier_cfg = RARITY_CONFIGS.get(tier.upper(), RARITY_CONFIGS["COMMON"])
        return tier_cfg.get("base_xp", 10)

    @staticmethod
    def xp_required_for_level(level: int) -> int:
        """Total cumulative XP required to reach given level."""
        if level <= 1:
            return 0
        total = 0
        for lvl in range(1, level):
            # Smooth retro curve: L1->L2: 100, L2->L3: 220, etc.
            total += int(100 * (lvl ** 1.35))
        return total

    @staticmethod
    def calculate_level_from_xp(total_xp: int) -> Tuple[int, int, int, float, str]:
        """
        Returns:
        (current_level, current_level_xp, xp_for_next_level, progress_percent, title)
        """
        level = 1
        while True:
            next_req = XPService.xp_required_for_level(level + 1)
            if total_xp < next_req:
                break
            level += 1
            if level >= 100:
                break

        current_base = XPService.xp_required_for_level(level)
        next_base = XPService.xp_required_for_level(level + 1)
        needed_in_level = max(1, next_base - current_base)
        current_in_level = total_xp - current_base
        progress_pct = min(1.0, max(0.0, current_in_level / needed_in_level))
        title = get_title_for_level(level)

        return level, current_in_level, needed_in_level, progress_pct, title
