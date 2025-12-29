FROM python:3.11-slim

WORKDIR /app

# Install git and system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

# Clone phoneinfoga repository
RUN git clone https://github.com/sundowndev/phoneinfoga.git . && \
    git checkout main

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Expose API port
EXPOSE 5000

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:5000/health || exit 1

# Set environment variables
ENV PYTHONUNBUFFERED=1

# Start the API server
CMD ["python", "phoneinfoga/main.py", "serve", "-p", "5000"]
