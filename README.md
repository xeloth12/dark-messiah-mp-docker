# Dark Messiah of Might & Magic Multiplayer — Dedicated Server (Docker) - Base Image Project

A Dockerized dedicated server for **Dark Messiah of Might & Magic Multiplayer**, running via Wine on Ubuntu 24.04 with Large Address Aware (LAA) patch applied for improved memory handling.

[Docker Hub link](https://hub.docker.com/repository/docker/xloth/dark-messiah-mp-docker/general)

---

## Requirements

- Docker (23+ recommended, BuildKit enabled by default)
- A valid Steam account that owns Dark Messiah of Might & Magic

---

## Getting Started

### 1. Clone the repository

```bash
git clone https://github.com/xelot12/dark-messiah-mp-docker.git
cd dark-messiah-mp-docker
```

### 2. Build the Docker image

```bash
docker build -t dark-messiah .
```

### 3. Run the server

On the first run, the server will automatically download the game to a persistent volume. Subsequent runs will start immediately without re-downloading.

```bash
docker run -d \
  --privileged \
  --ulimit nofile=524288:524288 \
  -p 27015:27015/udp \
  -p 27015:27015/tcp \
  -e STEAM_USER=<your_login> \
  -e STEAM_PASSWORD=<your_password> \
  -e MAP=clsm_circus \
  -e MAXPLAYERS=16 \
  -v dark-messiah-data:/home/steam/darkmessiah \
  dark-messiah
```

> ⚠️ Steam credentials are passed as environment variables at runtime and are **never stored** in the image.

### 4. Connect via Steam

Open Steam → View → Game Servers → Favorites → Add a Server → `your_ip:27015`

---

## Configuration

Server parameters can be passed as environment variables at runtime:

| Variable | Default | Description |
|---|---|---|
| `STEAM_USER` | — | Steam login (required) |
| `STEAM_PASSWORD` | — | Steam password (required) |
| `MAP` | `clsm_circus` | Starting map |
| `MAXPLAYERS` | `16` | Max player count |
| `PORT` | `27015` | Server port |
| `TICKRATE` | `128` | Server tick rate |

---

## How It Works

### SteamCMD
The image includes SteamCMD which downloads Dark Messiah Multiplayer (App ID `2145`) at first runtime to a persistent Docker volume using the Windows platform flag (`+@sSteamCmdForcePlatformType windows`).

### VPK Extraction
`vpks_extraction.py` extracts all `*_dir.vpk` game archives into the server directory so the game files are available at runtime.

### LAA Patch
`laa_patch.py` sets the **Large Address Aware** flag (`0x20`) in the PE header of `srcds.exe`, allowing the 32-bit process to access up to 4 GB of RAM instead of 2 GB when run under Wine on a 64-bit host.

### Wine + Xvfb
The server runs as a Windows executable via **Wine** (`wine32`). A virtual framebuffer (**Xvfb**) is started first since Wine requires a display even for headless server processes.

---

## Ports

| Port | Protocol | Purpose |
|---|---|---|
| `27015` | UDP | Game traffic |
| `27015` | TCP | RCON / Steam |

---

## Security Notes

- Steam credentials are passed at runtime via environment variables and are never written to any image layer.
- The server runs as a non-root `steam` user inside the container.

---

## License

This project is provided as-is for personal and community use. Dark Messiah of Might & Magic is property of Ubisoft / Arkane Studios.
