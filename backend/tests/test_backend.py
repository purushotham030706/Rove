import pytest
from fastapi.testclient import TestClient
from app.main import app
from app.services.rarity_service import RarityCalculator
from app.services.xp_service import XPService
from app.services.vision_ai_service import MockVisionProvider
from app.core.branding import get_title_for_level

client = TestClient(app)

def test_root_endpoint():
    res = client.get("/")
    assert res.status_code == 200
    data = res.json()
    assert data["app"] == "ROVE"
    assert data["status"] == "ONLINE"

def test_branding_endpoint():
    res = client.get("/branding")
    assert res.status_code == 200
    data = res.json()
    assert data["brand_name"] == "ROVE"
    assert "palette" in data
    assert "rarities" in data
    assert "COMMON" in data["rarities"]
    assert "LEGENDARY" in data["rarities"]

def test_rarity_calculation_mclaren_f1():
    # Ultra low production (106), 32 years old, homologation
    tier, score, breakdown = RarityCalculator.calculate_rarity(
        production_volume=106,
        age_years=32,
        prevalence="Ultra Rare",
        regional_availability="Homologation / Special",
        variant_factor=2.5,
        encounter_frequency_score=1.0
    )
    assert tier in ("LEGENDARY", "MYTHIC")
    assert score >= 80.0

def test_rarity_calculation_maruti_swift():
    # Mass production (650,000), everyday prevalence
    tier, score, breakdown = RarityCalculator.calculate_rarity(
        production_volume=650000,
        age_years=18,
        prevalence="Everyday",
        regional_availability="India Only",
        variant_factor=1.0,
        encounter_frequency_score=95.0
    )
    assert tier == "COMMON"
    assert score < 30.0

def test_xp_and_level_progression():
    # Tier based XP
    assert XPService.calculate_xp_for_discovery("COMMON", is_new=True) == 10
    assert XPService.calculate_xp_for_discovery("RARE", is_new=True) == 50
    assert XPService.calculate_xp_for_discovery("LEGENDARY", is_new=True) == 250
    
    # Duplicate XP
    assert XPService.calculate_xp_for_discovery("LEGENDARY", is_new=False) == 25
    assert XPService.calculate_xp_for_discovery("COMMON", is_new=False) == 25

    # Level calculation
    level, in_lvl, needed, pct, title = XPService.calculate_level_from_xp(0)
    assert level == 1
    assert title == "NOVICE SPOTTER"

    level, in_lvl, needed, pct, title = XPService.calculate_level_from_xp(1500)
    assert level >= 3
    assert title in ("STREET SCOUT", "CURB DETECTIVE", "ROAD HUNTER")

def test_vision_mock_provider_high_confidence():
    import asyncio
    provider = MockVisionProvider()
    result = asyncio.run(provider.identify_vehicle(image_name_hint="bmw_m3_e46.jpg"))
    assert result.make == "BMW"
    assert result.model == "M3"
    assert result.generation == "E46"
    assert result.confidence >= 0.90
    assert result.is_low_confidence is False

def test_vision_mock_provider_low_confidence():
    import asyncio
    provider = MockVisionProvider()
    result = asyncio.run(provider.identify_vehicle(image_name_hint="bmw", force_low_confidence=True))
    assert result.is_low_confidence is True
    assert result.confidence < 0.75
    assert len(result.alternative_candidates) > 0

def test_vehicles_api():
    res = client.get("/vehicles")
    assert res.status_code == 200
    vehicles = res.json()
    assert len(vehicles) >= 5

    # Test filtering by tier
    res_rare = client.get("/vehicles?tier=RARE")
    assert res_rare.status_code == 200
    for v in res_rare.json():
        assert v["tier"] == "RARE"

def test_vehicle_detail_api():
    res = client.get("/vehicles/bmw_m3_e46")
    assert res.status_code == 200
    v = res.json()
    assert v["canonical_name"] == "BMW M3 E46"
    assert v["specifications"]["horsepower"] == 343
    assert "history" in v["lore"]

def test_capture_and_collection_flow():
    # 1. Reset demo
    client.post("/demo/reset")

    # 2. Identify
    id_res = client.post("/identify", json={"image_name_hint": "bmw_m3_e46"})
    assert id_res.status_code == 200
    matched = id_res.json()["matched_vehicle"]
    assert matched is not None
    v_id = matched["id"]

    # 3. Confirm Capture (First Discovery)
    cap_res = client.post("/capture/confirm", json={
        "vehicle_id": v_id,
        "city": "Mysuru",
        "region": "Karnataka",
        "latitude": 12.2958,
        "longitude": 76.6394,
        "ai_confidence": 0.94
    })
    assert cap_res.status_code == 200
    cap_data = cap_res.json()
    assert cap_data["is_new_discovery"] is True
    assert cap_data["encounter_count"] == 1
    assert cap_data["xp_awarded"] == 50  # Rare base XP

    # 4. Check Collection
    col_res = client.get("/collection")
    assert col_res.status_code == 200
    collection = col_res.json()
    assert len(collection) == 1
    assert collection[0]["vehicle"]["id"] == v_id

    # 5. Capture duplicate
    dup_res = client.post("/capture/confirm", json={
        "vehicle_id": v_id,
        "city": "Bengaluru",
        "region": "Karnataka",
        "latitude": 12.9716,
        "longitude": 77.5946,
        "ai_confidence": 0.96
    })
    assert dup_res.status_code == 200
    dup_data = dup_res.json()
    assert dup_data["is_new_discovery"] is False
    assert dup_data["encounter_count"] == 2
    assert dup_data["xp_awarded"] == 25  # Duplicate XP

    # 6. Check Map Markers
    map_res = client.get("/encounters/map")
    assert map_res.status_code == 200
    markers = map_res.json()
    assert len(markers) >= 2
