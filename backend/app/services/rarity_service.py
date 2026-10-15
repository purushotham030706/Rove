"""Rarity Service for ROVE.
Computes deterministic and data-driven rarity tiers based on real-world automotive metrics.
Rarity does NOT simply mean expensive:
Factors include:
- Production volume
- Current survival prevalence
- Vehicle age
- Regional availability
- Variant rarity factor
- Expected encounter frequency
"""

from typing import Dict, Any, Tuple
from app.core.branding import RARITY_CONFIGS

class RarityCalculator:
    @staticmethod
    def calculate_rarity(
        production_volume: int | None,
        age_years: int | None,
        prevalence: str = "Moderate",
        regional_availability: str = "Global",
        variant_factor: float = 1.0,
        encounter_frequency_score: float = 50.0
    ) -> Tuple[str, float, Dict[str, Any]]:
        """
        Calculates rarity score (0 to 100) and assigns tier:
        COMMON, UNCOMMON, RARE, EPIC, LEGENDARY, or MYTHIC.
        """
        # 1. Volume Score (0 - 35 pts)
        volume_score = 15.0
        if production_volume is not None:
            if production_volume <= 150:
                volume_score = 35.0  # Ultra-low production (e.g. McLaren F1)
            elif production_volume <= 1500:
                volume_score = 30.0  # Homologation specials / hypercars
            elif production_volume <= 15000:
                volume_score = 22.0  # Rare sports cars / limited variants
            elif production_volume <= 60000:
                volume_score = 15.0  # Performance enthusiast models
            elif production_volume <= 250000:
                volume_score = 8.0   # Common sports/niche vehicles
            else:
                volume_score = 2.0   # Mass production (Swift, Corolla, etc.)

        # 2. Age & Historic Survival Score (0 - 20 pts)
        age = age_years or 5
        if age >= 50:
            age_score = 20.0
        elif age >= 30:
            age_score = 15.0
        elif age >= 20:
            age_score = 10.0
        elif age >= 10:
            age_score = 5.0
        else:
            age_score = 2.0

        # 3. Prevalence Factor (0 - 20 pts)
        prev_map = {
            "Ultra Rare": 20.0,
            "Very Rare": 16.0,
            "Low": 12.0,
            "Moderate": 7.0,
            "High": 2.0,
            "Everyday": 0.0
        }
        prevalence_score = prev_map.get(prevalence, 7.0)

        # 4. Regional Availability Bonus (0 - 10 pts)
        reg_map = {
            "Homologation / Special": 10.0,
            "JDM Only": 8.0,
            "Europe Only": 7.0,
            "North America Only": 7.0,
            "India Only": 5.0,
            "Global": 2.0,
        }
        regional_score = reg_map.get(regional_availability, 3.0)

        # 5. Variant Multiplier (0 - 15 pts)
        # 1.0 (base) to 2.5 (CSL, GT3 RS, Evo II)
        variant_score = min(15.0, (variant_factor - 1.0) * 10.0 + 3.0)

        # Base Raw Score
        raw_score = volume_score + age_score + prevalence_score + regional_score + variant_score
        
        # Scale with encounter frequency (inverse: lower frequency = higher score)
        # frequency score: 0 (almost never) to 100 (constantly seen)
        freq_penalty = (encounter_frequency_score / 100.0) * 20.0
        final_score = max(5.0, min(100.0, raw_score - freq_penalty + 15.0))

        # Assign Tier
        if final_score >= 92.0:
            tier = "MYTHIC"
        elif final_score >= 80.0:
            tier = "LEGENDARY"
        elif final_score >= 62.0:
            tier = "EPIC"
        elif final_score >= 42.0:
            tier = "RARE"
        elif final_score >= 25.0:
            tier = "UNCOMMON"
        else:
            tier = "COMMON"

        breakdown = {
            "volume_score": round(volume_score, 1),
            "age_score": round(age_score, 1),
            "prevalence_score": round(prevalence_score, 1),
            "regional_score": round(regional_score, 1),
            "variant_score": round(variant_score, 1),
            "final_score": round(final_score, 1),
            "tier_config": RARITY_CONFIGS.get(tier, RARITY_CONFIGS["COMMON"]),
        }

        return tier, round(final_score, 1), breakdown
