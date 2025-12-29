FROM jc21/nginx-proxy-manager:latest

# Set working directory
WORKDIR /app

# Create necessary directories with proper permissions
RUN mkdir -p /data /etc/letsencrypt && \
    chmod 755 /data /etc/letsencrypt

# Add healthcheck script
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Expose ports
EXPOSE 80 443 81

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=10s --retries=3 \
  CMD curl -f http://localhost:81/api/health || exit 1

# Use default entrypoint from base image
CMD ["dumb-init", "/init"]
