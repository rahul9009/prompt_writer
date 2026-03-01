#!/usr/bin/env bash
# Start backend (FastAPI) and web (Angular) for local development.
# Run from project root: ./start-dev.sh
# Stop with Ctrl+C (kills both backend and web).

set -e
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

BACKEND_PID=""
cleanup() {
  if [[ -n "$BACKEND_PID" ]] && kill -0 "$BACKEND_PID" 2>/dev/null; then
    echo "Stopping backend (PID $BACKEND_PID)..."
    kill "$BACKEND_PID" 2>/dev/null || true
  fi
  exit 0
}
trap cleanup SIGINT SIGTERM

# 1. Backend: migrate + run
echo "=== Backend: alembic + uvicorn (port 8002) ==="
cd backend
if [[ -d .venv ]]; then
  source .venv/bin/activate
else
  echo "Warning: backend/.venv not found. Using current python."
fi
alembic upgrade head
uvicorn app.main:app --reload --host 0.0.0.0 --port 8002 &
BACKEND_PID=$!
cd "$SCRIPT_DIR"

# Give backend a moment to bind
sleep 2

# 2. Web: npm start
echo "=== Web: npm start (port 4200) ==="
cd web
npm start
