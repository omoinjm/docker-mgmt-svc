FROM grafana/grafana:latest

# Install additional plugins
RUN grafana-cli plugins install grafana-clock-panel

# Create data directory
RUN mkdir -p /var/lib/grafana

# Expose port
EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:3000/api/health || exit 1
