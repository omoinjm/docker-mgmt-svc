#!/usr/bin/env bash
set -euo pipefail

MODEL="${MODEL:-codellama}"

usage() {
  echo "Usage: $0 <command>"
  echo ""
  echo "Commands:"
  echo "  build           Build the base image then all service images"
  echo "  up              Build and start all services in the background"
  echo "  down            Stop and remove all containers"
  echo "  restart         Down then up"
  echo "  logs            Follow logs for all services"
  echo "  pull-model      Pull a single Ollama model (default: $MODEL, override: MODEL=mistral $0 pull-model)"
  echo "  pull-models     Pull the recommended model set (coding + chat)"
  echo "  shell-openclaw  Open a shell in the openclaw container"
  echo "  shell-claude-code  Open a shell in the claude-code container"
  echo "  shell-openclaw-root  Open a root shell in the openclaw container (installing packages, etc.)"
  echo "  onboard-openclaw   Run OpenClaw's non-interactive Ollama onboarding"
  echo "  status-openclaw    Show OpenClaw gateway status"
  echo "  dashboard-openclaw Print an authenticated OpenClaw dashboard URL"
  echo "  pairing-approve    Approve a device pairing: $0 pairing-approve <platform> <code>"
}

build() {
  docker build -t base-devcontainer:latest ./base
  docker compose build
}

case "${1:-}" in
  build)           build ;;
  up)              build && docker compose up -d ;;
  down)            docker compose down ;;
  restart)         docker compose down && build && docker compose up -d ;;
  logs)            docker compose logs -f ;;
  pull-model)      docker exec ollama ollama pull "$MODEL" ;;
  pull-models)
    # Coding (aider)
    docker exec ollama ollama pull qwen2.5-coder:7b
    # General chat (OpenClaw)
    docker exec ollama ollama pull llama3.2
    # Reasoning / coding
    docker exec ollama ollama pull deepseek-r1:7b
    echo "All models pulled. Run: docker exec ollama ollama list"
    ;;
  shell-openclaw)  docker exec -it openclaw zsh ;;
  shell-claude-code) docker exec -it claude-code zsh ;;
  shell-openclaw-root) docker exec -u root -it openclaw zsh ;;
  onboard-openclaw)
    docker exec -it openclaw openclaw onboard \
      --non-interactive \
      --auth-choice ollama \
      --custom-base-url http://ollama:11434 \
      --gateway-bind lan \
      --accept-risk
    ;;
  status-openclaw)    docker exec openclaw openclaw status ;;
  dashboard-openclaw)
    TOKEN=$(docker exec openclaw node -e \
      "console.log(JSON.parse(require('fs').readFileSync(process.env.HOME+'/.openclaw/openclaw.json')).gateway.auth.token)")
    echo "http://localhost:18789/#token=$TOKEN"
    ;;
  pairing-approve)
    PLATFORM="${2:?Usage: $0 pairing-approve <platform> <code>}"
    CODE="${3:?Usage: $0 pairing-approve <platform> <code>}"
    docker exec openclaw openclaw pairing approve "$PLATFORM" "$CODE"
    ;;
  *)
    usage
    exit 1
    ;;
esac
