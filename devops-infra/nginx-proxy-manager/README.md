# Nginx Proxy Manager (NPM)

**Nginx Proxy Manager** is a modern, easy-to-use reverse proxy and load balancer for Docker/Linux, built on top of Nginx.

## Features

- 🚀 **Reverse Proxy Management** - Create and manage reverse proxies through an intuitive web UI
- 🔒 **SSL/TLS Support** - Automatic SSL certificate management with Let's Encrypt
- ⚡ **Load Balancing** - Distribute traffic across multiple backend services
- 🔄 **Stream Support** - Forward TCP/UDP traffic for non-HTTP services
- 📊 **Access Control** - Basic auth, IP whitelist/blacklist, and more
- 🎯 **Multiple Domains** - Host multiple domains and subdomains on one server

## Quick Start

```bash
# Start the service
docker-compose up -d

# Access the admin UI
# URL: http://localhost:81
# Default credentials:
#   Email: admin@example.com
#   Password: changeme
```

## Configuration

### Port Mappings

| Port | Purpose | Usage |
|------|---------|-------|
| 80   | HTTP    | Public HTTP traffic (automatically redirects to HTTPS if configured) |
| 443  | HTTPS   | Public HTTPS traffic (encrypted) |
| 81   | Admin UI | Web interface for configuration |

### Data Persistence

NPM stores all configuration and SSL certificates in named volumes:

```yaml
npm_data:           # Proxy host configurations, access rules
npm_letsencrypt:    # SSL certificates and renewal data
```

### Environment Variables

Configure via `.env` file:

```bash
PUID=1000           # User ID for container process
PGID=1000           # Group ID for container process
TZ=UTC              # Container timezone
```

## Typical Workflow

### 1. Start NPM
```bash
docker-compose up -d
```

### 2. Access Admin UI
```
http://localhost:81
(default: admin@example.com / changeme)
```

### 3. Add a Proxy Host
- Click "Proxy Hosts" → "Add Proxy Host"
- Domain: `myapp.local`
- Upstream IP: `evolution-api` (if on same network)
- Upstream Port: `8080`
- Save & change password immediately

### 4. Configure SSL (Optional)
- After saving, click the SSL tab
- Select "Request new SSL Certificate"
- Choose Let's Encrypt (requires public domain)
- Accept agreement and save

## Networking

NPM runs on its own network (`npm-net`) to isolate from other services.

### Accessing Backend Services

To proxy requests to other Docker services, ensure they're on the same network or use explicit network connections.

**Example:** Proxy to Evolution API
```
Upstream: http://evolution-api:8080
```

This requires either:
1. Shared network between NPM and the backend service, OR
2. Explicit network connection configured in both docker-compose files

## Common Tasks

### Change Admin Password

1. Access UI at `http://localhost:81`
2. Click admin avatar (top-right)
3. Select "Change Password"
4. Save changes

### Add Backend Service to Network

To make a service accessible to NPM, add it to the `npm-net` network in its docker-compose file:

```yaml
services:
  my-app:
    networks:
      - my-app-net
      - npm-net  # Add this line

networks:
  my-app-net:
  npm-net:
    external: true  # Already created by NPM
```

### Backup Configuration

To backup all proxy host configurations:

```bash
# Backup data volume
docker-compose exec nginx-proxy-manager tar czf /data/backup-$(date +%Y%m%d).tar.gz /data

# Copy backup to host
docker cp nginx-proxy-manager:/data/backup-*.tar.gz ./backups/
```

## Troubleshooting

### UI Not Accessible

```bash
# Check if service is running
docker-compose ps

# View logs
docker-compose logs nginx-proxy-manager

# Restart service
docker-compose restart nginx-proxy-manager
```

### Proxy Host Not Working

1. Verify backend service is running: `docker ps`
2. Check upstream IP/Port in admin UI
3. Verify network connectivity between NPM and backend
4. Check logs for errors: `docker-compose logs nginx-proxy-manager`

### SSL Certificate Issues

1. Ensure public domain is properly configured
2. Check DNS records point to your server
3. Review Let's Encrypt rate limits (max 50 certificates/domain per week)
4. Check SSL tab in admin UI for error messages

## Architecture

```
External Traffic (Port 80/443)
    ↓
[Nginx Proxy Manager]
    ↓
(Routes based on domain/path)
    ├─→ Backend Service 1 (Evolution API on 8080)
    ├─→ Backend Service 2 (Grafana on 3000)
    ├─→ OSINT Tool (Phoneinfoga on 5000)
    └─→ Other Services...
```

## Security Notes

⚠️ **Important:**

1. **Change default password immediately** after first login
2. **Use strong admin password** - this controls all proxy configurations
3. **Enable 2FA** if NPM version supports it
4. **Restrict admin UI access** - only expose port 81 on internal networks
5. **Use HTTPS** for all public-facing proxies (Let's Encrypt recommended)
6. **Regularly backup** your NPM configuration

## References

- **Official Documentation**: https://nginxproxymanager.com/
- **GitHub Repository**: https://github.com/NginxProxyManager/nginx-proxy-manager
- **Docker Image**: https://hub.docker.com/r/jc21/nginx-proxy-manager

## Logs and Debugging

```bash
# View real-time logs
docker-compose logs -f nginx-proxy-manager

# View access logs
docker-compose exec nginx-proxy-manager tail -f /data/logs/proxy_host/*/access.log

# Check Nginx configuration
docker-compose exec nginx-proxy-manager nginx -T
```

---

**Last Updated**: 2025-12-29  
**Service Category**: DevOps Infrastructure  
**Status**: Production Ready
