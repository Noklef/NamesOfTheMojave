"""Zip the mod or one add-on into dist/ (the zip root is the game's Data folder).

    python scripts/build.py [version]          src/ -> dist/NamesOfTheMojave.zip and dist/NamesOfTheMojave-INI.zip
    python scripts/build.py --addon <Name>     addons/<Name> -> dist/NotM-Addon-<Name>.zip

With a version (the release workflow passes the tag's), the build fails if Main.gek
sets a different one, so the log and the MCM page show the released version.
Stdlib only, so CI can run it on a bare Python install.
"""
import sys
import zipfile
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
SOURCE = ROOT / "src"
ADDONS = ROOT / "addons"
DIST = ROOT / "dist"
MAIN = SOURCE / "NVSE" / "user_defined_functions" / "NamesOfTheMojave" / "Main.gek"
INI = SOURCE / "Config" / "NamesOfTheMojave.ini"


def zip_folder(folder, output, skip):
    with zipfile.ZipFile(output, "w", zipfile.ZIP_DEFLATED) as archive:
        for path in sorted(folder.rglob("*")):
            if path.is_file() and path.name not in skip:
                archive.write(path, path.relative_to(folder).as_posix())
    print(f"Built {output}")


def main():
    DIST.mkdir(exist_ok=True)

    if "--addon" in sys.argv:
        index = sys.argv.index("--addon") + 1
        name = sys.argv[index] if index < len(sys.argv) else ""
        addons = [path.name for path in ADDONS.iterdir() if path.is_dir()] if ADDONS.is_dir() else []
        # Only an exact add-on folder name (the name comes from the workflow input, so no paths like ../src)
        if name not in addons:
            sys.exit(f"No add-on folder addons/{name}. Add-ons: {', '.join(sorted(addons))}")
        # Leaves out every README.md (any folder)
        zip_folder(ADDONS / name, DIST / f"NotM-Addon-{name}.zip", {"README.md"})
        return

    if len(sys.argv) > 1:
        expected = f'"*NotM:Version" "{sys.argv[1]}"'
        if expected not in MAIN.read_text(encoding="utf-8"):
            sys.exit(f"Main.gek does not set version {sys.argv[1]}: update *NotM:Version first")

    zip_folder(SOURCE, DIST / "NamesOfTheMojave.zip", {".gitkeep"})

    ini_zip = DIST / "NamesOfTheMojave-INI.zip"
    with zipfile.ZipFile(ini_zip, "w", zipfile.ZIP_DEFLATED) as archive:
        archive.write(INI, INI.relative_to(SOURCE).as_posix())
    print(f"Built {ini_zip}")


if __name__ == "__main__":
    main()
