#!/bin/bash
set -e

# Install Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  export RUNZSH=no
  export CHSH=no
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Download devcontainers theme (optional)
mkdir -p "$HOME/.oh-my-zsh/custom/themes"
curl -fsSL https://raw.githubusercontent.com/devcontainers/features/main/src/common-utils/scripts/devcontainers.zsh-theme \
  -o "$HOME/.oh-my-zsh/custom/themes/devcontainers.zsh-theme" 2>/dev/null || true

# Create zshrc
cat >"$HOME/.zshrc" <<'EOF'
export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="devcontainers"
plugins=(git)
source $ZSH/oh-my-zsh.sh
DISABLE_AUTO_UPDATE=true
DISABLE_UPDATE_PROMPT=true
EOF

# CRITICAL: Keep shell open (container stays alive while this runs)
exec zsh -l
