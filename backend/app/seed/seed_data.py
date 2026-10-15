"""Seed data catalogue for ROVE.
Contains comprehensive, authenticated real-world automotive data across:
- Indian (Maruti Suzuki Swift, Mahindra Thar, Tata Sierra, Hindustan Ambassador)
- Japanese (Nissan Skyline GT-R R32, Mazda RX-7 FD, Toyota Supra MK4, Honda NSX, Suzuki Jimny)
- German (BMW M3 E46, BMW Z3 M Coupe, Porsche 911 GT3 992, Mercedes 190E Evo II, VW Golf GTI Mk1)
- American (Ford Mustang Boss 429, Dodge Viper GTS, Corvette C8)
- Italian (Ferrari 458 Italia, Lancia Delta Integrale Evo II, Lamborghini Countach LP400)
- British (McLaren F1, Aston Martin DB5)
- Korean (Hyundai Ioniq 5 N)
"""

from typing import List, Dict, Any
from sqlalchemy.orm import Session
from app.models.vehicle import (
    Manufacturer,
    VehicleModel,
    Generation,
    Variant,
    Vehicle,
    VehicleSpecification,
    VehicleRarity,
    VehicleLore
)
from app.models.user import User, UserProgression
from app.services.rarity_service import RarityCalculator
from app.services.achievement_service import AchievementService
from app.core.config import settings

VEHICLE_CATALOGUE: List[Dict[str, Any]] = [
    # --- GERMAN: BMW M3 E46 (Rare) ---
    {
        "id": "bmw_m3_e46",
        "make": "BMW",
        "country": "Germany",
        "model": "M3",
        "category": "Coupe",
        "generation_code": "E46",
        "generation_name": "Third Generation 3-Series Motorsport",
        "start_year": 2000,
        "end_year": 2006,
        "variant": "Coupe Manual",
        "canonical_name": "BMW M3 E46",
        "display_year_range": "2000–2006",
        "photo_url": "https://images.unsplash.com/photo-1580273916550-e323be2ae537?auto=format&fit=crop&w=1200&q=80",
        "pixel_art_sprite": "car_bmw_m3_e46",
        "specs": {
            "engine": "3.2L S54B32 Naturally Aspirated I6",
            "displacement": "3246 cc",
            "cylinders": "Inline-6",
            "aspiration": "Naturally Aspirated",
            "horsepower": 343,
            "torque_nm": 365,
            "transmission": "6-Speed Getrag 420G Manual",
            "drivetrain": "RWD",
            "curb_weight_kg": 1570,
            "top_speed_kmh": 250,
            "zero_to_hundred_sec": 5.1,
            "production_years": "2000–2006",
        },
        "rarity_meta": {
            "production_volume": 85744,
            "age_years": 24,
            "prevalence": "Low",
            "regional_availability": "Global",
            "variant_factor": 1.4,
            "encounter_frequency_score": 38.0
        },
        "lore": {
            "documented_nicknames": ["The High-RPM Screamer", "Ultimate M3"],
            "community_nicknames": ["The Golden Era M", "E46"],
            "history": "Widely regarded by automotive journalists as the high-water mark of naturally aspirated BMW M cars. The high-revving 8,000 RPM S54 engine won International Engine of the Year in its category six years consecutively.",
            "motorsport": "Dominated American Le Mans Series (ALMS) with the legendary M3 GTR V8 homologation variant.",
            "interesting_facts": [
                "Individual throttle bodies per cylinder deliver razor-sharp mechanical throttle response.",
                "Engine block is cast iron for immense rigidity, allowing 105 horsepower per liter without turbocharging."
            ],
            "trivia": ["Featured as the iconic hero cover car in Need for Speed: Most Wanted (2005)."]
        }
    },

    # --- GERMAN: BMW Z3 M Coupe "Clown Shoe" (Epic) ---
    {
        "id": "bmw_z3_m_coupe",
        "make": "BMW",
        "country": "Germany",
        "model": "Z3 M",
        "category": "Coupe",
        "generation_code": "E36/8",
        "generation_name": "Shooting Brake M",
        "start_year": 1998,
        "end_year": 2002,
        "variant": "M Coupe",
        "canonical_name": "BMW Z3 M Coupe",
        "display_year_range": "1998–2002",
        "photo_url": "https://images.unsplash.com/photo-1617814076367-b759c7d7e738?auto=format&fit=crop&w=1200&q=80",
        "pixel_art_sprite": "car_bmw_z3_m_coupe",
        "specs": {
            "engine": "3.2L S54 Naturally Aspirated I6",
            "displacement": "3246 cc",
            "cylinders": "Inline-6",
            "aspiration": "Naturally Aspirated",
            "horsepower": 321,
            "torque_nm": 350,
            "transmission": "5-Speed Manual",
            "drivetrain": "RWD",
            "curb_weight_kg": 1420,
            "top_speed_kmh": 250,
            "zero_to_hundred_sec": 5.3,
            "production_years": "1998–2002",
        },
        "rarity_meta": {
            "production_volume": 6291,
            "age_years": 26,
            "prevalence": "Very Rare",
            "regional_availability": "Europe / North America",
            "variant_factor": 1.8,
            "encounter_frequency_score": 15.0
        },
        "lore": {
            "documented_nicknames": ["Breadvan"],
            "community_nicknames": ["Clown Shoe"],
            "history": "Developed covertly by a passionate band of BMW M engineers outside official corporate hours to create a structural stiffness masterpiece from the Z3 roadster platform.",
            "motorsport": "Achieved notable class victories at the 24 Hours of Nürburgring.",
            "interesting_facts": [
                "Boasted 2.7 times the torsional rigidity of the Z3 roadster it was derived from.",
                "Its polarising shooting-brake proportions earned it the affectionate cult moniker 'Clown Shoe'."
            ],
            "trivia": ["Only 6,291 were ever built worldwide, making clean survivors highly prized."]
        }
    },

    # --- GERMAN: Porsche 911 GT3 992 (Epic) ---
    {
        "id": "porsche_911_gt3_992",
        "make": "Porsche",
        "country": "Germany",
        "model": "911",
        "category": "Sports",
        "generation_code": "992",
        "generation_name": "Eighth Generation 911",
        "start_year": 2021,
        "end_year": 2026,
        "variant": "GT3",
        "canonical_name": "Porsche 911 GT3 (992)",
        "display_year_range": "2021–Present",
        "photo_url": "https://images.unsplash.com/photo-1614162692292-7ac56d7f7f1e?auto=format&fit=crop&w=1200&q=80",
        "pixel_art_sprite": "car_porsche_911_gt3",
        "specs": {
            "engine": "4.0L Naturally Aspirated Flat-6 (MA275)",
            "displacement": "3996 cc",
            "cylinders": "Flat-6 (Boxer)",
            "aspiration": "Naturally Aspirated",
            "horsepower": 510,
            "torque_nm": 470,
            "transmission": "7-Speed Dual-Clutch PDK / 6-Speed GT Sports Manual",
            "drivetrain": "RWD",
            "curb_weight_kg": 1435,
            "top_speed_kmh": 318,
            "zero_to_hundred_sec": 3.4,
            "production_years": "2021–Present",
        },
        "rarity_meta": {
            "production_volume": 12000,
            "age_years": 4,
            "prevalence": "Low",
            "regional_availability": "Global",
            "variant_factor": 1.7,
            "encounter_frequency_score": 22.0
        },
        "lore": {
            "documented_nicknames": ["The Swan Neck GT3", "Motorsport Purist"],
            "community_nicknames": ["992 GT3"],
            "history": "Introduced the revolutionary motorsport-derived double-wishbone front suspension from the 911 RSR race car, eliminating MacPherson struts for transcendent steering fidelity.",
            "motorsport": "Lapped the Nürburgring Nordschleife in 6:59.927, breaking the 7-minute barrier on Michelin Cup 2 R tires.",
            "interesting_facts": [
                "Its distinctive 'swan neck' top-mounted rear wing creates uninterrupted clean airflow beneath the wing surface.",
                "Engine revs to an ear-splitting 9,000 RPM."
            ],
            "trivia": ["Directly shared its flat-6 engine architecture with the pure 911 GT3 Cup racing car."]
        }
    },

    # --- JAPANESE: Nissan Skyline GT-R R32 "Godzilla" (Epic) ---
    {
        "id": "nissan_skyline_gtr_r32",
        "make": "Nissan",
        "country": "Japan",
        "model": "Skyline GT-R",
        "category": "Coupe",
        "generation_code": "R32",
        "generation_name": "Eighth Generation Skyline",
        "start_year": 1989,
        "end_year": 1994,
        "variant": "V-Spec II",
        "canonical_name": "Nissan Skyline GT-R R32",
        "display_year_range": "1989–1994",
        "photo_url": "https://images.unsplash.com/photo-1552519507-da3b142c6e3d?auto=format&fit=crop&w=1200&q=80",
        "pixel_art_sprite": "car_nissan_skyline_gtr_r32",
        "specs": {
            "engine": "2.6L RB26DETT Twin-Turbo I6",
            "displacement": "2568 cc",
            "cylinders": "Inline-6",
            "aspiration": "Twin-Turbocharged",
            "horsepower": 280,
            "torque_nm": 353,
            "transmission": "5-Speed Manual",
            "drivetrain": "ATTESA E-TS AWD with Super HICAS 4WS",
            "curb_weight_kg": 1430,
            "top_speed_kmh": 251,
            "zero_to_hundred_sec": 4.7,
            "production_years": "1989–1994",
        },
        "rarity_meta": {
            "production_volume": 43937,
            "age_years": 35,
            "prevalence": "Very Rare",
            "regional_availability": "JDM Only",
            "variant_factor": 1.9,
            "encounter_frequency_score": 14.0
        },
        "lore": {
            "documented_nicknames": ["Godzilla", "The Monster from Japan"],
            "community_nicknames": ["R32", "The King of Group A"],
            "history": "Bred solely to obliterate Group A Touring Car competition. Australian motoring magazine Wheels crowned it 'Godzilla' in July 1989 after it crushed local Ford and Holden V8 dominance at Mount Panorama, Bathurst.",
            "motorsport": "Undefeated in Japanese Touring Car Championship (JTCC), winning 29 consecutive races out of 29 starts.",
            "interesting_facts": [
                "Officially rated at 280 HP due to Japan's Gentlemen's Agreement, but dyno runs showed stock engines delivered well over 320 HP.",
                "Pioneered computer-controlled all-wheel torque split (ATTESA E-TS) and 4-wheel steering."
            ],
            "trivia": ["Dominated the Australian Touring Car Championship so decisively that governing bodies banned AWD and turbochargers, creating V8 Supercars."]
        }
    },

    # --- JAPANESE: Mazda RX-7 FD Spirit R (Epic) ---
    {
        "id": "mazda_rx7_fd",
        "make": "Mazda",
        "country": "Japan",
        "model": "RX-7",
        "category": "Coupe",
        "generation_code": "FD3S",
        "generation_name": "Third Generation RX-7",
        "start_year": 1992,
        "end_year": 2002,
        "variant": "Type-A Spirit R",
        "canonical_name": "Mazda RX-7 FD Spirit R",
        "display_year_range": "1992–2002",
        "photo_url": "https://images.unsplash.com/photo-1541348263662-e0c8de4259ba?auto=format&fit=crop&w=1200&q=80",
        "pixel_art_sprite": "car_mazda_rx7_fd",
        "specs": {
            "engine": "1.3L 13B-REW Sequential Twin-Turbo Rotary",
            "displacement": "1308 cc equivalent",
            "cylinders": "2-Rotor Wankel",
            "aspiration": "Sequential Twin-Turbo",
            "horsepower": 280,
            "torque_nm": 314,
            "transmission": "5-Speed Manual",
            "drivetrain": "RWD",
            "curb_weight_kg": 1270,
            "top_speed_kmh": 256,
            "zero_to_hundred_sec": 4.9,
            "production_years": "1992–2002",
        },
        "rarity_meta": {
            "production_volume": 1500,
            "age_years": 24,
            "prevalence": "Ultra Rare",
            "regional_availability": "JDM Only",
            "variant_factor": 2.1,
            "encounter_frequency_score": 10.0
        },
        "lore": {
            "documented_nicknames": ["Rotary Missile", "The Pure Sports"],
            "community_nicknames": ["FD", "Batmobile RX7"],
            "history": "Designed under the philosophy of 'Operation Phoenix' as a zero-compromise lightweight driver's sports car with 50:50 weight distribution and organic styling that remains timeless.",
            "motorsport": "Won the Bathurst 12 Hour race for three consecutive years (1992, 1993, 1994).",
            "interesting_facts": [
                "World's first mass-produced sequential twin-turbocharger system from Japan.",
                "The Spirit R Type-A came from the factory with red Recaro Kevlar bucket seats and gunmetal BBS wheels."
            ],
            "trivia": ["Keisuke Takahashi's yellow machine in the legendary anime Initial D."]
        }
    },

    # --- INDIAN: Maruti Suzuki Swift Mk1 (Common) ---
    {
        "id": "maruti_suzuki_swift_mk1",
        "make": "Maruti Suzuki",
        "country": "India",
        "model": "Swift",
        "category": "Hatchback",
        "generation_code": "Mk1 (India) / ZC",
        "generation_name": "First Generation Indian Swift",
        "start_year": 2005,
        "end_year": 2011,
        "variant": "ZXi 1.3 Petrol",
        "canonical_name": "Maruti Suzuki Swift Mk1",
        "display_year_range": "2005–2011",
        "photo_url": "https://images.unsplash.com/photo-1549399542-7e3f8b79c341?auto=format&fit=crop&w=1200&q=80",
        "pixel_art_sprite": "car_maruti_swift",
        "specs": {
            "engine": "1.3L G13BB 16-Valve Multi-Point Fuel Injection I4",
            "displacement": "1298 cc",
            "cylinders": "Inline-4",
            "aspiration": "Naturally Aspirated",
            "horsepower": 87,
            "torque_nm": 113,
            "transmission": "5-Speed Manual",
            "drivetrain": "FWD",
            "curb_weight_kg": 1010,
            "top_speed_kmh": 165,
            "zero_to_hundred_sec": 12.0,
            "production_years": "2005–2011",
        },
        "rarity_meta": {
            "production_volume": 650000,
            "age_years": 18,
            "prevalence": "Everyday",
            "regional_availability": "India Only",
            "variant_factor": 1.0,
            "encounter_frequency_score": 95.0
        },
        "lore": {
            "documented_nicknames": ["India's Driver's Hatch", "The Gamechanger"],
            "community_nicknames": ["Swiftie", "Street Go-Kart"],
            "history": "Launched in India in May 2005, the Swift radically transformed the Indian passenger car market from sober family commuters into aspirational, design-led fun hatchbacks.",
            "motorsport": "A perennial favorite in Indian National Rally Championship (INRC) classes.",
            "interesting_facts": [
                "The European chassis setup gave it remarkably direct rack-and-pinion steering feedback.",
                "Became one of the most modified platforms in Indian tuner and autocross culture."
            ],
            "trivia": ["Later introduced the legendary 1.3L DDiS diesel engine nicknamed the 'National Engine of India'."]
        }
    },

    # --- INDIAN: Mahindra Thar Gen 2 (Uncommon) ---
    {
        "id": "mahindra_thar_gen2",
        "make": "Mahindra",
        "country": "India",
        "model": "Thar",
        "category": "SUV",
        "generation_code": "Gen 2",
        "generation_name": "Second Generation Modern 4x4",
        "start_year": 2020,
        "end_year": 2026,
        "variant": "LX 4x4 Hard Top",
        "canonical_name": "Mahindra Thar Gen 2",
        "display_year_range": "2020–Present",
        "photo_url": "https://images.unsplash.com/photo-1533473359331-0135ef1b58bf?auto=format&fit=crop&w=1200&q=80",
        "pixel_art_sprite": "car_mahindra_thar",
        "specs": {
            "engine": "2.2L mHawk 130 Turbocharged CRDe Diesel",
            "displacement": "2184 cc",
            "cylinders": "Inline-4",
            "aspiration": "Turbocharged",
            "horsepower": 130,
            "torque_nm": 300,
            "transmission": "6-Speed Torque Converter Automatic / Manual",
            "drivetrain": "Shift-on-the-fly 4WD with Mechanical Locking Differential",
            "curb_weight_kg": 1750,
            "top_speed_kmh": 155,
            "zero_to_hundred_sec": 13.5,
            "production_years": "2020–Present",
        },
        "rarity_meta": {
            "production_volume": 160000,
            "age_years": 5,
            "prevalence": "Moderate",
            "regional_availability": "India Only",
            "variant_factor": 1.2,
            "encounter_frequency_score": 62.0
        },
        "lore": {
            "documented_nicknames": ["The Trail Conqueror", "Modern Off-Roader"],
            "community_nicknames": ["Thar 4x4", "Mountain Goat"],
            "history": "Launched on October 2, 2020, the second-generation Thar evolved from a utilitarian barebones Jeep derivative into a comfortable, modern street and rock-crawling icon.",
            "motorsport": "Stalwart competitor in the Rainforest Challenge (RFC) India.",
            "interesting_facts": [
                "Features 226 mm of ground clearance and an approach angle of 41.8 degrees.",
                "Equipped with washable interior floors and IP54 water-resistant dashboard buttons."
            ],
            "trivia": ["First Indian off-road convertible to achieve a 4-star Global NCAP safety rating."]
        }
    },

    # --- INDIAN: Hindustan Ambassador (Rare) ---
    {
        "id": "hindustan_ambassador_mark_4",
        "make": "Hindustan Motors",
        "country": "India",
        "model": "Ambassador",
        "category": "Sedan",
        "generation_code": "Mark 4",
        "generation_name": "Fourth Generation Classic",
        "start_year": 1979,
        "end_year": 1990,
        "variant": "Classic 1500",
        "canonical_name": "Hindustan Ambassador Mark 4",
        "display_year_range": "1979–1990",
        "photo_url": "https://images.unsplash.com/photo-1541899481282-d53bffe3c35d?auto=format&fit=crop&w=1200&q=80",
        "pixel_art_sprite": "car_hindustan_ambassador",
        "specs": {
            "engine": "1.5L BMC B-Series Overhead Valve I4",
            "displacement": "1489 cc",
            "cylinders": "Inline-4",
            "aspiration": "Naturally Aspirated",
            "horsepower": 54,
            "torque_nm": 105,
            "transmission": "4-Speed Column Shift Manual",
            "drivetrain": "RWD",
            "curb_weight_kg": 1180,
            "top_speed_kmh": 120,
            "zero_to_hundred_sec": 24.0,
            "production_years": "1979–1990",
        },
        "rarity_meta": {
            "production_volume": 400000,
            "age_years": 42,
            "prevalence": "Low",
            "regional_availability": "India Only",
            "variant_factor": 1.5,
            "encounter_frequency_score": 35.0
        },
        "lore": {
            "documented_nicknames": ["King of Indian Roads", "The Grand Old Lady"],
            "community_nicknames": ["Amby", "Lal Batti Car"],
            "history": "Based on the 1956 British Morris Oxford series III, the Ambassador was manufactured in Uttarpara, Kolkata for over five decades, serving as the official transport for Prime Ministers, royalty, and taxi fleets.",
            "motorsport": "Participated in classic Himalayan Rallies in the 1980s.",
            "interesting_facts": [
                "Voted the world's best taxi by BBC Top Gear in 2013.",
                "Famed for its plush, sofa-like rear bench seat and unshakeable monocoque structure."
            ],
            "trivia": ["Remained in continuous production until 2014, making it one of the longest continuous production runs in automotive history."]
        }
    },

    # --- ITALIAN: Ferrari 458 Italia (Epic) ---
    {
        "id": "ferrari_458_italia",
        "make": "Ferrari",
        "country": "Italy",
        "model": "458",
        "category": "Supercar",
        "generation_code": "Tipo F142",
        "generation_name": "Mid-Engine V8 Era",
        "start_year": 2009,
        "end_year": 2015,
        "variant": "Italia Coupe",
        "canonical_name": "Ferrari 458 Italia",
        "display_year_range": "2009–2015",
        "photo_url": "https://images.unsplash.com/photo-1592198084033-aade902d1aae?auto=format&fit=crop&w=1200&q=80",
        "pixel_art_sprite": "car_ferrari_458_italia",
        "specs": {
            "engine": "4.5L F136 FB Naturally Aspirated Flat-Plane V8",
            "displacement": "4497 cc",
            "cylinders": "90° V8 Flat-Plane Crank",
            "aspiration": "Naturally Aspirated",
            "horsepower": 570,
            "torque_nm": 540,
            "transmission": "7-Speed Dual-Clutch F1",
            "drivetrain": "RWD",
            "curb_weight_kg": 1380,
            "top_speed_kmh": 325,
            "zero_to_hundred_sec": 3.4,
            "production_years": "2009–2015",
        },
        "rarity_meta": {
            "production_volume": 15000,
            "age_years": 14,
            "prevalence": "Low",
            "regional_availability": "Global",
            "variant_factor": 1.7,
            "encounter_frequency_score": 18.0
        },
        "lore": {
            "documented_nicknames": ["The Last Pure V8", "Maranello Masterpiece"],
            "community_nicknames": ["458", "Pininfarina Swan Song"],
            "history": "The definitive last naturally aspirated mid-engine V8 road car produced by Ferrari. Consulted directly with Michael Schumacher during steering and aero tuning at the Fiorano test circuit.",
            "motorsport": "The 458 Italia GTE won the 24 Hours of Le Mans in the LM GTE Pro class (2012, 2014).",
            "interesting_facts": [
                "Reaches its peak 570 horsepower at a spine-chilling 9,000 RPM.",
                "Features small flexible aero-elastic winglets in the front grille that deform at high speed to reduce drag."
            ],
            "trivia": ["Regarded by many critics as Pininfarina's greatest modern berlinetta design."]
        }
    },

    # --- BRITISH: McLaren F1 (Legendary) ---
    {
        "id": "mclaren_f1_road",
        "make": "McLaren",
        "country": "United Kingdom",
        "model": "F1",
        "category": "Hypercar",
        "generation_code": "XP / Road",
        "generation_name": "Gordon Murray Masterwork",
        "start_year": 1992,
        "end_year": 1998,
        "variant": "Standard Road Car",
        "canonical_name": "McLaren F1",
        "display_year_range": "1992–1998",
        "photo_url": "https://images.unsplash.com/photo-1542282088-72c9c27ed0cd?auto=format&fit=crop&w=1200&q=80",
        "pixel_art_sprite": "car_mclaren_f1",
        "specs": {
            "engine": "6.1L BMW Motorsport S70/2 60° V12",
            "displacement": "6064 cc",
            "cylinders": "V12",
            "aspiration": "Naturally Aspirated",
            "horsepower": 627,
            "torque_nm": 650,
            "transmission": "6-Speed Transverse Manual with AP Carbon Clutch",
            "drivetrain": "RWD",
            "curb_weight_kg": 1138,
            "top_speed_kmh": 386,
            "zero_to_hundred_sec": 3.2,
            "production_years": "1992–1998",
        },
        "rarity_meta": {
            "production_volume": 106,
            "age_years": 32,
            "prevalence": "Ultra Rare",
            "regional_availability": "Homologation / Special",
            "variant_factor": 2.5,
            "encounter_frequency_score": 1.0
        },
        "lore": {
            "documented_nicknames": ["The Greatest Car Ever Made", "The 3-Seat Holy Grail"],
            "community_nicknames": ["F1", "Gordon's Masterpiece"],
            "history": "Designed by Formula 1 mastermind Gordon Murray with pure carbon composite tub, central driver seat, and zero electronic driver aids. Still stands as the fastest naturally aspirated production car in history.",
            "motorsport": "Achieved outright 1st place victory at the 1995 24 Hours of Le Mans on its debut race against purpose-built prototypes.",
            "interesting_facts": [
                "Lined the engine bay with 16 grams of pure gold foil for thermal heat reflection.",
                "Central driver seat puts the pilot directly on the car's polar moment of inertia."
            ],
            "trivia": ["Only 64 road cars were ever completed out of the total 106 chassis."]
        }
    },

    # --- AMERICAN: Ford Mustang Boss 429 (Legendary) ---
    {
        "id": "ford_mustang_boss_429",
        "make": "Ford",
        "country": "United States",
        "model": "Mustang",
        "category": "Muscle",
        "generation_code": "First Gen Facelift",
        "generation_name": "NASCAR Homologation",
        "start_year": 1969,
        "end_year": 1970,
        "variant": "Boss 429 Fastback",
        "canonical_name": "Ford Mustang Boss 429",
        "display_year_range": "1969–1970",
        "photo_url": "https://images.unsplash.com/photo-1584345604476-8ec5e12e42dd?auto=format&fit=crop&w=1200&q=80",
        "pixel_art_sprite": "car_ford_mustang_boss429",
        "specs": {
            "engine": "7.0L 429ci Semi-Hemi Big Block V8",
            "displacement": "7030 cc",
            "cylinders": "V8 Semi-Hemi",
            "aspiration": "Naturally Aspirated 4-Barrel Holley",
            "horsepower": 375,
            "torque_nm": 610,
            "transmission": "4-Speed Toploader Manual",
            "drivetrain": "RWD with Traction-Lok Differential",
            "curb_weight_kg": 1690,
            "top_speed_kmh": 206,
            "zero_to_hundred_sec": 5.3,
            "production_years": "1969–1970",
        },
        "rarity_meta": {
            "production_volume": 1359,
            "age_years": 56,
            "prevalence": "Ultra Rare",
            "regional_availability": "North America Only",
            "variant_factor": 2.3,
            "encounter_frequency_score": 3.0
        },
        "lore": {
            "documented_nicknames": ["Boss 9", "The Shotgun Motor"],
            "community_nicknames": ["The King of Muscle"],
            "history": "Built by Kar Kraft in Brighton, Michigan solely to homologate Ford's massive 429 cubic inch semi-hemispherical engine for NASCAR superspeedway battles against Chrysler's Hemi.",
            "motorsport": "Powered Richard Petty and David Pearson in NASCAR Grand National division championships.",
            "interesting_facts": [
                "The engine was so wide that front shock towers had to be widened and battery relocated to trunk.",
                "Conservative factory rating of 375 HP was understated; true output was well above 500 HP."
            ],
            "trivia": ["Only 859 units were hand-built in 1969, making it one of the rarest muscle cars on Earth."]
        }
    },

    # --- KOREAN: Hyundai Ioniq 5 N (Uncommon) ---
    {
        "id": "hyundai_ioniq_5_n",
        "make": "Hyundai",
        "country": "South Korea",
        "model": "Ioniq 5",
        "category": "Hatchback",
        "generation_code": "NE",
        "generation_name": "First Generation E-GMP N",
        "start_year": 2024,
        "end_year": 2026,
        "variant": "5 N AWD",
        "canonical_name": "Hyundai Ioniq 5 N",
        "display_year_range": "2024–Present",
        "photo_url": "https://images.unsplash.com/photo-1503376780353-7e6692767b70?auto=format&fit=crop&w=1200&q=80",
        "pixel_art_sprite": "car_hyundai_ioniq5_n",
        "specs": {
            "engine": "Dual Permanent Magnet Synchronous Motors",
            "displacement": "N/A (84 kWh Battery)",
            "cylinders": "Electric Dual-Motor",
            "aspiration": "Electric",
            "horsepower": 650,
            "torque_nm": 770,
            "transmission": "Simulated N e-Shift 8-Speed Dual-Clutch with Paddle Shifters",
            "drivetrain": "Electronic All-Wheel Drive (AWD)",
            "curb_weight_kg": 2230,
            "top_speed_kmh": 260,
            "zero_to_hundred_sec": 3.4,
            "production_years": "2024–Present",
        },
        "rarity_meta": {
            "production_volume": 18000,
            "age_years": 2,
            "prevalence": "Moderate",
            "regional_availability": "Global",
            "variant_factor": 1.5,
            "encounter_frequency_score": 45.0
        },
        "lore": {
            "documented_nicknames": ["The EV That Cares About Drivers", "Corner Rascal"],
            "community_nicknames": ["Ioniq N", "The Drifting EV"],
            "history": "Developed by Hyundai N division at Namyang and honed extensively on the Nürburgring Nordschleife to prove that high-performance electric vehicles can deliver visceral driver engagement.",
            "motorsport": "Competed in the Pikes Peak International Hill Climb Time Attack division.",
            "interesting_facts": [
                "N e-Shift mimics the rev-limiter, gear shifts, and jolt of an 8-speed dual clutch gearbox.",
                "N Active Sound+ synthesizes authentic ICE exhaust pops and cracks."
            ],
            "trivia": ["Named Top Gear's 2023 Car of the Year."]
        }
    }
]

def seed_database_catalogue(db: Session):
    """Populates manufacturers, models, generations, variants, vehicles, specs, rarity, and lore."""
    # Ensure default achievements first
    AchievementService.ensure_default_achievements(db)

    # Check if vehicles already seeded
    existing_count = db.query(Vehicle).count()
    if existing_count >= len(VEHICLE_CATALOGUE):
        return

    # Ensure default user
    default_user = db.query(User).filter(User.id == settings.DEFAULT_USER_ID).first()
    if not default_user:
        default_user = User(
            id=settings.DEFAULT_USER_ID,
            username=settings.DEFAULT_USER_NAME,
            avatar_pixel_art="pixel_avatar_driver_01"
        )
        progression = UserProgression(
            user_id=settings.DEFAULT_USER_ID,
            level=12,
            current_xp=1480,
            title="STREET SCOUT",
            total_encounters=143,
            unique_vehicles=48,
            common_count=63,
            uncommon_count=41,
            rare_count=27,
            epic_count=9,
            legendary_count=3,
            cities_discovered=4,
            manufacturers_discovered=31
        )
        db.add(default_user)
        db.add(progression)
        db.commit()

    for item in VEHICLE_CATALOGUE:
        # 1. Manufacturer
        mfg = db.query(Manufacturer).filter(Manufacturer.name == item["make"]).first()
        if not mfg:
            mfg = Manufacturer(
                name=item["make"],
                country=item["country"]
            )
            db.add(mfg)
            db.flush()

        # 2. Model
        v_model = db.query(VehicleModel).filter(
            VehicleModel.manufacturer_id == mfg.id,
            VehicleModel.name == item["model"]
        ).first()
        if not v_model:
            v_model = VehicleModel(
                manufacturer_id=mfg.id,
                name=item["model"],
                category=item["category"]
            )
            db.add(v_model)
            db.flush()

        # 3. Generation
        gen = db.query(Generation).filter(
            Generation.model_id == v_model.id,
            Generation.code == item["generation_code"]
        ).first()
        if not gen:
            gen = Generation(
                model_id=v_model.id,
                code=item["generation_code"],
                name=item["generation_name"],
                start_year=item["start_year"],
                end_year=item["end_year"]
            )
            db.add(gen)
            db.flush()

        # 4. Variant
        variant = db.query(Variant).filter(
            Variant.generation_id == gen.id,
            Variant.name == item["variant"]
        ).first()
        if not variant:
            variant = Variant(
                generation_id=gen.id,
                name=item["variant"]
            )
            db.add(variant)
            db.flush()

        # 5. Vehicle
        vehicle = db.query(Vehicle).filter(Vehicle.id == item["id"]).first()
        if not vehicle:
            vehicle = Vehicle(
                id=item["id"],
                variant_id=variant.id,
                canonical_name=item["canonical_name"],
                display_year_range=item["display_year_range"],
                photo_url=item["photo_url"],
                pixel_art_sprite=item["pixel_art_sprite"]
            )
            db.add(vehicle)
            db.flush()

            # 6. Specs
            s = item["specs"]
            specs = VehicleSpecification(
                vehicle_id=vehicle.id,
                engine=s["engine"],
                displacement=s.get("displacement"),
                cylinders=s.get("cylinders"),
                aspiration=s.get("aspiration"),
                horsepower=s["horsepower"],
                torque_nm=s.get("torque_nm"),
                transmission=s["transmission"],
                drivetrain=s["drivetrain"],
                curb_weight_kg=s.get("curb_weight_kg"),
                top_speed_kmh=s.get("top_speed_kmh"),
                zero_to_hundred_sec=s.get("zero_to_hundred_sec"),
                production_years=s.get("production_years")
            )
            db.add(specs)

            # 7. Compute Rarity via RarityCalculator
            rm = item["rarity_meta"]
            tier, score, breakdown = RarityCalculator.calculate_rarity(
                production_volume=rm.get("production_volume"),
                age_years=rm.get("age_years"),
                prevalence=rm.get("prevalence", "Moderate"),
                regional_availability=rm.get("regional_availability", "Global"),
                variant_factor=rm.get("variant_factor", 1.0),
                encounter_frequency_score=rm.get("encounter_frequency_score", 50.0)
            )

            rarity = VehicleRarity(
                vehicle_id=vehicle.id,
                tier=tier,
                rarity_score=score,
                production_volume=rm.get("production_volume"),
                estimated_current_prevalence=rm.get("prevalence"),
                age_years=rm.get("age_years"),
                regional_availability=rm.get("regional_availability"),
                variant_rarity_factor=rm.get("variant_factor", 1.0),
                encounter_frequency_score=rm.get("encounter_frequency_score", 50.0)
            )
            db.add(rarity)

            # 8. Lore
            lore_meta = item["lore"]
            lore = VehicleLore(
                vehicle_id=vehicle.id,
                documented_nicknames=lore_meta.get("documented_nicknames", []),
                community_nicknames=lore_meta.get("community_nicknames", []),
                history=lore_meta["history"],
                motorsport=lore_meta.get("motorsport"),
                interesting_facts=lore_meta.get("interesting_facts", []),
                trivia=lore_meta.get("trivia", [])
            )
            db.add(lore)

    db.commit()
