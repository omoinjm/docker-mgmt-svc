# Phoneinfoga - Phone Number Reconnaissance

A lightweight tool for gathering information about phone numbers. This setup runs Phoneinfoga in a containerized environment accessible via web UI.

## 📋 Overview

- **Image:** `sundowndev/phoneinfoga:latest`
- **Web UI Port:** `5000` → mapped to `85` on host
- **Service:** REST API server for phone number intelligence

## 🚀 Quick Start

### Start the Service

```bash
cd osint-tools/phoneinfoga
docker-compose up -d
```

### Access the Web UI

Open your browser and navigate to:

```
http://localhost:85
```

### Stop the Service

```bash
docker-compose down -d
```

## 📖 Usage Examples

### Using the Web Interface

1. Navigate to `http://localhost:85`
2. Enter a phone number in international format (e.g., +1234567890)
3. Click "Search" to gather information

### Using the REST API

```bash
# Basic request
curl http://localhost:85/api/v1/info?number=%2B1234567890

# Response includes:
# - Phone number validity
# - Carrier information
# - Geographic data
# - Potential security risks
```

## ⚙️ Configuration

### Environment Variables

Currently uses default configuration. Modify `docker-compose.yml` to add:

- Custom API keys (if using premium services)
- Debug options

### Persistent Data

Results are not persisted by default. To keep results:

```yaml
volumes:
  - ./results:/app/results
```

## 🔍 What It Does

Phoneinfoga gathers information such as:

- ✅ Phone number validation
- ✅ Carrier detection
- ✅ Country/region identification
- ✅ Possible security risks

## ⚠️ Important Notes

- Results are based on publicly available data
- Information accuracy depends on data source availability
- Some numbers may not return complete information
- Use responsibly and in compliance with local laws

## 📚 Documentation

- [Phoneinfoga GitHub](https://github.com/sundowndev/phoneinfoga)
- [API Documentation](https://github.com/sundowndev/phoneinfoga/wiki/API)

## 🆘 Troubleshooting

**Port Already in Use:**

```bash
# Change port in docker-compose.yml
ports:
  - "8085:5000"  # Use 8085 instead of 85
```

**Service Won't Start:**

```bash
docker-compose logs -f phoneinfoga
```

**No Results Returned:**

- Check internet connectivity
- Verify phone number format
- Some regions may have limited data availability

## 🧹 Cleanup

To remove the service and all data:

```bash
docker-compose down -v
```
