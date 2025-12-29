# Portainer

**Portainer** is a lightweight Docker management UI that allows you to manage Docker containers, images, networks, volumes, and more from a web-based interface.

## Features

- 🐳 **Container Management** - Create, start, stop, remove, and inspect containers
- 🖼️ **Image Management** - Pull, push, build, and manage Docker images
- 🌐 **Network Management** - Create and manage Docker networks
- 💾 **Volume Management** - Create and manage Docker volumes
- 📊 **Monitoring** - View container logs, stats, and health status
- 🏗️ **App Templates** - Deploy pre-configured application templates
- 👥 **User Management** - Control access with user roles and permissions
- 🔌 **Edge Agent Support** - Manage remote Docker hosts through Edge agents
- 🔐 **Security** - Built-in authentication and SSL support

## Quick Start

```bash
# Start Portainer
docker-compose up -d

# Access the web UI
# URL: http://localhost:9000

# On first login, create your admin user and password
# Then manage all your Docker resources from the UI
```

## Port Mappings

| Port | Purpose | Usage |
|------|---------|-------|
| 9000 | Web UI  | Access Portainer management dashboard |
| 8000 | Edge Agent | For remote agent connections |

## Architecture

### Volume Structure

Portainer stores all data in a single named volume:

```yaml
portainer_data:
  ├── config.json          # Portainer configuration
  ├── portainer.db         # SQLite database
  ├── certs/               # SSL certificates (if configured)
  └── logs/                # Application logs
```

Data persists across container restarts via the `portainer_data` volume.

### Network Configuration

Portainer runs on an isolated network (`portainer-net`) to prevent unintended access from other services.

To allow services on other networks to be managed by Portainer, use the exposed Docker socket (`/var/run/docker.sock`).

## Configuration

### Environment Variables

Configure via `.env` file:

```bash
TZ=UTC  # Container timezone
```

### Docker Socket Access

Portainer requires access to the Docker daemon socket:

```bash
/var/run/docker.sock:/var/run/docker.sock:ro
```

The socket is mounted as **read-only** (`:ro`) for security.

## Typical Workflows

### 1. Access Portainer for the First Time

```bash
# Start the service
docker-compose up -d

# Navigate to UI
# http://localhost:9000

# Create admin account with strong password
# Email: admin@portainer.local
# Password: (your choice - secure this!)
```

### 2. Manage Containers

1. Click "Containers" in left sidebar
2. View all running/stopped containers
3. Click container name for detailed view
   - Logs tab: see container output
   - Inspect tab: view configuration
   - Stats tab: monitor resource usage
   - Terminal tab: execute commands inside container

### 3. Deploy Application Stack

1. Go to "Stacks" → "Add Stack"
2. Paste docker-compose.yml or select from templates
3. Configure services and environment variables
4. Click "Deploy" to start the stack

### 4. Monitor Container Health

1. Click "Containers"
2. Look for health indicators (green/yellow/red)
3. Click container for detailed status
4. Use Stats tab to monitor CPU, memory, network

### 5. Manage Images

1. Go to "Images"
2. Pull new images, remove unused ones
3. Build custom images from Dockerfiles
4. Push images to registries (if configured)

## Security Configuration

### Initial Setup (Important!)

⚠️ **On first login:**

1. Create strong admin password
2. Enable 2FA if available
3. Configure authentication method (local/OAuth/etc.)

### Best Practices

1. **Restrict Access** - Only expose port 9000 on trusted networks
2. **Change Default Password** - Never leave default credentials
3. **Use SSL/TLS** - Configure SSL certificates for HTTPS
4. **Limit Permissions** - Use role-based access control (RBAC)
5. **Backup Data** - Regularly backup portainer_data volume
6. **Keep Updated** - Update Portainer image regularly

### SSL/TLS Configuration (Optional)

To enable HTTPS:

1. Place SSL certificate and key in data volume
2. In Portainer Settings → Security → SSL certificate
3. Select your certificate files
4. Restart Portainer
5. Access via https://localhost:9000

## Common Tasks

### View Container Logs

```bash
# From CLI
docker logs portainer

# From UI
Containers → Select Container → Logs tab
```

### Execute Command in Container

1. Go to Containers
2. Click target container
3. Click "Terminal" tab
4. Type command and press Enter

### Create Network

1. Go to Networks
2. Click "Add network"
3. Enter network name, driver, and options
4. Click "Create"

### Create Volume

1. Go to Volumes
2. Click "Add volume"
3. Enter volume name and driver
4. Click "Create"

### Backup Configuration

```bash
# Backup portainer_data volume
docker run --rm -v portainer_data:/data -v $(pwd):/backup \
  alpine tar czf /backup/portainer-backup-$(date +%Y%m%d).tar.gz /data

# Restore from backup
docker run --rm -v portainer_data:/data -v $(pwd):/backup \
  alpine tar xzf /backup/portainer-backup-YYYYMMDD.tar.gz -C /
```

## Monitoring & Troubleshooting

### Check Service Status

```bash
# Is Portainer running?
docker-compose ps

# View logs
docker-compose logs -f portainer
```

### Common Issues

#### UI Not Accessible

```bash
# Restart service
docker-compose restart portainer

# Check port binding
netstat -tlnp | grep 9000

# View detailed logs
docker-compose logs portainer
```

#### Cannot Connect to Docker Socket

```bash
# Verify socket exists and is readable
ls -la /var/run/docker.sock

# Check Portainer container permissions
docker exec portainer id

# Restart and check logs
docker-compose restart portainer
docker-compose logs portainer
```

#### High Memory Usage

1. Check active containers (Containers tab)
2. Monitor container stats (Stats tab)
3. Reduce number of monitored containers if needed
4. Check event logs for errors

### Debug Commands

```bash
# View detailed container info
docker-compose exec portainer cat /data/portainer.db

# Check configuration
docker-compose exec portainer ls -la /data/

# Verify Docker socket connectivity
docker-compose exec portainer docker ps

# Check API health
curl http://localhost:9000/api/health
```

## Integration with Other Services

### Managing All Services from Portainer

Once running, Portainer can manage ALL your Docker services:

- **Evolution API** (backend-services)
- **Grafana** (devops-infra)
- **Pi-hole** (devops-infra)
- **Nginx Proxy Manager** (devops-infra)
- **Ollama** (ai-ml)
- **PhoneInfoga** (osint-tools)
- **Sherlock** (osint-tools)

### View Service Containers

1. Go to "Containers"
2. All running containers from all services appear here
3. Click any container to manage it

## Advanced Configuration

### Multiple Endpoints

Portainer can manage multiple Docker hosts:

1. Set up Edge Agent on remote host
2. In Portainer: Settings → Environments → Add environment
3. Select "Agent" and enter edge key
4. Connect to manage remote host

### Container Templates

Use pre-built templates for quick deployments:

1. Go to "App Templates"
2. Browse available templates
3. Click template to deploy
4. Configure environment variables
5. Deploy stack

### Registry Configuration

Manage private Docker registries:

1. Settings → Registries → Add registry
2. Enter registry URL and credentials
3. Use in Images: Pull/Push operations

## References

- **Official Documentation**: https://docs.portainer.io/
- **GitHub Repository**: https://github.com/portainer/portainer
- **Docker Hub**: https://hub.docker.com/r/portainer/portainer-ce
- **Community Forum**: https://www.portainer.io/community

## Logs and Debugging

```bash
# Real-time logs
docker-compose logs -f portainer

# Logs with timestamps
docker-compose logs --timestamps portainer

# Last 100 lines
docker-compose logs --tail=100 portainer

# Check API responses
curl -X GET http://localhost:9000/api/status

# List all endpoints/environments
curl -X GET http://localhost:9000/api/environments
```

## Data Backup & Recovery

### Backup

```bash
# Backup the portainer_data volume
mkdir -p ~/portainer-backups
docker run --rm -v portainer_data:/data -v ~/portainer-backups:/backup \
  alpine tar czf /backup/portainer-$(date +%Y%m%d-%H%M%S).tar.gz -C /data .

# List backups
ls -lh ~/portainer-backups/
```

### Restore

```bash
# Stop Portainer
docker-compose down

# Remove old data volume
docker volume rm portainer_data

# Restore from backup
docker volume create portainer_data
docker run --rm -v portainer_data:/data -v ~/portainer-backups:/backup \
  alpine tar xzf /backup/portainer-YYYYMMDD-HHMMSS.tar.gz -C /data

# Restart Portainer
docker-compose up -d
```

## Performance Tips

1. **Limit Container Count** - Monitor fewer containers for better performance
2. **Update Regularly** - Keep Portainer image up-to-date
3. **Monitor Resources** - Check CPU/memory usage in stats
4. **Cleanup Images** - Remove unused images regularly
5. **Archive Logs** - Clean up old container logs periodically

---

**Last Updated**: 2025-12-29  
**Service Category**: DevOps Infrastructure  
**Status**: Production Ready  
**Version**: Portainer CE (Community Edition)
