# devcontainer — Local AI Dev Environment

A fully local AI-assisted development environment running on [Ollama](https://ollama.com). No cloud API keys required.

## Services

| Service | Description | Port |
|---|---|---|
| **ollama** | Local LLM inference server | `11434` |
| **openclaw** | AI gateway / chat UI backed by Ollama | `18789` |
| **claude-code** | [aider](https://aider.chat) AI pair programmer backed by Ollama | — |

All services share an internal `ai-net` bridge network. `openclaw` and `claude-code` talk to Ollama via `http://ollama:11434`.

## Prerequisites

- [Docker](https://docs.docker.com/get-docker/) ≥ 24
- [Docker Compose](https://docs.docker.com/compose/install/) v2 (`docker compose`)
- *(Optional)* NVIDIA GPU + [nvidia-container-toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html) for GPU acceleration

## Setup

### 1. Clone / navigate to this directory

```sh
cd backend-services/devcontainer
```

### 2. Configure environment (optional)

No secrets are required for the default Ollama-only setup. If you later add a cloud provider, copy the example file and fill in the relevant keys:

```sh
cp .env.example .env
```

### 3. Build and start

The `run.sh` helper script wraps all common operations:

```sh
# Build the base image, all service images, and start everything
./run.sh up
```

This runs:
1. `docker build -t base-devcontainer:latest ./base`
2. `docker compose build`
3. `docker compose up -d`

### 4. Pull models

After the stack is running, pull the LLMs you want to use:

```sh
# Pull the recommended set (qwen2.5-coder:7b, llama3.2, deepseek-r1:7b)
./run.sh pull-models

# Or pull a single model (default: codellama)
./run.sh pull-model

# Override the model name
MODEL=mistral ./run.sh pull-model
```

Verify models are available:

```sh
docker exec ollama ollama list
```

### 5. Onboard OpenClaw

Run once after first startup:

```sh
./run.sh onboard-openclaw
```

Then open **http://localhost:18789** in your browser.

### 6. Use aider (claude-code container)

```sh
./run.sh shell-claude-code
# Inside the container:
aider --model ollama/qwen2.5-coder:7b
```

## Shell access

Open an interactive shell in a running container:

```sh
# Via run.sh (zsh)
./run.sh shell-openclaw
./run.sh shell-claude-code

# Via docker exec
docker exec -it openclaw zsh
docker exec -it claude-code zsh
docker exec -it ollama bash    # ollama image has no zsh
```

## GPU Acceleration (optional)

Uncomment the `deploy` block in `docker-compose.yml` under the `ollama` service:

```yaml
deploy:
  resources:
    reservations:
      devices:
        - driver: nvidia
          count: all
          capabilities: [gpu]
```

## run.sh Reference

```
./run.sh <command>

  build              Build the base image then all service images
  up                 Build and start all services in the background
  down               Stop and remove all containers
  restart            Down then up
  logs               Follow logs for all services
  pull-model         Pull a single Ollama model (default: codellama)
  pull-models        Pull the recommended model set (coding + chat)
  shell-openclaw     Open a shell in the openclaw container
  shell-claude-code  Open a shell in the claude-code container
  onboard-openclaw   Run OpenClaw's non-interactive Ollama onboarding
```

## Volumes

| Volume | Purpose |
|---|---|
| `ollama_data` | Downloaded model weights (persisted across restarts) |
| `openclaw_state` | OpenClaw config and state |

## Project Structure

```
devcontainer/
├── base/               # Base Ubuntu 22.04 image (non-root user, zsh)
│   ├── Dockerfile
│   ├── devcontainer.json
│   └── scripts/
│       ├── setup-zsh.sh
│       └── setup-ohmyzsh.sh
├── claude-code/        # aider AI pair programmer image
│   └── Dockerfile
├── openclaw/           # OpenClaw AI gateway image
│   └── Dockerfile
├── docker-compose.yml
├── run.sh
└── .env.example
```

## VS Code Dev Containers

Open `base/` in VS Code with the [Dev Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) extension — `devcontainer.json` wires up the Dockerfile automatically.
