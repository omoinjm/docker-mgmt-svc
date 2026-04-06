# base

Base Docker image for all backend service containers. Provides Ubuntu 22.04, a non-root user, and a configured zsh shell. All other service images (`openclaw`, `claude-code`, etc.) build `FROM` this image.

> **Note:** Build this image first before bringing up any other services — see the [Makefile](../Makefile).

## Build args

| Arg        | Default  | Description                          |
|------------|----------|--------------------------------------|
| `USER_ID`  | `1000`   | UID of the container user            |
| `GROUP_ID` | `1000`   | GID of the container user            |
| `USERNAME` | `vscode` | Username inside the container        |

## Shell options

**Option 1 — Minimal zsh** (default, baked in at build time):
Custom prompt with git branch, exit-status indicator, history, and completions. No external dependencies.

**Option 2 — Oh My Zsh** (run manually after build):
Installs Oh My Zsh with the `devcontainers` theme. Requires internet access at runtime.

## Usage

### Build

```sh
# Default (minimal zsh)
docker build -t dev-container .

# Custom user IDs
docker build --build-arg USER_ID=$(id -u) --build-arg GROUP_ID=$(id -g) -t dev-container .
```

### Run

```sh
# Interactive shell (minimal zsh, already configured)
docker run -it --name devc -v $(pwd):/workspace dev-container

# Oh My Zsh setup (run once, then reuse the container)
docker run -it --name devc -v $(pwd):/workspace --entrypoint /workspace/scripts/setup-ohmyzsh.sh dev-container
```

### Stop / remove

```sh
docker stop devc && docker rm devc
```

## VS Code devcontainers

Open this folder in VS Code with the Dev Containers extension — `devcontainer.json` wires up the Dockerfile automatically.

