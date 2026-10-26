# devcontainer — Local AI Dev Environment

A fully local AI-assisted development environment running on [Ollama](https://ollama.com). No cloud API keys required.

## Services

| Service | Description | Port |
|---|---|---|
| **ollama** | Local LLM inference server | internal only (not published to the host — see below) |
| **openclaw** | AI gateway / chat UI backed by Ollama | `18789` |
| **claude-code** | [aider](https://aider.chat) AI pair programmer backed by Ollama | — |

All services share an internal `ai-net` bridge network. `openclaw` and `claude-code` talk to Ollama via `http://ollama:11434`.

`ollama`'s port is intentionally **not** published to the host. If you also run a native `ollama serve` on your machine, it already owns host port `11434` — publishing the container's port too would fail to bind. Containers only need each other over `ai-net`; if you want host-side access to the containerized Ollama (e.g. `curl localhost:11434`), add back `ports: ["11434:11434"]` under the `ollama` service, but only if nothing else on the host is already listening on that port (`ss -ltnp | grep 11434` to check).

The `openclaw` container's main process is the gateway itself (`openclaw gateway run --bind lan`, `restart: unless-stopped`) — it's a long-running service, not just a shell. `--bind lan` (rather than the default `loopback`) is required for Docker's port-publish to reach it: a process bound only to loopback *inside* the container is unreachable from outside, even with `ports: ["18789:18789"]` set, because Docker's NAT delivers host traffic to the container's network interface, not its loopback.

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

The gateway starts automatically as part of the container (no separate "start" step needed). Get a ready-to-click, authenticated dashboard link:

```sh
./run.sh dashboard-openclaw
# -> http://localhost:18789/#token=<your-gateway-token>
```

Open that exact URL (with the `#token=...` fragment) in your browser — plain `http://localhost:18789` will load the page but won't be authenticated. No port forwarding is required beyond the `ports: ["18789:18789"]` already in `docker-compose.yml`: on Windows + WSL2, Windows automatically forwards `localhost:18789` to the WSL2 VM; on native Linux/macOS Docker Desktop, published ports are already host-reachable.

Check the gateway is healthy at any time:

```sh
./run.sh status-openclaw
```

> **Security note:** the gateway binds to `lan` (not `loopback`) so the published port is reachable at all — this is required for Docker port-publishing to work, but it does mean anyone who can reach `18789` on your machine can *attempt* a connection. Access is still gated by the token in the dashboard URL above. Don't expose `18789` beyond localhost (e.g. via router port-forwarding or `0.0.0.0` on a shared network) without reviewing `gateway.auth` and `gateway.controlUi.allowedOrigins` first — `openclaw security audit` inside the container will flag risky settings.

> **Re-running `onboard-openclaw` resets `gateway.bind` to `loopback` on disk.** The wizard rewrites `openclaw.json` from scratch, so `openclaw config get gateway.bind` / `openclaw status` will show `loopback` again afterward — that's just what's *persisted*, not what's *running*. `docker-compose.yml` always starts the gateway with an explicit `--bind lan` flag, which overrides the config file, so the dashboard keeps working without any extra step. You may also briefly see a `GatewayTransportError: gateway closed (1006 abnormal closure)` right after onboarding finishes — that's the wizard's own connectivity check catching the gateway mid-restart (it live-reloads to apply the new config) and is harmless; `./run.sh status-openclaw` will confirm it recovered.

> **If the dashboard shows "Browser origin not allowed" and prompts for a raw WebSocket URL/token/password instead of loading the chat UI:** the gateway logs a line on every boot claiming it "seeded `gateway.controlUi.allowedOrigins`" for `http://localhost:18789` — but that seeding is runtime-only and is *not* written to `openclaw.json`, and in practice the browser's WebSocket connections still get rejected (`code=4008`, "closed before connect" in the gateway log) until the origin is actually persisted. Fix once, from the host:
> ```sh
> docker exec openclaw sh -lc 'cat <<JSON | openclaw config patch --stdin
> {"gateway":{"controlUi":{"allowedOrigins":["http://localhost:18789","http://127.0.0.1:18789"]}}}
> JSON'
> docker restart openclaw
> ```
> This one requires a full gateway restart (not just a hot reload) to take effect — reload the browser tab afterward.

## Using the Dashboard UI

Once you have a URL from `./run.sh dashboard-openclaw`, opening it drops you into the **Control UI** — a single-page app with a sidebar (agent identity, session list) on the left and the active chat/page on the right.

- **Chat** — the default view. Type a message to talk to your configured agent/model; tool calls (shell commands, file edits) show up as inline cards. `Ctrl/Cmd+K` opens a command palette, `Ctrl/Cmd+B` toggles the sidebar, `` Ctrl+` `` opens an in-browser terminal into the gateway host.
- **+ (new session)** in the sidebar — start a fresh thread, optionally scoped to a working folder/git worktree, with its own model choice.
- **Channels** (sidebar or **Settings → Channels**) — shows connection health for WhatsApp/Telegram/etc.; this is where you'd re-link WhatsApp if it ever shows disconnected.
- **Settings → Model Providers** — see which providers are authenticated (Ollama, Google, etc.) and pick the default model.
- **Settings → Agents** — per-agent identity, tools, skills, and memory.
- **Automations** — cron-style recurring prompts, if you want the agent to run on a schedule.

First time opening it, if a device-pairing prompt appears ("pairing required"), approve it from inside the container: `docker exec -it openclaw openclaw devices approve <requestId>` (the request ID is shown in the prompt). Since your channels/models are already configured via `onboard-openclaw`, you can otherwise skip straight to Chat and send a message — no in-UI setup wizard is required.

### 6. Pair a messaging platform

OpenClaw supports two pairing styles depending on the platform:

**Bot-token platforms (Telegram, Slack, Discord):**

1. For Telegram: message [@BotFather](https://t.me/BotFather), send `/newbot`, and follow the prompts to get a bot token.
2. Add the token to OpenClaw's config (via the dashboard or `./run.sh shell-openclaw`).
3. When a device/chat requests pairing, approve it with the code it displays:

```sh
./run.sh pairing-approve telegram <CODE>
```

Swap `telegram` for `slack`/`discord` as needed.

**QR-linked platforms (WhatsApp, iMessage):**

WhatsApp uses WhatsApp Web–style linking, not a bot token or `pairing-approve` — it's an outbound-only connection (your container talks out to WhatsApp's servers), so **no inbound port forwarding is needed** either. Scan the QR code from your phone's WhatsApp → Linked Devices:

```sh
docker exec -it openclaw openclaw channels login --channel whatsapp
```

Once linked, the session persists in the `openclaw_state` volume — restarting the container won't require re-scanning. Confirm it's connected:

```sh
docker exec openclaw openclaw channels status --deep
```

### 7. Use aider (claude-code container)

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

Need root inside the openclaw container (e.g. to install a package)?

```sh
./run.sh shell-openclaw-root
# or: docker exec -u root -it openclaw zsh
```

## Performance on Constrained Hardware

Running LLMs purely on CPU with limited RAM (e.g. a WSL2 VM sharing memory with your other dev tools) is the realistic default for this setup. If replies are slow or models are getting OOM-killed (check `dmesg | grep -i oom` — the kernel logs it as `Out of memory: Killed process ... (llama-server)`), work through these roughly in order of effort:

**1. Use the smallest model that's good enough.** A 9.6GB model on a host with only ~2-3GB free RAM will get OOM-killed outright; a 2GB model might still get killed under load; something in the ~400MB-1GB range (`qwen2.5:0.5b`, `qwen2.5:1.5b`) is much more likely to survive and stay fast. Trade capability for reliability — a tiny model that actually responds beats a bigger one that crashes.

**2. Trim the system prompt.** OpenClaw sends its full tool/skill schema on every message — this can easily be 25k+ characters before the model sees your actual question, and that's pure prefill cost on CPU. Deny tools you don't use via `tools.deny` (the biggest offenders are usually `cron`, `image_generate`, `video_generate`, `music_generate`, `skill_workshop`, `sessions_spawn` — `cron` alone can be ~9.6k characters):

```sh
cat <<'JSON' | docker exec -i openclaw sh -lc 'openclaw config patch --stdin'
{"tools": {"deny": ["cron", "image_generate", "video_generate", "music_generate", "skill_workshop", "sessions_spawn"]}}
JSON
```

Check the effect with `openclaw agent --agent main --message "hi" --json` and look at `result.meta.systemPromptReport.tools.schemaChars` before/after. You can also disable unused entries under `skills.entries` in `openclaw.json` for a smaller additional win.

**3. Keep the model loaded between messages.** Already configured in `docker-compose.yml` — the `ollama` service sets `OLLAMA_KEEP_ALIVE=30m` (avoid a cold reload if messages are more than Ollama's 5-minute default apart), `OLLAMA_NUM_PARALLEL=1` and `OLLAMA_MAX_LOADED_MODELS=1` (prevent two concurrent requests from each loading their own copy of a model, which is a fast way to trigger OOM on a memory-constrained host).

**4. Free RAM by closing other things.** Quick and free, but manual and temporary: extra editor windows, language servers, other dev servers, and other AI CLI sessions all compete for the same RAM pool as Ollama. Check what's actually using it with `ps aux --sort=-%mem | head`.

**5. Give the WSL2 VM more memory (Windows only, most durable fix).** If your Windows host has RAM to spare, WSL2's default allocation may be leaving Ollama with very little headroom:
   1. On Windows, create/edit `%UserProfile%\.wslconfig`:
      ```ini
      [wsl2]
      memory=12GB
      swap=8GB
      ```
      (adjust `memory` to whatever you can spare — check Windows Task Manager for how much is actually free)
   2. From PowerShell/cmd (not from inside WSL): `wsl --shutdown`
   3. Reopen your WSL2 terminal — `free -h` should now show the new total, and `./run.sh up` to bring the stack back up.

**6. GPU acceleration.** Only applies if you have an NVIDIA GPU with drivers configured for WSL2/Docker (check with `nvidia-smi` — if that fails with "Failed to initialize NVML", there's no GPU visible here and this won't help). If you do have one, install [nvidia-container-toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html) then uncomment the `deploy` block in `docker-compose.yml` under the `ollama` service:
   ```yaml
   deploy:
     resources:
       reservations:
         devices:
           - driver: nvidia
             count: all
             capabilities: [gpu]
   ```
   GPU inference is typically an order of magnitude faster than CPU, so this is the biggest single lever if it's available to you.

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
  shell-openclaw-root  Open a root shell in the openclaw container
  onboard-openclaw   Run OpenClaw's non-interactive Ollama onboarding
  status-openclaw    Show OpenClaw gateway status
  dashboard-openclaw Print a ready-to-click, authenticated OpenClaw dashboard URL
  pairing-approve    Approve a bot-token pairing (Telegram/Slack/Discord): ./run.sh pairing-approve <platform> <code>
```

WhatsApp/iMessage use QR-code linking instead — see [Pair a messaging platform](#6-pair-a-messaging-platform).

## Volumes

| Volume | Purpose |
|---|---|
| `ollama_data` | Downloaded model weights (persisted across restarts) |
| `openclaw_state` | OpenClaw config and state (`~/.openclaw` inside the container) |
| `./openclaw/workspace` | Bind mount giving the OpenClaw agent read/write access to files on the host |

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
│   ├── Dockerfile
│   └── workspace/      # Bind-mounted into the container; agent-accessible files
├── docker-compose.yml
├── run.sh
└── .env.example
```

## VS Code Dev Containers

Open `base/` in VS Code with the [Dev Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) extension — `devcontainer.json` wires up the Dockerfile automatically.
