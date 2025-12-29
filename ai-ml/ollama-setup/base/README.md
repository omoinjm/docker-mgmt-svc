# Ollama Base Image

Base Docker image for AI/ML model serving with Ollama. This image provides the foundation for all Ollama-based setups in this repository.

## 📋 Overview

- **Purpose:** Base image for Ollama runtime
- **Content:** Ollama pre-installed with dependencies
- **Usage:** Extended by model-specific images (e.g., models/Dockerfile)
- **Type:** Foundation image

## 🏗️ Image Contents

- Ubuntu base OS
- Ollama runtime
- Required dependencies and libraries
- Default model serving configuration

## 🔨 Building the Base Image

```bash
# Build the base image
cd ai-ml/ollama-setup/base
docker build --no-cache -t ollama-base:latest .

# Or from parent directory
docker build --no-cache -t ollama-base:latest ./base/.
```

## 📦 Using the Base Image

### As a Standalone Container
```bash
docker run -d \
  --name ollama-server \
  -p 11434:11434 \
  -v ollama-models:/root/.ollama \
  ollama-base:latest
```

### Extending in Other Dockerfiles
```dockerfile
FROM ollama-base:latest

# Add your custom configuration
RUN ollama pull llama2
```

## 🚀 Quick Start

```bash
# Build base image
docker build -t ollama-base:latest ./base/.

# Run as standalone server
docker run -d \
  --name ollama \
  -p 11434:11434 \
  -v ollama-models:/root/.ollama \
  ollama-base:latest

# Test connection
curl http://localhost:11434/api/tags

# Stop and remove
docker stop ollama
docker rm ollama
```

## 📡 API Endpoints

Once running, access:
- **API Base:** `http://localhost:11434`
- **Models:** `GET /api/tags` - List available models
- **Generate:** `POST /api/generate` - Run inference

Example:
```bash
curl http://localhost:11434/api/tags | jq
```

## 💾 Volume Management

### Persistent Model Storage
```bash
# Create volume (if not exists)
docker volume create ollama-models

# Run with persistent storage
docker run -d \
  -v ollama-models:/root/.ollama \
  ollama-base:latest
```

### Models Directory
- **Location:** `/root/.ollama` (container)
- **Content:** Downloaded models, caches
- **Size:** Varies by model (1GB-70GB+)

## 🆘 Troubleshooting

**Container Won't Start:**
```bash
docker logs <container_id>
```

**Port Already in Use:**
```bash
# Check what's using port 11434
lsof -i :11434

# Use different port
docker run -p 8080:11434 ollama-base:latest
```

**Models Not Persisting:**
```bash
# Ensure volume is mounted
docker inspect <container_id> | grep -A 5 Mounts
```

## ✅ Verification

Check if base image is working:
```bash
# List available models
curl http://localhost:11434/api/tags

# Should return JSON with models array
```

## 📚 Next Steps

This base image is typically extended with:
- Model-specific configurations
- Custom startup scripts
- Additional libraries or tools
- Environment-specific settings

See `ai-ml/ollama-setup/models/` for an example of extending this base image.

## 🔗 Related

- [Main Ollama Documentation](../README.md)
- [Models Setup](../models/README.md)
- [Ollama Official Docs](https://github.com/ollama/ollama)
