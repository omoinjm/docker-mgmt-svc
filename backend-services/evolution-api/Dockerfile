FROM node:20-alpine

WORKDIR /app

# Install git for dependencies
RUN apk add --no-cache git curl

# Clone evolution API repository
RUN git clone https://github.com/EvolutionAPI/evolution-api.git . && \
    git checkout latest

# Install dependencies
RUN npm install --production && \
    npm cache clean --force

# Create necessary directories
RUN mkdir -p /evolution/instances

# Expose port
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:8080/api/health || exit 1

# Start application
CMD ["npm", "start"]
