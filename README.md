# ROVE 🚗🕹️
> **Real-World Automotive Discovery & Archive**
> *The Retro Automotive Field Collector*

ROVE is a mobile-first real-world automotive discovery and collection application. When you encounter an interesting vehicle on the street, you open ROVE, capture a photograph, and our vision neural engine identifies the vehicle down to its exact make, model, generation, and variant. The vehicle is assigned an authentic, data-driven **rarity tier** (from Common to Legendary and Mythic), awards XP, unlocks vintage pixel-art badges, and archives the discovery with its location into your personal collection.

---

## 🎨 Visual Identity & Signature Contrast

ROVE is built upon a signature aesthetic contrast:
**REAL-WORLD CAR PHOTOGRAPHS + BESPOKE 8-BIT RETRO AUTOMOTIVE ART**

- **Authentic Contrast**: The vehicle photographs remain real-world photographs—the physical evidence of your street discovery—framed by sharp, tactile pixel borders, scanlines, and 8-bit accents.
- **Dedicated Automotive Palette**: Custom warm cream (`#F4F1EA`), deep charcoal (`#141618`), retro racing green (`#4B8B3B`), gauge amber (`#D99B26`), vintage racing red (`#C83E34`), and arcade steel blue (`#4A6B82`). No generic purple/blue gradients or modern SaaS glassmorphism.
- **Typography Hierarchy**: Monospace retro display typography for vehicle names, gauges, rarity badges, and level titles; clean, highly legible typography for technical specifications, horsepower figures, and long-form automotive history.
- **Dynamic 8-Bit Road Scene**: Animated home screen featuring twinkling pixel stars, distant mountain silhouettes, city lights, and an 8-bit sports car cruising across a dual-lane asphalt highway.
- **Retro Camera Viewfinder**: Realistic optical framing with blinking `REC` indicator, photo counter, and tactile shutter button. No fake sci-fi HUDs.

---

## ⚡ Core Loop

```
OPEN ROVE
    ↓
HOME (Road scene + career stats + recent discoveries)
    ↓
TAP CAPTURE
    ↓
RETRO CAMERA OPENS (Viewfinder + framing guide)
    ↓
PHOTOGRAPH A CAR (or select demo preset)
    ↓
AI VISION IDENTIFICATION
    ↓
LOW-CONFIDENCE RESOLUTION ("We think this is..." alternative candidates if confidence < 75%)
    ↓
DISCOVERY REVEAL (Particle animation + star tier reveal + XP popup)
    ↓
ADD TO COLLECTION (Saves encounter count, timestamp, and location)
    ↓
INSPECT FULL SPECIFICATIONS & LORE (343 HP, S54 I6, documented nicknames like "CLOWN SHOE" / "GODZILLA")
    ↓
EARN XP & UNLOCK ACHIEVEMENTS (Street Scout, Kanjo Scout, Blue Spark)
```

---

## 🛠️ Technology Stack

| Layer | Technologies |
|---|---|
| **Mobile Client** | **Flutter 3.47+**, **Dart 3.13+**, Material Retro Canvas, Custom Painters, Haptics |
| **Backend API** | **Python 3.14+**, **FastAPI**, **Uvicorn**, **Pydantic v2** |
| **Database** | **SQLAlchemy 2.0**, **SQLite** (local zero-config) / **PostgreSQL + PostGIS** (production) |
| **AI Vision Engine** | `BaseVisionProvider` abstraction with **MockVisionProvider** (instant offline demo) and **Gemini 2.5/Flash Vision** connector |
| **Testing** | **pytest** (backend unit/integration) & **flutter_test** (widget & full flow tests) |

---

## 📂 Project Architecture & Directory Layout

```
Rove/
├── backend/                       # Python FastAPI Backend
│   ├── app/
│   │   ├── core/
│   │   │   ├── branding.py        # Centralized brand constants, palette tokens, rarity tiers
│   │   │   └── config.py          # Environment settings (DB, AI Provider, threshold)
│   │   ├── database.py            # SQLAlchemy engine, session maker, SQLite/Postgres support
│   │   ├── models/                # Database domain models
│   │   │   ├── user.py            # User, UserProgression
│   │   │   ├── vehicle.py         # Manufacturer → Model → Generation → Variant → Vehicle, Specs, Lore, Rarity
│   │   │   ├── encounter.py       # Encounter, UserCollection
│   │   │   └── achievement.py     # Achievement, UserAchievement
│   │   ├── schemas/               # Pydantic serialization schemas
│   │   ├── services/
│   │   │   ├── rarity_service.py  # Deterministic multi-factor automotive rarity engine
│   │   │   ├── xp_service.py      # Tier-based XP, level scaling, title calculation
│   │   │   ├── achievement_service.py # Automated achievement evaluation
│   │   │   └── vision_ai_service.py   # AI vision provider interface + mock provider
│   │   ├── seed/
│   │   │   └── seed_data.py       # Global vehicle catalogue (Indian, Japanese, German, American, etc.)
│   │   ├── routers/               # API Endpoints
│   │   │   ├── branding.py        # GET /branding
│   │   │   ├── vehicles.py        # GET /vehicles, GET /vehicles/{id}
│   │   │   ├── identify.py        # POST /identify, POST /capture/confirm
│   │   │   ├── collection.py      # GET /collection
│   │   │   ├── encounters.py      # GET /encounters, GET /encounters/map
│   │   │   ├── achievements.py    # GET /achievements
│   │   │   ├── stats.py           # GET /stats
│   │   │   └── demo.py            # POST /demo/reset, POST /demo/seed-starter
│   │   └── main.py                # FastAPI initialization, CORS, Lifespan auto-seed
│   ├── tests/
│   │   └── test_backend.py        # 10 comprehensive pytest suites
│   ├── requirements.txt
│   └── run.py
│
├── rove_app/                      # Flutter Cross-Platform Mobile Client
│   ├── lib/
│   │   ├── core/
│   │   │   ├── branding/          # Centralized branding, colors, RarityTier enhanced enum
│   │   │   ├── theme/             # Pixel display typography & readable body text
│   │   │   └── widgets/           # PixelButton, PixelCard, PixelBadge, PixelRoadScene,
│   │   │                          # PixelCameraFrame, PixelParticles, PixelAvatar
│   │   ├── domain/models/         # Vehicle, Specification, Lore, Encounter, Achievement, UserProfile
│   │   ├── data/seed/             # Complete offline seed dataset for instant demo mode
│   │   ├── services/
│   │   │   ├── rove_repository.dart # State manager, offline/online sync, capture processor
│   │   │   └── audio_service.dart   # Retro tactile feedback & chimes
│   │   ├── features/
│   │   │   ├── home/              # Home dashboard, road scene, rarity matrix, recent cards
│   │   │   ├── capture/           # Viewfinder camera, preset tester, low-confidence dialog
│   │   │   ├── discovery_reveal/  # Pixel particle reveal, rarity badges, XP reward
│   │   │   ├── collection/        # Filterable archive grid ([ALL] [COMMON] ... [LEGENDARY])
│   │   │   ├── vehicle_detail/    # Real photo frame, headline specs, expandable technical blueprint, lore
│   │   │   ├── map/               # 8-bit stylized discovery map with interactive pins
│   │   │   ├── achievements/      # Retro badges and milestone tracking
│   │   │   ├── profile/           # Driver avatar, career statistics, rarity breakdown
│   │   │   └── settings/          # Demo mode toggle, sync endpoint, location privacy, reset
│   │   ├── app.dart               # Tab scaffold & retro bottom navigation
│   │   └── main.dart              # Flutter entrypoint
│   └── test/
│       ├── widget_test.dart       # Home screen and tab navigation tests
│       └── flow_test.dart         # Core capture to discovery reveal integration test
│
└── README.md
```

---

## 🚀 How to Run

### 1. Running the FastAPI Backend

```bash
# In the project root:
cd backend

# Create virtual environment (if not already created)
python -m venv ../venv_backend
..\venv_backend\Scripts\pip install -r requirements.txt

# Run the backend server
$env:PYTHONPATH="."
..\venv_backend\Scripts\uvicorn.exe app.main:app --host 127.0.0.1 --port 8000 --reload
```

The server will automatically create the database tables, seed the global vehicle catalogue, and start listening on:
- API Root: `http://127.0.0.1:8000`
- Interactive Swagger Docs: `http://127.0.0.1:8000/docs`
- ReDoc: `http://127.0.0.1:8000/redoc`

### 2. Running the Flutter Mobile App

The Flutter application can run on **iOS Simulator**, **Android Emulator**, **Windows Desktop**, or **Web**:

```bash
cd rove_app

# Fetch dependencies
flutter pub get

# Run on available device
flutter run
```

### 3. Demo Mode (Zero Credentials Required)
ROVE contains a 100% self-contained **Demo Mode** enabled by default:
- No Gemini AI keys, Google Maps keys, or external database credentials are required.
- In the Camera Viewfinder, you can choose from preset demo vehicles (*BMW M3 E46*, *Porsche 911 GT3*, *Nissan Skyline GT-R R32*, *Ferrari 458 Italia*, *Maruti Suzuki Swift*, *McLaren F1*).
- Toggle **LOW CONF** in the camera app bar to experience the low-confidence confirmation flow with alternative candidates (*"WE THINK THIS IS..."*).
- Tap **CAPTURE PHOTO** to trigger the complete identification, particle reveal, rarity calculation, XP reward, and collection archiving.

---

## 🧪 Testing Everything

### Backend Tests (pytest)
```bash
cd backend
$env:PYTHONPATH="."
..\venv_backend\Scripts\python.exe -m pytest -v
```
**Results**:
- `test_root_endpoint`: PASSED
- `test_branding_endpoint`: PASSED
- `test_rarity_calculation_mclaren_f1`: PASSED (produces LEGENDARY/MYTHIC tier)
- `test_rarity_calculation_maruti_swift`: PASSED (produces COMMON tier)
- `test_xp_and_level_progression`: PASSED
- `test_vision_mock_provider_high_confidence`: PASSED
- `test_vision_mock_provider_low_confidence`: PASSED
- `test_vehicles_api`: PASSED
- `test_vehicle_detail_api`: PASSED
- `test_capture_and_collection_flow`: PASSED

### Flutter Mobile App Tests
```bash
cd rove_app
flutter test
```
**Results**:
- `Core Capture to Discovery Reveal flow test`: PASSED
- `ROVE smoke test - checks home screen and tab navigation`: PASSED
- `Rarity tier model and XP tests`: PASSED

### Code Quality & Static Analysis
```bash
cd rove_app
flutter analyze
```
**Results**:
- `No issues found! (ran in 5.9s)`

---

## 🏆 Rarity & Progression System

### Deterministic Rarity Factors
Rarity is computed dynamically by `RarityCalculator` in `rarity_service.py` using authentic automotive parameters:
1. **Production Volume Score** (0–35 pts): E.g., McLaren F1 (106 built) gets 35 pts; mass-production vehicles get 2 pts.
2. **Age & Survival Score** (0–20 pts): Historic classics (>30–50 years old) with low survival rates receive high scores.
3. **Current Survival Prevalence** (0–20 pts): Ultra Rare, Very Rare, Low, Moderate, High, Everyday.
4. **Regional Availability Bonus** (0–10 pts): E.g., JDM Only, Homologation Special.
5. **Variant Rarity Multiplier** (0–15 pts): Special homologation trims (CSL, GT3 RS, Evo II) boost tier.

### Tiers & Configurable XP
| Tier | Stars | Badge Symbol | Base XP | Duplicate XP | Example |
|---|---|---|---|---|---|
| **COMMON** | ★ | `[ C ]` | +10 XP | +25 XP | Maruti Suzuki Swift Mk1 |
| **UNCOMMON** | ★★ | `[ U ]` | +25 XP | +25 XP | Mahindra Thar Gen 2, Hyundai Ioniq 5 N |
| **RARE** | ★★★ | `[ R ]` | +50 XP | +25 XP | BMW M3 E46, Hindustan Ambassador |
| **EPIC** | ★★★★ | `[ E ]` | +100 XP | +25 XP | BMW Z3 M Coupe, Nissan Skyline GT-R R32, Ferrari 458 |
| **LEGENDARY** | ★★★★★ | `[ L ]` | +250 XP | +25 XP | McLaren F1, Ford Mustang Boss 429 |
| **MYTHIC** | ★★★★★★ | `[ M ]` | +500 XP | +25 XP | 1-of-1 prototypes or bespoke homologations |

### Level Titles
- Level 1: `NOVICE SPOTTER`
- Level 3: `STREET SCOUT`
- Level 6: `CURB DETECTIVE`
- Level 10: `ROAD HUNTER`
- Level 15: `PADDOCK SCOUT`
- Level 20: `CAR CONNOISSEUR`
- Level 30: `ASPHALT ARCHIVIST`
- Level 50: `APEX LEGEND`

---

## 🗺️ Geospatial & Privacy Safeguards

- Every encounter stores timestamp, approximate city, and optional latitude/longitude.
- **Privacy Mode**: Exact street coordinates are never publicly exposed. The app uses fuzzy sector centering for locations and discovery maps.
- **Optional GPS**: If location permission is denied by the user, the application operates with zero degradation.

---

## 🚢 Production Deployment

### Database (PostgreSQL / Supabase)
1. In `backend/app/core/config.py` or `.env`, set:
   ```env
   DATABASE_URL=postgresql://user:password@host:5432/rove_db
   ```
2. Enable PostGIS extension for spatial queries:
   ```sql
   CREATE EXTENSION IF NOT EXISTS postgis;
   ```

### Real AI Provider Setup
1. In `.env`:
   ```env
   AI_PROVIDER=gemini
   GEMINI_API_KEY=your_gemini_api_key_here
   ```
2. The vision neural engine automatically routes incoming photos through Gemini Vision structured output while retaining the mock provider fallback if offline.
