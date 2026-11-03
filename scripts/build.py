"""Zip src/ into dist/NamesOfTheMojave.zip (the zip root is the game's Data folder).

    python scripts/build.py [version]

With a version (the release workflow passes the tag's), the build fails if Main.gek
sets a different one, so the log and the MCM page show the released version.
Stdlib only, so CI can run it on a bare Python install.
"""
import sys
import zipfile
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
SOURCE = ROOT / "src"
OUTPUT = ROOT / "dist" / "NamesOfTheMojave.zip"
MAIN = SOURCE / "NVSE" / "user_defined_functions" / "NamesOfTheMojave" / "Main.gek"


def main():
    if len(sys.argv) > 1:
        expected = f'"*NotM:Version" "{sys.argv[1]}"'
        if expected not in MAIN.read_text(encoding="utf-8"):
            sys.exit(f"Main.gek does not set version {sys.argv[1]}: update *NotM:Version first")

    OUTPUT.parent.mkdir(exist_ok=True)
    with zipfile.ZipFile(OUTPUT, "w", zipfile.ZIP_DEFLATED) as archive:
        for path in sorted(SOURCE.rglob("*")):
            if path.is_file() and path.name != ".gitkeep":
                archive.write(path, path.relative_to(SOURCE).as_posix())
    print(f"Built {OUTPUT}")


if __name__ == "__main__":
    main()
