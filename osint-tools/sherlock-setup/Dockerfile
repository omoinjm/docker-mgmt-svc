FROM python:3.11-slim

WORKDIR /opt/sherlock

# Install git and system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

# Clone sherlock repository
RUN git clone https://github.com/sherlock-project/sherlock.git . && \
    git checkout main

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Create results directory
RUN mkdir -p /opt/sherlock/results

# Expose port for the web interface (if available)
EXPOSE 5000

# Set environment variables
ENV PYTHONUNBUFFERED=1

# Default command
CMD ["python", "sherlock.py", "--help"]
