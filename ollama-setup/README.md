# Docker + Ollama + Deepseek: AMD64 Setup Tutorial

## Base

Build instructions:

```bash
docker build --no-cache -t ollama-base:latest ./base/.
```

## DeepSeek

Build instructions:

```bash
docker build --no-cache -t ollama-deepseek:latest ./deepseek/.
```

Run instructions:

```bash
docker run -d --name deepseek-container -p 11434:11434 -v ollama-models:/root/.ollama ollama-deepseek:latest
```

## API payload

```bash

```

## Models to pick from

- [Meta's Llama](https://www.llama.com/)

- [Google's Gemma](https://ai.google.dev/gemma)

- [DeepSeek R1](https://www.deepseek.com/)

