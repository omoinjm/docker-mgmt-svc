FROM ubuntu:22.04

ARG USER_ID=1000
ARG GROUP_ID=1000
ARG USERNAME=vscode

RUN apt-get update && apt-get install -y zsh git curl sudo \
    && rm -rf /var/lib/apt/lists/*

RUN groupadd --gid $GROUP_ID $USERNAME && \
    useradd --uid $USER_ID --gid $GROUP_ID -m -s /bin/zsh $USERNAME && \
    echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$USERNAME && \
    chmod 0440 /etc/sudoers.d/$USERNAME

USER $USERNAME
WORKDIR /home/$USERNAME

# Option 1: Minimal setup (no oh-my-zsh)
COPY --chown=$USERNAME:$USERNAME scripts/setup-zsh.sh /tmp/
RUN chmod +x /tmp/setup-zsh.sh && /tmp/setup-zsh.sh

# Option 2: Oh My Zsh with devcontainers theme
COPY --chown=$USERNAME:$USERNAME scripts/setup-ohmyzsh.sh /tmp/
RUN chmod +x /tmp/setup-ohmyzsh.sh

CMD ["zsh", "--login"]
