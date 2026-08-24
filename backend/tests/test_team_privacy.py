from pathlib import Path


def test_about_page_does_not_reference_team_photos_or_full_names() -> None:
    about_page = Path(__file__).parents[2] / "ghatosite" / "app" / "about" / "page.tsx"
    source = about_page.read_text(encoding="utf-8")
    assert "/team/" not in source
    for full_name in ("Prosper Kayode", "Tosin Adeniran", "Jummai Madaki", "Bukky Alabi"):
        assert full_name not in source
    for public_name in ("P. K. Michael", "T. Adeniran", "J. Maidaki", "B. Alabi"):
        assert public_name in source
