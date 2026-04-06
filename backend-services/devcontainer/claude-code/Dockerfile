FROM base-devcontainer:latest

USER root

RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python3-venv \
    && rm -rf /var/lib/apt/lists/*

# Install aider in a venv — supports Ollama via OpenAI-compatible API
RUN python3 -m venv /opt/aider
RUN /opt/aider/bin/pip install --upgrade pip aider-chat

USER vscode

ENV PATH="/opt/aider/bin:$PATH"
# Ollama's OpenAI-compatible endpoint — no real key needed
ENV OPENAI_API_BASE="http://ollama:11434/v1"
ENV OPENAI_API_KEY="ollama-local"

WORKDIR /workspace

# Usage: aider --model ollama/<model-name> e.g. aider --model ollama/codellama
CMD ["zsh", "--login"]

