FROM base-devcontainer:latest

USER root

# Node 24 is recommended by OpenClaw
RUN apt-get update && apt-get install -y ca-certificates gnupg \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://deb.nodesource.com/setup_24.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

RUN npm install -g openclaw

USER vscode

# Ollama integration — no real API key needed
ENV OLLAMA_API_KEY="ollama-local"
ENV OLLAMA_BASE_URL="http://ollama:11434"
# OpenClaw gateway dashboard port
EXPOSE 18789

WORKDIR /home/vscode

# On first run: openclaw onboard --non-interactive --auth-choice ollama --custom-base-url http://ollama:11434 --accept-risk
# Then start the gateway with: openclaw gateway start
CMD ["zsh", "--login"]

