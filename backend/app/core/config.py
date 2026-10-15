import os
from pydantic import BaseModel

class Settings(BaseModel):
    APP_NAME: str = "ROVE"
    ENVIRONMENT: str = os.getenv("ROVE_ENV", "development")
    DATABASE_URL: str = os.getenv("DATABASE_URL", "sqlite:///./rove.db")
    AI_PROVIDER: str = os.getenv("AI_PROVIDER", "mock")  # "mock" or "gemini" or "vision_api"
    GEMINI_API_KEY: str = os.getenv("GEMINI_API_KEY", "")
    DEFAULT_USER_ID: str = os.getenv("DEFAULT_USER_ID", "user_puru_01")
    DEFAULT_USER_NAME: str = os.getenv("DEFAULT_USER_NAME", "PURU")
    DEMO_MODE: bool = os.getenv("DEMO_MODE", "true").lower() in ("true", "1", "yes")
    LOW_CONFIDENCE_THRESHOLD: float = float(os.getenv("LOW_CONFIDENCE_THRESHOLD", "0.75"))

settings = Settings()
