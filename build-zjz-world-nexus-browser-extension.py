#!/usr/bin/env python3
from __future__ import annotations

import json
import tempfile
import shutil
import subprocess
import zipfile
from pathlib import Path


ROOT = Path(__file__).resolve().parent
EXTENSION_ROOT = ROOT / "extensions" / "zjz-world-nexus-browser-extension"
EXTENSION_SRC_ROOT = EXTENSION_ROOT / "src"
PUBLIC_ROOT = ROOT / "public"
DIST_ROOT = ROOT / "dist" / "zjz-world-nexus-browser-extension"
CHROME_DIST_ROOT = DIST_ROOT / "chrome"
WEB_EXTENSION_DIST_ROOT = DIST_ROOT / "web-extension"
CHROME_ZIP_PATH = DIST_ROOT / "chrome-web-store" / "zjz-world-nexus-browser-extension.zip"
SAFARI_WEB_EXTENSION_ZIP_PATH = DIST_ROOT / "safari-web-extension" / "zjz-world-nexus-safari-web-extension.zip"

EXTENSION_VERSION = "0.1.1"
ICON_SOURCE_PATH = PUBLIC_ROOT / "shared" / "icons" / "zjz.svg"
ICON_SIZES = (16, 32, 48, 64, 128, 256, 512)


def ensure_command(command: str) -> None:
    if shutil.which(command):
        return
    raise SystemExit(f"Required command is not available: {command}")


def ensure_clean_directory(path: Path) -> None:
    if path.exists():
        shutil.rmtree(path)
    path.mkdir(parents=True, exist_ok=True)


def copy_tree(source: Path, destination: Path) -> None:
    for source_path in source.rglob("*"):
        if source_path.is_dir():
            continue
        relative_path = source_path.relative_to(source)
        destination_path = destination / relative_path
        destination_path.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(source_path, destination_path)


def write_manifest(destination_root: Path) -> None:
    template_path = EXTENSION_SRC_ROOT / "manifest-template.json"
    manifest = json.loads(template_path.read_text(encoding="utf-8"))
    manifest["version"] = EXTENSION_VERSION
    manifest_path = destination_root / "manifest.json"
    manifest_path.write_text(
        json.dumps(manifest, ensure_ascii=True, indent=2) + "\n",
        encoding="utf-8",
    )


def copy_fonts(destination_root: Path) -> None:
    fonts_source_root = PUBLIC_ROOT / "shared" / "fonts"
    fonts_destination_root = destination_root / "assets" / "fonts"
    fonts_destination_root.mkdir(parents=True, exist_ok=True)
    for source_path in sorted(fonts_source_root.glob("*")):
        if source_path.is_dir():
            continue
        shutil.copy2(source_path, fonts_destination_root / source_path.name)


def copy_shared_icons(destination_root: Path) -> None:
    icons_source_root = PUBLIC_ROOT / "shared" / "icons"
    icons_destination_root = destination_root / "assets" / "shared-icons"
    icons_destination_root.mkdir(parents=True, exist_ok=True)
    for source_path in sorted(icons_source_root.glob("*")):
        if source_path.is_dir():
            continue
        shutil.copy2(source_path, icons_destination_root / source_path.name)


def build_icons(destination_root: Path) -> None:
    ensure_command("sips")
    icons_destination_root = destination_root / "icons"
    icons_destination_root.mkdir(parents=True, exist_ok=True)
    raster_source_path = ICON_SOURCE_PATH
    temporary_directory: tempfile.TemporaryDirectory[str] | None = None
    if ICON_SOURCE_PATH.suffix.lower() == ".svg":
        ensure_command("qlmanage")
        temporary_directory = tempfile.TemporaryDirectory()
        temporary_root = Path(temporary_directory.name)
        subprocess.run(
            [
                "qlmanage",
                "-t",
                "-s",
                str(max(ICON_SIZES)),
                "-o",
                str(temporary_root),
                str(ICON_SOURCE_PATH),
            ],
            check=True,
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
        )
        raster_source_path = temporary_root / f"{ICON_SOURCE_PATH.name}.png"
        if not raster_source_path.exists():
            temporary_directory.cleanup()
            raise SystemExit(f"Icon rasterization failed: {ICON_SOURCE_PATH}")
    for size in ICON_SIZES:
        output_path = icons_destination_root / f"icon-{size}.png"
        subprocess.run(
            [
                "sips",
                "-z",
                str(size),
                str(size),
                str(raster_source_path),
                "--out",
                str(output_path),
            ],
            check=True,
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
        )
    if temporary_directory is not None:
        temporary_directory.cleanup()


def zip_extension(source_root: Path, zip_path: Path) -> None:
    zip_path.parent.mkdir(parents=True, exist_ok=True)
    if zip_path.exists():
        zip_path.unlink()
    with zipfile.ZipFile(zip_path, "w", compression=zipfile.ZIP_DEFLATED) as archive:
        for source_path in sorted(source_root.rglob("*")):
            if source_path.is_dir():
                continue
            archive.write(source_path, source_path.relative_to(source_root).as_posix())


def build_extension(destination_root: Path) -> None:
    ensure_clean_directory(destination_root)
    copy_tree(EXTENSION_SRC_ROOT, destination_root)
    write_manifest(destination_root)
    manifest_template_path = destination_root / "manifest-template.json"
    if manifest_template_path.exists():
        manifest_template_path.unlink()
    copy_fonts(destination_root)
    copy_shared_icons(destination_root)
    build_icons(destination_root)


def main() -> None:
    DIST_ROOT.mkdir(parents=True, exist_ok=True)
    build_extension(CHROME_DIST_ROOT)
    build_extension(WEB_EXTENSION_DIST_ROOT)
    zip_extension(CHROME_DIST_ROOT, CHROME_ZIP_PATH)
    zip_extension(WEB_EXTENSION_DIST_ROOT, SAFARI_WEB_EXTENSION_ZIP_PATH)
    print(f"Built Chrome extension: {CHROME_DIST_ROOT}")
    print(f"Built Safari web extension source: {WEB_EXTENSION_DIST_ROOT}")
    print(f"Built Chrome Web Store zip: {CHROME_ZIP_PATH}")
    print(f"Built Safari web extension zip: {SAFARI_WEB_EXTENSION_ZIP_PATH}")


if __name__ == "__main__":
    main()
