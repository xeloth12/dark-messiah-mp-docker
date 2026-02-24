#!/bin/bash
set -e

if [ ! -f "/home/steam/darkmessiah/srcds.exe" ]; then
    if [ -z "$STEAM_USER" ] || [ -z "$STEAM_PASSWORD" ]; then
        echo "ERROR: STEAM_USER and STEAM_PASSWORD must be set"
        exit 1
    fi
    /home/steam/steamcmd/steamcmd.sh \
        +@sSteamCmdForcePlatformType windows \
        +force_install_dir /home/steam/darkmessiah \
        +login "$STEAM_USER" "$STEAM_PASSWORD" \
        +app_update 2145 validate \
        +quit

    cd /home/steam/darkmessiah
    python3 /home/steam/darkmessiah/custom_scripts/vpks_extraction.py
    cp srcds.exe srcds_LAA_patched.exe
    python3 /home/steam/darkmessiah/custom_scripts/laa_patch.py
    ln -s bin/steam.dll bin/Steam.dll
    rm -rf vpks
fi

Xvfb :1 -screen 0 1024x768x16 &
XVFB_PID=$!
trap "kill $XVFB_PID" EXIT

until xdpyinfo -display :1 >/dev/null 2>&1; do sleep 0.5; done

cd /home/steam/darkmessiah

exec wine srcds_LAA_patched.exe \
    /abovenormal \
    -port ${PORT:-27015} \
    -console \
    +map ${MAP:-clsm_circus} \
    +maxplayers ${MAXPLAYERS:-16} \
    -tickrate ${TICKRATE:-128} \
    -heapsize 1048576