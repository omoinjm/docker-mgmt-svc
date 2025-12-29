# Ollama v2 - Local LLM Runtime

**Ollama** is a lightweight, production-grade local LLM runtime that allows you to run open-source large language models entirely on your machine without cloud dependencies.

## Features

- 🚀 **Local LLM Inference** - Run LLMs locally without cloud APIs
- 📦 **Easy Model Management** - Pull and manage models with simple commands
- ⚡ **Fast Performance** - Optimized inference engine with GPU support
- 🔒 **Privacy** - All data stays on your machine
- 🌐 **REST API** - Standard HTTP API for integration
- 💾 **Model Library** - Access to hundreds of open-source models
- 🛠️ **Flexible Configuration** - Supports various model sizes and types
- 📊 **Multi-Model Support** - Run multiple models simultaneously

## Quick Start

```bash
# Start Ollama v2
docker-compose up -d

# Wait for service to be ready (check logs)
docker-compose logs -f ollama

# Verify Ollama is running
curl http://localhost:11434/api/tags

# Generate text with a model
curl -X POST http://localhost:11434/api/generate \
  -d '{"model":"llama2","prompt":"Tell me about Docker"}'
```

## Port Mappings

| Port | Purpose | Usage |
|------|---------|-------|
| 11434 | Ollama API | REST API for model inference and management |

## Model Management

### Automatic Model Setup

Models are automatically pulled on first startup using the `scripts/setup_models.sh` script:

```bash
# Models pulled automatically:
# - deepseek-r1:8b (reasoning model)
# - deepseek-r1:70b (reasoning model - large)
# - llama3.1:8b (general purpose)
# - llama3.1:70b (general purpose - large)
# - llama2:7b (text generation)
# - llama2:70b (text generation - large)
```

### Manual Model Management

```bash
# List available models
curl http://localhost:11434/api/tags

# Pull a specific model
docker-compose exec ollama ollama pull mistral:7b

# Remove a model
docker-compose exec ollama ollama rm llama2:7b

# Show model details
docker-compose exec ollama ollama show llama2
```

### Popular Models

| Model | Size | Use Case | Speed | Quality |
|-------|------|----------|-------|---------|
| llama2:7b | 4 GB | General | Fast | Good |
| llama2:70b | 40 GB | General | Slow | Excellent |
| mistral:7b | 4 GB | Efficient | Very Fast | Good |
| neural-chat:7b | 4 GB | Chat | Fast | Good |
| deepseek-r1:8b | 4 GB | Reasoning | Fast | Excellent |
| deepseek-r1:70b | 40 GB | Reasoning | Slow | Excellent |

## Architecture

### Volume Structure

```
ollama_data/
├── models/                 # Downloaded models
│   ├── llama2:7b/
│   ├── deepseek-r1:8b/
│   └── ...
├── config/                 # Ollama configuration
└── cache/                  # Inference cache
```

Data persists across container restarts via the `ollama_data` named volume.

### Network Configuration

Ollama runs on an isolated network (`ollama-net`). The API is accessible on:
- **Local**: http://localhost:11434
- **Internal (same Docker network)**: http://ollama:11434

## Configuration

### Environment Variables

Configure via `.env` file:

```bash
TZ=UTC  # Container timezone
```

### API Server Configuration

Ollama server is configured to listen on `0.0.0.0:11434` in docker-compose.yml:

```yaml
environment:
  - OLLAMA_HOST=0.0.0.0:11434
```

### GPU Acceleration (Optional)

To enable GPU support:

1. Ensure NVIDIA Docker runtime is installed
2. Uncomment in docker-compose.yml:
   ```yaml
   deploy:
     resources:
       reservations:
         devices:
           - driver: nvidia
             count: 1
             capabilities: [gpu]
   ```
3. Restart service: `docker-compose up -d --force-recreate`

## Typical Workflows

### 1. Start Ollama Server

```bash
# Start the service
docker-compose up -d

# Check logs (wait for startup)
docker-compose logs -f ollama

# Verify API is responding
curl http://localhost:11434/api/tags
```

### 2. Pull and Use a Model

```bash
# Pull a specific model
docker-compose exec ollama ollama pull llama2:7b

# Test the model
curl -X POST http://localhost:11434/api/generate \
  -d '{
    "model": "llama2:7b",
    "prompt": "What is machine learning?",
    "stream": false
  }' | jq

# With streaming (real-time output)
curl -X POST http://localhost:11434/api/generate \
  -d '{
    "model": "llama2:7b",
    "prompt": "Explain Docker in 3 sentences",
    "stream": true
  }'
```

### 3. Use Ollama in Your Application

**Python Example:**

```python
import requests
import json

response = requests.post('http://localhost:11434/api/generate', json={
    'model': 'llama2:7b',
    'prompt': 'Tell me about Ollama',
    'stream': False
})

print(response.json()['response'])
```

**JavaScript/Node.js Example:**

```javascript
const response = await fetch('http://localhost:11434/api/generate', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({
    model: 'llama2:7b',
    prompt: 'Explain REST APIs',
    stream: false
  })
});

const result = await response.json();
console.log(result.response);
```

### 4. Monitor Model Performance

```bash
# Check which models are loaded
docker-compose exec ollama ollama list

# View resource usage
docker stats ollama

# Check API response time
time curl -X POST http://localhost:11434/api/generate \
  -d '{"model":"llama2:7b","prompt":"Hi"}'
```

## API Reference

### Generate Endpoint

```bash
curl -X POST http://localhost:11434/api/generate \
  -d '{
    "model": "llama2:7b",
    "prompt": "Your prompt here",
    "stream": false,
    "options": {
      "temperature": 0.7,
      "num_predict": 128,
      "top_k": 40,
      "top_p": 0.9
    }
  }'
```

### List Models Endpoint

```bash
curl http://localhost:11434/api/tags
```

Response:
```json
{
  "models": [
    {
      "name": "llama2:7b",
      "modified_at": "2024-01-01T12:00:00Z",
      "size": 3826087936,
      "digest": "sha256:..."
    }
  ]
}
```

### Pull Model Endpoint

```bash
curl -X POST http://localhost:11434/api/pull \
  -d '{"name": "mistral:7b"}'
```

## Troubleshooting

### Container Won't Start

```bash
# Check logs for errors
docker-compose logs ollama

# Verify image is pulling correctly
docker-compose up -d --verbose

# Restart with clean build
docker-compose down
docker-compose up -d --build
```

### API Not Responding

```bash
# Check if service is running
docker-compose ps

# Test connectivity
curl http://localhost:11434

# Check container logs
docker-compose logs ollama

# Restart service
docker-compose restart ollama
```

### Model Download Issues

```bash
# Check available disk space
df -h

# View model download progress
docker-compose logs -f ollama | grep "pulling"

# Cancel stuck download
docker-compose restart ollama

# Resume pulling (automatic)
docker-compose exec ollama ollama pull model-name
```

### Slow Model Performance

```bash
# Check system resources
docker stats ollama

# Use smaller model size
docker-compose exec ollama ollama pull llama2:7b

# Check GPU usage (if configured)
nvidia-smi

# Reduce temperature/top_k for faster responses
# See API Reference above
```

### High Memory Usage

1. Check which models are loaded: `docker-compose exec ollama ollama list`
2. Unload unused models: `docker-compose exec ollama ollama rm model-name`
3. Use smaller model variants (7b instead of 70b)
4. Reduce `num_predict` parameter in API calls

## Advanced Configuration

### Custom Model Loading Script

Edit `scripts/setup_models.sh` to customize which models load on startup:

```bash
#!/bin/bash

echo "Waiting for Ollama to be ready..."
until curl -s http://localhost:11434 >/dev/null; do
  sleep 2
done

echo "Pulling custom models..."
ollama pull mistral:7b
ollama pull neural-chat:7b

echo "✅ Models ready!"
```

### Enable Persistent Model Cache

Models are automatically cached in `ollama_data` volume. To verify:

```bash
docker-compose exec ollama ls -la /root/.ollama/models
```

### Security Considerations

⚠️ **Important:**

1. **Network Exposure** - Ollama API has no built-in authentication
   - Only expose port 11434 on trusted networks
   - Use firewall rules to restrict access
   - Consider Nginx Proxy Manager for authentication

2. **Resource Limits** - LLMs consume significant resources
   - Monitor disk space (models range 4-40+ GB)
   - Monitor RAM usage (larger models need more)
   - Set memory limits in docker-compose if needed

3. **Model Privacy** - All data stays local
   - No telemetry or external calls (unless configured)
   - Models not shared with cloud services
   - Data isolation via Docker

## Integration with Other Services

### Use Ollama from Other Services

If services are on the same Docker network, access Ollama at:

```
http://ollama:11434
```

**Example: Evolution API Integration**

```python
# In your Evolution API service
import requests

def generate_response(prompt):
    response = requests.post(
        'http://ollama:11434/api/generate',
        json={'model': 'llama2:7b', 'prompt': prompt}
    )
    return response.json()['response']
```

### Cross-Service Communication

Add to other services' docker-compose.yml:

```yaml
networks:
  - ollama-net  # Add this to services section

networks:
  ollama-net:
    external: true  # Use existing Ollama network
```

## Performance Optimization

### Inference Speed Tips

1. **Use Smaller Models** - 7b models are 5-10x faster than 70b
2. **Reduce `num_predict`** - Limit output tokens
3. **Enable GPU** - 10-50x speedup if available
4. **Batch Requests** - Process multiple inputs efficiently
5. **Cache Models** - Pre-load frequently used models

### Memory Management

```bash
# Check current usage
docker stats ollama

# If memory constrained:
# 1. Unload unused models: ollama rm model-name
# 2. Use smaller models: llama2:7b instead of 70b
# 3. Limit concurrent requests
```

## Monitoring & Debugging

### Health Check

```bash
# API health
curl http://localhost:11434

# Model availability
curl http://localhost:11434/api/tags

# Model details
curl http://localhost:11434/api/show -d '{"name":"llama2"}'
```

### Logs and Debugging

```bash
# View real-time logs
docker-compose logs -f ollama

# View last 100 lines
docker-compose logs --tail=100 ollama

# Save logs to file
docker-compose logs ollama > ollama.log

# Check inference logs with timestamps
docker-compose logs --timestamps ollama
```

### Performance Profiling

```bash
# Measure response time
time curl -X POST http://localhost:11434/api/generate \
  -d '{"model":"llama2:7b","prompt":"test"}'

# Monitor during request
docker stats ollama  # In another terminal

# Check network I/O
docker exec ollama iftop  # If available
```

## Data Backup & Recovery

### Backup Models

```bash
# Backup models volume
docker run --rm -v ollama_data:/data -v $(pwd):/backup \
  alpine tar czf /backup/ollama-models-$(date +%Y%m%d).tar.gz /data/models

# Verify backup
ls -lh ollama-models-*.tar.gz
```

### Restore Models

```bash
# Restore from backup
docker run --rm -v ollama_data:/data -v $(pwd):/backup \
  alpine tar xzf /backup/ollama-models-YYYYMMDD.tar.gz -C /

# Restart Ollama
docker-compose restart ollama

# Verify
curl http://localhost:11434/api/tags
```

## References

- **Official Documentation**: https://ollama.ai
- **GitHub Repository**: https://github.com/ollama/ollama
- **Model Library**: https://ollama.ai/library
- **API Documentation**: https://github.com/ollama/ollama/blob/main/docs/api.md
- **Community Discussions**: https://github.com/ollama/ollama/discussions

---

**Last Updated**: 2025-12-29  
**Service Category**: AI & Machine Learning  
**Status**: Production Ready  
**Version**: Ollama v2 (Latest)
