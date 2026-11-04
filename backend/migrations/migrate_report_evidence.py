"""Move legacy report evidence out of public uploads after a verified backup.

Run inside the backend container: python -m migrations.migrate_report_evidence [--apply]
The default is read-only. Keep the backup until all evidence opens in admin.
"""

import argparse
import hashlib
import json
import shutil
from pathlib import Path

from app.core.config import settings
from app.db.session import SessionLocal
from app.models.report import Report


def digest(path: Path) -> str:
    value = hashlib.sha256()
    with path.open("rb") as source:
        for chunk in iter(lambda: source.read(1024 * 1024), b""):
            value.update(chunk)
    return value.hexdigest()


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--apply", action="store_true", help="Copy, update references, then remove public originals")
    args = parser.parse_args()

    public_dir = Path(settings.MEDIA_UPLOAD_DIR).resolve()
    private_dir = Path(settings.PRIVATE_EVIDENCE_DIR).resolve()
    if private_dir == public_dir or public_dir in private_dir.parents:
        raise RuntimeError("Private evidence directory must be outside public uploads")

    with SessionLocal() as db:
        reports = db.query(Report).filter(Report.evidence_url.like("/uploads/%")).order_by(Report.id).all()
        entries = []
        for report in reports:
            name = report.evidence_url.removeprefix("/uploads/")
            if not name or Path(name).name != name:
                raise RuntimeError(f"Unsafe evidence path on report {report.id}")
            source = public_dir / name
            if not source.is_file():
                raise RuntimeError(f"Missing evidence on report {report.id}: {name}")
            entries.append((report, name, source, private_dir / name))

        print(f"Legacy report evidence files: {len(entries)}")
        if not args.apply or not entries:
            return

        private_dir.mkdir(parents=True, exist_ok=True, mode=0o700)
        manifest = private_dir / "migration-manifest.json"
        if manifest.exists():
            raise RuntimeError("Existing migration manifest; inspect it before another apply")
        manifest.write_text(json.dumps([{"report_id": report.id, "filename": name} for report, name, _, _ in entries], indent=2), encoding="utf-8")
        manifest.chmod(0o600)

        for report, name, source, target in entries:
            if target.exists():
                if digest(source) != digest(target):
                    raise RuntimeError(f"Private destination differs for report {report.id}")
            else:
                shutil.copy2(source, target)
                target.chmod(0o600)
            if digest(source) != digest(target):
                raise RuntimeError(f"Copy verification failed for report {report.id}")
            report.evidence_url = f"private:{name}"

        db.commit()
        for _, _, source, _ in entries:
            source.unlink()
        print(f"Migrated {len(entries)} reports; public originals removed. Manifest: {manifest}")


if __name__ == "__main__":
    main()
