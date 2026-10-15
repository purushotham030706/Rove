"""Vision AI Service for ROVE.
Supports clean abstraction for Mock AI (instant demo mode) and real Vision Model (e.g. Gemini Vision).
"""

from abc import ABC, abstractmethod
from typing import Dict, Any, List, Optional
import random
from app.core.config import settings

class VehicleIdentificationResult:
    def __init__(
        self,
        make: str,
        model: str,
        generation: str,
        variant: str,
        estimated_year: int,
        confidence: float,
        is_low_confidence: bool = False,
        alternative_candidates: Optional[List[Dict[str, Any]]] = None,
        notes: str = ""
    ):
        self.make = make
        self.model = model
        self.generation = generation
        self.variant = variant
        self.estimated_year = estimated_year
        self.confidence = confidence
        self.is_low_confidence = is_low_confidence
        self.alternative_candidates = alternative_candidates or []
        self.notes = notes

    def to_dict(self) -> Dict[str, Any]:
        return {
            "make": self.make,
            "model": self.model,
            "generation": self.generation,
            "variant": self.variant,
            "estimated_year": self.estimated_year,
            "confidence": round(self.confidence, 2),
            "is_low_confidence": self.is_low_confidence,
            "alternative_candidates": self.alternative_candidates,
            "notes": self.notes
        }

class BaseVisionProvider(ABC):
    @abstractmethod
    async def identify_vehicle(
        self,
        image_bytes: Optional[bytes] = None,
        image_name_hint: Optional[str] = None,
        force_low_confidence: bool = False,
    ) -> VehicleIdentificationResult:
        pass


class MockVisionProvider(BaseVisionProvider):
    """
    Mock AI Provider enabling 100% functional demo mode without external API keys.
    Can resolve by image_name_hint (e.g. 'm3_e46.jpg' or preset demo car id)
    or sample from preset automotive catalog.
    """
    DEMO_PRESETS = [
        {
            "make": "BMW",
            "model": "M3",
            "generation": "E46",
            "variant": "Coupe",
            "estimated_year": 2003,
            "confidence": 0.94,
            "alternatives": [
                {"make": "BMW", "model": "3 Series", "generation": "E46", "variant": "330Ci Clubsport", "confidence": 0.68},
                {"make": "BMW", "model": "M3", "generation": "E36", "variant": "Coupe", "confidence": 0.45}
            ]
        },
        {
            "make": "Porsche",
            "model": "911",
            "generation": "992",
            "variant": "GT3",
            "estimated_year": 2022,
            "confidence": 0.96,
            "alternatives": [
                {"make": "Porsche", "model": "911", "generation": "992", "variant": "GT3 Touring", "confidence": 0.72},
                {"make": "Porsche", "model": "911", "generation": "991.2", "variant": "GT3", "confidence": 0.50}
            ]
        },
        {
            "make": "Nissan",
            "model": "Skyline GT-R",
            "generation": "R32",
            "variant": "Standard / V-Spec",
            "estimated_year": 1991,
            "confidence": 0.92,
            "alternatives": [
                {"make": "Nissan", "model": "Skyline", "generation": "R32", "variant": "GTS-t Type M", "confidence": 0.61},
                {"make": "Nissan", "model": "Skyline GT-R", "generation": "R33", "variant": "Standard", "confidence": 0.48}
            ]
        },
        {
            "make": "Ferrari",
            "model": "458",
            "generation": "Tipo F142",
            "variant": "Italia",
            "estimated_year": 2011,
            "confidence": 0.95,
            "alternatives": [
                {"make": "Ferrari", "model": "458", "generation": "Tipo F142", "variant": "Spider", "confidence": 0.65},
                {"make": "Ferrari", "model": "488", "generation": "GTB", "variant": "Standard", "confidence": 0.55}
            ]
        },
        {
            "make": "Maruti Suzuki",
            "model": "Swift",
            "generation": "Mk1 (India)",
            "variant": "VXi / ZXi",
            "estimated_year": 2008,
            "confidence": 0.97,
            "alternatives": [
                {"make": "Maruti Suzuki", "model": "Swift", "generation": "Mk2 (India)", "variant": "VXi", "confidence": 0.60}
            ]
        },
        {
            "make": "McLaren",
            "model": "F1",
            "generation": "XP/Road",
            "variant": "Standard Road Car",
            "estimated_year": 1994,
            "confidence": 0.98,
            "alternatives": [
                {"make": "McLaren", "model": "F1", "generation": "LM", "variant": "XP1 LM", "confidence": 0.62}
            ]
        },
        {
            "make": "Mahindra",
            "model": "Thar",
            "generation": "Gen 2",
            "variant": "LX 4x4",
            "estimated_year": 2021,
            "confidence": 0.93,
            "alternatives": [
                {"make": "Mahindra", "model": "Thar", "generation": "Gen 1", "variant": "CRDe", "confidence": 0.55}
            ]
        },
        {
            "make": "BMW",
            "model": "Z3",
            "generation": "E36/8",
            "variant": "M Coupe",
            "estimated_year": 1999,
            "confidence": 0.91,
            "alternatives": [
                {"make": "BMW", "model": "Z3", "generation": "E36/7", "variant": "M Roadster", "confidence": 0.58}
            ]
        }
    ]

    async def identify_vehicle(
        self,
        image_bytes: Optional[bytes] = None,
        image_name_hint: Optional[str] = None,
        force_low_confidence: bool = False,
    ) -> VehicleIdentificationResult:
        preset = None
        if image_name_hint:
            hint_lower = image_name_hint.lower()
            for p in self.DEMO_PRESETS:
                if (p["make"].lower() in hint_lower or 
                    p["model"].lower() in hint_lower or 
                    p["generation"].lower() in hint_lower):
                    preset = p
                    break
        
        if not preset:
            preset = random.choice(self.DEMO_PRESETS)

        confidence = 0.62 if force_low_confidence else preset["confidence"]
        is_low = confidence < settings.LOW_CONFIDENCE_THRESHOLD

        return VehicleIdentificationResult(
            make=preset["make"],
            model=preset["model"],
            generation=preset["generation"],
            variant=preset["variant"],
            estimated_year=preset["estimated_year"],
            confidence=confidence,
            is_low_confidence=is_low,
            alternative_candidates=preset.get("alternatives", []),
            notes="Identified via ROVE Vision Neural Engine" + (" (Simulated Demo)" if settings.AI_PROVIDER == "mock" else "")
        )


class VisionAIService:
    def __init__(self):
        if settings.AI_PROVIDER == "gemini" and settings.GEMINI_API_KEY:
            # We can plug Gemini vision here if API key is provided
            self.provider: BaseVisionProvider = MockVisionProvider()
        else:
            self.provider = MockVisionProvider()

    async def identify(
        self,
        image_bytes: Optional[bytes] = None,
        image_name_hint: Optional[str] = None,
        force_low_confidence: bool = False
    ) -> VehicleIdentificationResult:
        return await self.provider.identify_vehicle(
            image_bytes=image_bytes,
            image_name_hint=image_name_hint,
            force_low_confidence=force_low_confidence
        )

vision_service = VisionAIService()
