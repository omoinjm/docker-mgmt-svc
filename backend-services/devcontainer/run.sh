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
  echo "  onboard-openclaw   Run OpenClaw's non-interactive Ollama onboarding"
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
  onboard-openclaw)
    docker exec -it openclaw openclaw onboard \
      --non-interactive \
      --auth-choice ollama \
      --custom-base-url http://ollama:11434 \
      --accept-risk
    ;;
  *)
    usage
    exit 1
    ;;
esac
