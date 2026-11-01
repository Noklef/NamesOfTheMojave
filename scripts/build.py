"""Zip src/ into dist/NamesOfTheMojave.zip (the zip root is the game's Data folder).

    python scripts/build.py

Stdlib only, so CI can run it on a bare Python install.
"""
import zipfile
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
SOURCE = ROOT / "src"
OUTPUT = ROOT / "dist" / "NamesOfTheMojave.zip"


def main():
    OUTPUT.parent.mkdir(exist_ok=True)
    with zipfile.ZipFile(OUTPUT, "w", zipfile.ZIP_DEFLATED) as archive:
        for path in sorted(SOURCE.rglob("*")):
            if path.is_file() and path.name != ".gitkeep":
                archive.write(path, path.relative_to(SOURCE).as_posix())
    print(f"Built {OUTPUT}")


if __name__ == "__main__":
    main()
