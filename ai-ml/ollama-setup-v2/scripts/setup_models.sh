#!/bin/bash

# Ollama Model Setup Script
# This script automatically pulls models on container startup

set -e

echo "=========================================="
echo "Ollama Model Setup Script"
echo "=========================================="
echo ""

# Wait for Ollama server to be ready
echo "⏳ Waiting for Ollama server to be ready..."
max_attempts=30
attempt=0

while [ $attempt -lt $max_attempts ]; do
  if curl -s http://localhost:11434 >/dev/null 2>&1; then
    echo "✅ Ollama server is ready!"
    break
  fi
  attempt=$((attempt + 1))
  echo "  Attempt $attempt/$max_attempts... (waiting 2s)"
  sleep 2
done

if [ $attempt -eq $max_attempts ]; then
  echo "❌ Timeout: Ollama server did not start in time"
  exit 1
fi

echo ""
echo "📦 Pulling models..."
echo ""

## Chat & Reasoning Models
#echo "→ Pulling reasoning model: deepseek-r1:8b"
## ollama pull deepseek-r1:8b
#
#echo "→ Pulling reasoning model: deepseek-r1:70b (large)"
#ollama pull deepseek-r1:70b

# General Purpose Models
echo "→ Pulling general model: llama3.2"
ollama pull llama3.2

# Embedding Model
echo "→ Pulling embedding model: nomic-embed-text"
ollama pull nomic-embed-text

#echo "→ Pulling general model: llama3.1:70b (large)"
#ollama pull llama3.1:70b
#
## Text Generation Models
#echo "→ Pulling text model: llama2:7b"
#ollama pull llama2:7b
#
#echo "→ Pulling text model: llama2:70b (large)"
#ollama pull llama2:70b

echo ""
echo "=========================================="
echo "✅ All models pulled successfully!"
echo "=========================================="
echo ""
echo "Available models:"
ollama list
echo ""
echo "Ollama server is running on 0.0.0.0:11434"
echo "API endpoint: http://localhost:11434"
echo ""

# Keep container alive
exec "$@"
