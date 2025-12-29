#!/bin/bash

# We wouldn't run this in production

set -x

OLLAMA_HOST=0.0.0.0:11434 exec ollama serve
