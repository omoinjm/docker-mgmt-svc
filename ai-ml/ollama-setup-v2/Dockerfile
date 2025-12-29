FROM ollama/ollama:latest

# Set working directory
WORKDIR /app

# Install dependencies for healthcheck
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Create directories
RUN mkdir -p /root/.ollama /scripts && \
    chmod 755 /root/.ollama /scripts

# Expose API port
EXPOSE 11434

# Health check - Ollama API endpoint
HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=3 \
  CMD curl -f http://localhost:11434/api/tags || exit 1

# Default command - start Ollama server
CMD ["ollama", "serve"]
