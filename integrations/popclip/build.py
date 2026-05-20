#!/usr/bin/env python3

import os
import shutil
import zipfile
from pathlib import Path

SCRIPT_DIR = Path(__file__).resolve().parent
DIST_DIR = SCRIPT_DIR / "dist"
EXT_DIR_NAME = "beyondtranslate.popclipext"
EXT_DIR = SCRIPT_DIR / EXT_DIR_NAME
EXTZ_FILE = SCRIPT_DIR / (EXT_DIR_NAME + "z")

# Clean up previous build artifacts
if DIST_DIR.exists():
    shutil.rmtree(DIST_DIR)
if EXT_DIR.exists():
    shutil.rmtree(EXT_DIR)
if EXTZ_FILE.exists():
    EXTZ_FILE.unlink()

# Prepare extension directory
os.makedirs(DIST_DIR)
os.makedirs(EXT_DIR)

# Copy files
shutil.copy(SCRIPT_DIR / "Config.plist", EXT_DIR)
shutil.copy(SCRIPT_DIR / "icon.png", EXT_DIR)

# Zip the extension directory
with zipfile.ZipFile(EXTZ_FILE, "w", zipfile.ZIP_DEFLATED) as zf:
    for file in EXT_DIR.rglob("*"):
        zf.write(file, arcname=file.relative_to(SCRIPT_DIR))

# Clean up extension directory
shutil.rmtree(EXT_DIR)

# Move the zip file to dist
shutil.move(str(EXTZ_FILE), str(DIST_DIR / EXTZ_FILE.name))

print(f"Built: {DIST_DIR / EXTZ_FILE.name}")
