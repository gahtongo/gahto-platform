from functools import lru_cache
from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    ENVIRONMENT: str = "development"
    APP_NAME: str = "GAHTO Backend"
    APP_VERSION: str = "1.0.0"
    DEBUG: bool = False

    API_V1_PREFIX: str = "/api/v1"

    SECRET_KEY: str = "development-only-change-me"
    ALGORITHM: str = "HS256"
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 60 * 24

    DATABASE_URL: str = "sqlite:///./gahto.db"

    BACKEND_CORS_ORIGINS: str = ""

    FIRST_SUPERADMIN_EMAIL: str = ""
    FIRST_SUPERADMIN_PASSWORD: str = ""

    MEDIA_UPLOAD_DIR: str = "uploads"
    MAX_UPLOAD_SIZE_MB: int = 20

    SMTP_HOST: str = ""
    SMTP_PORT: int = 587
    SMTP_USERNAME: str = ""
    SMTP_PASSWORD: str = ""
    SMTP_FROM_EMAIL: str = ""
    SMTP_FROM_NAME: str = "GAHTO"

    OPENAI_API_KEY: str = ""
    AI_CHAT_MODEL: str = "gpt-5.4"
    AI_OPTIMIZER_MODEL: str = "gpt-5.4"

    # ✅ ADD THESE PROPERLY HERE
    PAYSTACK_SECRET_KEY: str = ""
    PAYSTACK_PUBLIC_KEY: str = ""
    STRIPE_SECRET_KEY: str = ""
    STRIPE_PUBLISHABLE_KEY: str = ""
    FRONTEND_URL: str = "http://localhost:3000"

    WHATSAPP_PROVIDER: str = ""
    WHATSAPP_API_KEY: str = ""
    WHATSAPP_SENDER_ID: str = ""

    RESEND_API_KEY: str = ""
    EMAIL_FROM: str = ""
    ADMIN_NOTIFICATION_EMAILS: str = "admin@gahto.org"
    CONTACT_NOTIFICATION_RECIPIENTS: str = ""

    model_config = SettingsConfigDict(
        env_file=".env",
        env_file_encoding="utf-8",
        case_sensitive=True,
        extra="ignore",
    )

    @property
    def cors_origins_list(self) -> list[str]:
        if not self.BACKEND_CORS_ORIGINS.strip():
            return []
        return [
            origin.strip()
            for origin in self.BACKEND_CORS_ORIGINS.split(",")
            if origin.strip()
        ]

    @property
    def is_production(self) -> bool:
        return self.ENVIRONMENT.strip().lower() == "production"


@lru_cache
def get_settings() -> Settings:
    return Settings()


settings = get_settings()
