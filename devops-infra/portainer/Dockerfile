FROM portainer/portainer-ce:latest

# Set working directory
WORKDIR /app

# Create data directory with proper permissions
RUN mkdir -p /data && \
    chmod 755 /data

# Add healthcheck dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Expose ports
EXPOSE 9000 8000

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=10s --retries=3 \
  CMD curl -f http://localhost:9000/api/health || exit 1

# Use default entrypoint from base image
CMD ["/portainer"]
