from pathlib import Path

from app.schemas.staff_card import StaffCardPublicResponse


def test_public_card_schema_excludes_private_and_secret_fields() -> None:
    fields = StaffCardPublicResponse.model_fields
    assert "verification_token" not in fields
    assert "card_id" not in fields
    staff_fields = fields["staff"].annotation.model_fields
    assert "email" not in staff_fields
    assert "phone" not in staff_fields
    assert "id" not in staff_fields


def test_admin_layout_validates_token_with_backend() -> None:
    source = (Path(__file__).parents[2] / "ghatosite" / "app" / "admin" / "layout.tsx").read_text(encoding="utf-8")
    assert "/api/v1/auth/me" in source
    assert "localStorage.removeItem" in source


def test_settings_routes_require_super_admin() -> None:
    source = (Path(__file__).parents[1] / "app" / "api" / "routes" / "settings.py").read_text(encoding="utf-8")
    assert source.count("Depends(require_super_admin)") == 4
    assert source.count('@router.post("/admin/upload"') == 1


def test_startup_does_not_seed_staff() -> None:
    main_source = (Path(__file__).parents[1] / "app" / "main.py").read_text(encoding="utf-8")
    assert "seed_initial_staff" not in main_source
