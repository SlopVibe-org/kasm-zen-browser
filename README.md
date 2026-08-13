# kasm-zen-browser

Zen Browser running in a [Kasm Workspaces](https://kasmweb.com) container.

## Usage

```bash
docker run --rm -d \
  --shm-size=2g \
  -p 6901:6901 \
  -e VNC_PW=password \
  ghcr.io/slopvibe-org/kasm-zen-browser:latest
```

Access at `https://localhost:6901` — login: `kasm_user` / `password`

## Image

- **Base:** `kasmweb/debian-trixie-desktop:1.18.0`
- **Browser:** Zen Browser (latest stable)
- **Registry:** `ghcr.io/slopvibe-org/kasm-zen-browser`

## Build

```bash
docker build -t kasm-zen-browser .
```

Auto-built via GitHub Actions on every push and new Zen release.
