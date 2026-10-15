from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.core.config import settings
from app.core.branding import BRAND_NAME, BRAND_TAGLINE, APP_VERSION
from app.database import engine, Base, SessionLocal
from app.seed.seed_data import seed_database_catalogue
from app.routers import (
    branding,
    vehicles,
    identify,
    collection,
    encounters,
    achievements,
    stats,
    demo
)

from contextlib import asynccontextmanager

@asynccontextmanager
async def lifespan(app: FastAPI):
    # Ensure tables exist and database catalogue is seeded
    Base.metadata.create_all(bind=engine)
    db = SessionLocal()
    try:
        seed_database_catalogue(db)
    finally:
        db.close()
    yield

app = FastAPI(
    title=BRAND_NAME,
    description=BRAND_TAGLINE,
    version=APP_VERSION,
    docs_url="/docs",
    redoc_url="/redoc",
    lifespan=lifespan
)

# Ensure DB tables created and seeded immediately on import for test harnesses
Base.metadata.create_all(bind=engine)
db_init = SessionLocal()
try:
    seed_database_catalogue(db_init)
finally:
    db_init.close()

# CORS middleware for mobile apps and dev tools
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include Routers
app.include_router(branding.router)
app.include_router(vehicles.router)
app.include_router(identify.router)
app.include_router(collection.router)
app.include_router(encounters.router)
app.include_router(achievements.router)
app.include_router(stats.router)
app.include_router(demo.router)

@app.get("/")
def root():
    return {
        "app": BRAND_NAME,
        "tagline": BRAND_TAGLINE,
        "version": APP_VERSION,
        "status": "ONLINE",
        "docs": "/docs"
    }
