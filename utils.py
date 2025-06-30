import os
from subprocess import run
from pathlib import Path

def dcv_open(file: str | Path):
    run(["xdg-open", file], env=dict(os.environ.copy(), DISPLAY=":1", GNOME_DESKTOP_SESSION_ID="0"))
