# Grafana - Monitoring & Visualization

Grafana is an open-source monitoring and visualization platform. This setup provides a containerized Grafana instance for creating dashboards from various data sources.

## 📋 Overview

- **Image:** `grafana/grafana-enterprise`
- **Web UI Port:** `3000`
- **Storage:** Named volume (`grafana_storage`)
- **Type:** Monitoring & analytics platform

## 🚀 Quick Start

### Setup Configuration

```bash
cd devops-infra/grafana

# Copy environment template
cp .env.example .env

# Edit with your settings (especially admin password!)
nano .env
```

### Start Grafana

```bash
docker-compose up -d
```

### Access Web UI

Open your browser and navigate to:

```
http://localhost:3000
```

### Default Credentials

- **Username:** `admin`
- **Password:** `admin`
- ⚠️ Change immediately on first login

### Stop Grafana

```bash
docker-compose down -d
```

## 📖 Usage Examples

### 1. Access Grafana Dashboard

```
http://localhost:3000
```

### 2. Add a Data Source

1. Click "Data Sources" (or Connections → Data Sources)
2. Click "Add data source"
3. Select data source type (Prometheus, InfluxDB, etc.)
4. Configure connection details
5. Click "Save & Test"

### 3. Create a Dashboard

1. Click "+" → "Dashboard"
2. Click "Add panel"
3. Select data source
4. Write query and configure visualization
5. Save dashboard

### 4. Create an Alert

1. In a panel, click "Alert"
2. Configure alert conditions
3. Set notification channels
4. Save

## ⚙️ Configuration

### Environment Variables

Edit in `docker-compose.yml`:

```yaml
environment:
  - GF_SERVER_ROOT_URL=http://my.grafana.server/
  - GF_SECURITY_ADMIN_PASSWORD=newpassword
  - GF_USERS_ALLOW_SIGN_UP=false
  - GF_INSTALL_PLUGINS=grafana-piechart-panel
```

### Common Settings

```yaml
# Server
GF_SERVER_ROOT_URL=http://localhost:3000
GF_SERVER_DOMAIN=localhost
GF_SERVER_ENFORCE_DOMAIN=true

# Security
GF_SECURITY_ADMIN_USER=admin
GF_SECURITY_ADMIN_PASSWORD=admin123
GF_SECURITY_DISABLE_BRUTE_FORCE_LOGIN_PROTECTION=false

# Features
GF_USERS_ALLOW_SIGN_UP=false
GF_AUTH_ANONYMOUS_ENABLED=false

# Plugins
GF_INSTALL_PLUGINS=grafana-clock-panel,grafana-piechart-panel
```

### Change Admin Password

**On First Login:**

1. Navigate to `http://localhost:3000`
2. Login with `admin/admin`
3. Follow password change prompt

**Later Changes:**

1. Click user icon (bottom left)
2. Select "Change password"
3. Enter new password

**Via Environment Variable:**

```yaml
environment:
  - GF_SECURITY_ADMIN_PASSWORD=secure_password_here
```

## 📦 Adding Data Sources

### Prometheus

- **Type:** Prometheus
- **URL:** `http://prometheus:9090`
- **Auth:** None (unless configured)

### InfluxDB

- **Type:** InfluxDB
- **URL:** `http://influxdb:8086`
- **Database:** Your database name

### Elasticsearch

- **Type:** Elasticsearch
- **URL:** `http://elasticsearch:9200`
- **Index:** Your index pattern

### Loki (Logs)

- **Type:** Loki
- **URL:** `http://loki:3100`

## 📊 Creating Dashboards

### Dashboard Types

**Basic Panel Types:**

- Graph (Time series)
- Table
- Stat
- Gauge
- Bar chart
- Pie chart
- Text
- Alert list

### Best Practices

1. Use descriptive panel titles
2. Add units to metrics (CPU %, Memory MB, etc.)
3. Set appropriate time ranges
4. Use meaningful colors
5. Document dashboard purpose

## 💾 Data Persistence

### Volume Management

```bash
# Check volume
docker volume inspect grafana_storage

# Backup data
docker run --rm \
  -v grafana_storage:/data \
  -v $(pwd):/backup \
  alpine tar czf /backup/grafana-backup.tar.gz -C /data .

# Restore data
docker run --rm \
  -v grafana_storage:/data \
  -v $(pwd):/backup \
  alpine tar xzf /backup/grafana-backup.tar.gz -C /data
```

## 🔒 Security Considerations

### Recommendations

- ✅ Change default admin password
- ✅ Disable anonymous access if not needed
- ✅ Use HTTPS in production (configure proxy)
- ✅ Restrict sign-up capability
- ✅ Regular backups
- ✅ Keep Grafana updated

### Behind Reverse Proxy

```yaml
environment:
  - GF_SERVER_ROOT_URL=https://grafana.example.com
  - GF_SERVER_DOMAIN=grafana.example.com
  - GF_SECURITY_DISABLE_GRAVATAR=true
```

## 🔌 Available Plugins

Install plugins via environment variable:

```yaml
environment:
  - GF_INSTALL_PLUGINS=grafana-clock-panel,grafana-piechart-panel,redis-datasource
```

Popular plugins:

- `grafana-clock-panel` — Clock visualization
- `grafana-piechart-panel` — Pie chart panel
- `redis-datasource` — Redis data source
- `grafana-worldmap-panel` — Worldmap visualization

## 🆘 Troubleshooting

**Can't Access Web UI:**

```bash
# Check if container is running
docker ps | grep grafana

# Check logs
docker-compose logs -f grafana

# Check port availability
netstat -an | grep 3000
```

**Forgot Admin Password:**

```bash
# Stop container
docker-compose down

# Edit docker-compose.yml and change environment:
# GF_SECURITY_ADMIN_PASSWORD=newpassword

# Restart
docker-compose up -d

# Login with new password
```

**Data Source Connection Failed:**

```bash
# Check data source URL
# If using docker network, use container name instead of localhost
# Example: http://prometheus:9090 instead of http://localhost:9090

# Test connection in Grafana UI:
# In Data Source settings, click "Save & Test"
```

**Dashboards Not Appearing:**

```bash
# Check dashboard provisioning
docker exec <grafana_container> \
  find /var/lib/grafana/dashboards -name "*.json" -type f
```

## 📚 Documentation

- [Grafana Official Docs](https://grafana.com/docs/grafana/)
- [Dashboard Management](https://grafana.com/docs/grafana/latest/dashboards/)
- [Data Sources](https://grafana.com/docs/grafana/latest/datasources/)
- [Plugin Directory](https://grafana.com/grafana/plugins/)

## 🧹 Cleanup

```bash
# Remove Service
docker-compose down

# Remove with Data
docker-compose down -v
```

## 💡 Pro Tips

- Import existing dashboards from [Grafana Dashboards](https://grafana.com/grafana/dashboards/)
- Use variables for dynamic filtering
- Set up alerts for critical metrics
- Create dashboard folders for organization
- Use annotations for event marking
- Export dashboards as JSON for version control

## 📋 Common Workflows

### Monitor Docker Containers

1. Add data source: Prometheus
2. Import dashboard: "Docker and system monitoring"
3. Visualize container metrics

### Track Application Metrics

1. Instrument app with metrics library
2. Export metrics to Prometheus
3. Create custom dashboards in Grafana

### Log Aggregation

1. Set up Loki with log shipper
2. Add Loki data source
3. Create log panels with LogQL queries
