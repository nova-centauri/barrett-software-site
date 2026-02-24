# Barrett Software Site (v0.1)

Simple static site for **barrett.software** with automated deployment to VM2.

## Stack
- Static HTML/CSS
- Docker (nginx:alpine)
- VM2 auto-deploy via systemd timer (pulls `main` every minute)

## Local dev
Open `index.html` directly in browser.

## VM2 deployment design
- Repo clone path: `/home/nova/apps/barrett-software-site`
- Container name: `barrett-software-site`
- App host port: `8092`
- Reverse proxy should route `barrett.software` and `www.barrett.software` → `10.0.0.97:8092`

## Auto-deploy
`deploy/vm2/deploy.sh`:
1. fetches `origin/main`
2. resets local checkout if changed
3. rebuilds Docker image
4. restarts container

`barrett-site-deploy.timer` runs the deploy service every minute.
