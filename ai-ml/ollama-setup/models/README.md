# Ollama Models - Model-Specific Setup

Custom Docker image for running specific AI models (DeepSeek, Llama, Gemma, etc.) with Ollama. This extends the base Ollama image with pre-configured model downloads and startup optimizations.

## 📋 Overview

- **Purpose:** Model-specific Ollama runtime
- **Base Image:** `ollama-base:latest` (from `base/`)
- **Default Models:** DeepSeek and others (customizable)
- **Type:** Production-ready model server

## 🏗️ Building the Image

### Standard Build
```bash
cd ai-ml/ollama-setup/models
docker build --no-cache -t ollama-models:latest .
```

### With Custom Model
Edit the `Dockerfile` to specify which model to pre-download:
```dockerfile
RUN ollama pull deepseek-coder
```

## 🚀 Quick Start

### Build and Run
```bash
# Build the image
docker build -t ollama-models:latest .

# Run the container
docker run -d \
  --name ollama-server \
  -p 11434:11434 \
  -v ollama-models:/root/.ollama \
  ollama-models:latest
```

### Verify Models are Loaded
```bash
curl http://localhost:11434/api/tags | jq
```

## 📊 Using the Models

### Chat with a Model (Using curl)
```bash
curl http://localhost:11434/api/generate \
  -d '{"model": "deepseek-coder", "prompt": "Write hello world in Python"}'
```

### Generate Completions
```bash
curl http://localhost:11434/api/generate \
  -d '{
    "model": "deepseek-coder",
    "prompt": "def fibonacci(",
    "stream": false
  }' | jq '.response'
```

### Stream Responses
```bash
curl http://localhost:11434/api/generate \
  -d '{
    "model": "deepseek-coder",
    "prompt": "Explain quantum computing",
    "stream": true
  }'
```

## 📦 Supported Models

Pre-configured for these models (customize in Dockerfile):

- **DeepSeek Coder:** `deepseek-coder` - Code completion and generation
- **DeepSeek R1:** `deepseek-r1` - Reasoning and analysis
- **Llama 2:** `llama2` - General purpose language model
- **Gemma:** `gemma` - Google's lightweight model
- **Mistral:** `mistral` - Efficient model

### Switching Models

Edit `Dockerfile`:
```dockerfile
# Change this line
RUN ollama pull deepseek-coder

# To this (example)
RUN ollama pull llama2
```

Then rebuild:
```bash
docker build --no-cache -t ollama-models:latest .
```

## 🚀 Startup Process

The container automatically:
1. Starts the Ollama daemon
2. Loads pre-configured models
3. Exposes API on port 11434
4. Maintains model persistence via volume

### Manual Model Download (if needed)
```bash
docker exec -it ollama-server ollama pull gemma
```

## 💾 Data Persistence

### Create Named Volume
```bash
docker volume create ollama-models
```

### Mount for Persistence
```bash
docker run -d \
  -v ollama-models:/root/.ollama \
  ollama-models:latest
```

### Check Volume Usage
```bash
docker volume inspect ollama-models

# See size
du -sh /var/lib/docker/volumes/ollama-models/_data/
```

## ⚙️ Configuration

### Environment Variables
Add to docker-compose or docker run:
```bash
-e OLLAMA_DEBUG=false
-e OLLAMA_NUM_GPU=1  # GPU acceleration (if available)
```

### GPU Support (Optional)
To use GPU (requires NVIDIA Container Toolkit):
```bash
docker run -d \
  --gpus all \
  -p 11434:11434 \
  -v ollama-models:/root/.ollama \
  ollama-models:latest
```

## 📈 Performance Tuning

### Increase Context Window
```bash
curl http://localhost:11434/api/generate \
  -d '{
    "model": "deepseek-coder",
    "prompt": "...",
    "options": {"num_ctx": 8192}
  }'
```

### Adjust Threads
```bash
docker run -d \
  -e OLLAMA_NUM_THREAD=8 \
  ollama-models:latest
```

## 🆘 Troubleshooting

**Model Fails to Download:**
```bash
# Check internet connectivity
ping github.com

# Check disk space
df -h

# View logs
docker logs -f ollama-server
```

**Container Exits on Startup:**
```bash
# Check initialization logs
docker logs ollama-server

# Rebuild without cache
docker build --no-cache -t ollama-models:latest .
```

**Slow Inference:**
```bash
# Check available resources
docker stats ollama-server

# Reduce context window
"options": {"num_ctx": 2048}
```

**API Not Responding:**
```bash
# Check if container is running
docker ps | grep ollama-server

# Test API
curl -v http://localhost:11434/api/tags
```

## 📚 API Reference

### List Models
```bash
GET http://localhost:11434/api/tags
```

### Generate Completion
```bash
POST http://localhost:11434/api/generate
{
  "model": "deepseek-coder",
  "prompt": "...",
  "stream": false,
  "options": {
    "temperature": 0.7,
    "top_p": 0.9,
    "num_ctx": 4096
  }
}
```

### Pull Model
```bash
POST http://localhost:11434/api/pull
{"model": "gemma"}
```

### Delete Model
```bash
DELETE http://localhost:11434/api/delete
{"model": "deepseek-coder"}
```

## 🧹 Cleanup

### Remove Container and Data
```bash
docker stop ollama-server
docker rm ollama-server
docker volume rm ollama-models
```

### Keep Data, Remove Container
```bash
docker stop ollama-server
docker rm ollama-server
# Volume persists for reuse
```

## 📚 Related

- [Main Ollama Documentation](../README.md)
- [Base Image](../base/README.md)
- [Ollama Official Repository](https://github.com/ollama/ollama)
- [Model Library](https://ollama.ai/library)

## 💡 Pro Tips

- Start with smaller models (mistral, gemma) for testing
- Use persistent volumes to avoid re-downloading models
- GPU support dramatically improves inference speed
- Adjust temperature (0-2) for different response styles
- Batch requests together for better throughput
