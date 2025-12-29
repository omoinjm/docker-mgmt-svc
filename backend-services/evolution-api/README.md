# Evolution API - WhatsApp Business API

Evolution API is an open-source WhatsApp API that enables integration with WhatsApp for sending/receiving messages, managing contacts, and building chatbots. This setup provides a containerized Evolution API instance with PostgreSQL and Redis backend services.

## 📋 Overview

- **Image:** `atendai/evolution-api:latest`
- **API Port:** `8080`
- **Database:** PostgreSQL 15
- **Cache:** Redis
- **Type:** WhatsApp messaging platform

## 🚀 Quick Start

### Prerequisites

1. Ensure `.env` file exists with proper configuration (see Configuration section)
2. Docker and Docker Compose installed

### Start All Services

```bash
cd backend-services/evolution-api
docker-compose up -d
```

Services will start in order:
1. PostgreSQL (database)
2. Redis (cache)
3. Evolution API (application)

### Verify Setup

```bash
# Check all services are running
docker-compose ps

# Check API is responding
curl http://localhost:8080/api/health

# View logs
docker-compose logs -f evolution-api
```

### Stop Services

```bash
docker-compose down
```

## 📖 Usage Examples

### 1. API Health Check

```bash
curl http://localhost:8080/api/health
```

Expected response:
```json
{
  "status": "ok",
  "message": "Evolution API is running"
}
```

### 2. List Active Instances

```bash
curl http://localhost:8080/api/instances
```

### 3. Create New WhatsApp Instance

```bash
curl -X POST http://localhost:8080/api/instances \
  -H "Content-Type: application/json" \
  -d '{"instanceName":"my-instance"}'
```

Response includes QR code for scanning.

### 4. Connect WhatsApp Account

1. Create instance (see above)
2. Get QR code from response
3. Scan with WhatsApp account on phone
4. Account is now connected

### 5. Send Message

```bash
curl -X POST http://localhost:8080/api/send/text \
  -H "Content-Type: application/json" \
  -d '{
    "instance": "my-instance",
    "number": "5511999999999",
    "text": "Hello from Evolution API!"
  }'
```

### 6. Listen to Webhooks

Configure in `.env`:
```env
WEBHOOK_URL=http://your-server.com/webhook
WEBHOOK_API_KEY=your-api-key
```

Evolution API will POST events to your webhook URL.

## ⚙️ Configuration

### Environment Variables (.env)

```env
# Database
DATABASE_HOST=postgres
DATABASE_PORT=5432
DATABASE_NAME=evolution
DATABASE_USER=admin
DATABASE_PASSWORD=admin

# Redis
REDIS_HOST=redis
REDIS_PORT=6379

# API
API_PORT=8080
API_KEY=your-secure-api-key-here

# Webhook (optional)
WEBHOOK_URL=http://your-domain.com/webhook
WEBHOOK_API_KEY=webhook-api-key

# Instance settings
MAX_INSTANCES=10
INSTANCE_TIMEOUT=60

# Logging
LOG_LEVEL=info
```

### Create .env File

Use `.env.example` as template:

```bash
cp .env.example .env

# Edit with your settings
nano .env
```

### Database Configuration

Default PostgreSQL:
- **Host:** postgres (container name)
- **Port:** 5432
- **Database:** evolution
- **User:** admin
- **Password:** admin (change this!)

Change in docker-compose.yml:
```yaml
environment:
  POSTGRES_USER: admin
  POSTGRES_PASSWORD: secure_password
  POSTGRES_DB: evolution
```

## 📊 API Endpoints

### Instance Management
- `GET /api/instances` - List all instances
- `POST /api/instances` - Create new instance
- `GET /api/instances/{instanceName}` - Get instance details
- `DELETE /api/instances/{instanceName}` - Delete instance

### Messages
- `POST /api/send/text` - Send text message
- `POST /api/send/media` - Send media (image, video, audio)
- `POST /api/send/document` - Send document
- `GET /api/messages/{instanceName}` - Get message history

### Contacts
- `GET /api/contacts/{instanceName}` - List contacts
- `POST /api/contacts/{instanceName}` - Add contact
- `DELETE /api/contacts/{instanceName}/{number}` - Delete contact

### Groups
- `GET /api/groups/{instanceName}` - List groups
- `POST /api/groups/{instanceName}/create` - Create group
- `POST /api/groups/{instanceName}/add-participant` - Add member

## 🔒 Security

### API Authentication

All requests must include API key:

```bash
curl -H "Authorization: Bearer YOUR_API_KEY" \
  http://localhost:8080/api/instances
```

### Set Strong Passwords

1. Change PostgreSQL password
2. Set unique API_KEY in .env
3. Use HTTPS in production

### Webhook Security

Include API key in webhook verification:

```bash
# Evolution API will send:
X-API-KEY: your-api-key

# Verify this in your webhook handler
```

## 💾 Data Persistence

### Volumes

```yaml
volumes:
  evolution_instances:/evolution/instances  # Instance data
  postgres_data:/var/lib/postgresql/data    # Database
```

### Backup Database

```bash
docker exec postgres pg_dump -U admin evolution > backup.sql
```

### Restore Database

```bash
docker exec -i postgres psql -U admin evolution < backup.sql
```

## 🆘 Troubleshooting

**API Not Responding:**
```bash
# Check container status
docker-compose ps

# Check logs
docker-compose logs -f evolution-api

# Test connectivity
curl -v http://localhost:8080/api/health
```

**Database Connection Error:**
```bash
# Check PostgreSQL is running
docker-compose logs postgres

# Verify credentials in .env
# Check DATABASE_HOST matches service name (postgres)

# Restart all services
docker-compose restart
```

**Redis Connection Issues:**
```bash
# Check Redis is running
docker-compose ps redis

# Test Redis connection
docker exec redis redis-cli ping

# Should return: PONG
```

**Instance Won't Connect:**
```bash
# Check logs for errors
docker-compose logs evolution-api

# Delete instance and try again
curl -X DELETE http://localhost:8080/api/instances/my-instance

# Recreate instance
curl -X POST http://localhost:8080/api/instances \
  -H "Content-Type: application/json" \
  -d '{"instanceName":"my-instance"}'
```

**QR Code Expired:**
```bash
# QR codes expire after ~2 minutes
# Recreate instance and scan immediately
curl -X DELETE http://localhost:8080/api/instances/my-instance
curl -X POST http://localhost:8080/api/instances ...
```

**Messages Not Sending:**
```bash
# Check instance is connected
curl http://localhost:8080/api/instances/my-instance

# Verify phone number format (include country code)
# Example: 5511999999999 for Brazil +55 11 9999-9999

# Check API logs
docker-compose logs evolution-api

# Verify rate limits aren't exceeded
```

## 📚 Documentation

- [Evolution API GitHub](https://github.com/EvolutionAPI/evolution-api)
- [API Documentation](https://github.com/EvolutionAPI/evolution-api/wiki)
- [WhatsApp Business Documentation](https://www.whatsapp.com/business/developers/)

## 🧹 Cleanup

### Remove All Services
```bash
docker-compose down
```

### Remove with Data (CAREFUL!)
```bash
docker-compose down -v
# This deletes:
# - Database
# - All instances
# - All messages
```

### Selective Cleanup

```bash
# Stop only Evolution API
docker-compose stop evolution-api

# Keep database and Redis running
docker-compose up -d
```

## 💡 Pro Tips

- Always use `.env` for sensitive data
- Keep API key secure (don't commit to git)
- Implement webhook rate limiting on your end
- Monitor instance connections in logs
- Test with a personal WhatsApp account first
- Set up regular database backups
- Use distinct instance names for different use cases
- Monitor disk space for message storage

## 📋 Common Workflows

### Setup Chatbot

1. Create instance
2. Configure webhook URL
3. Listen for incoming messages
4. Process and respond
5. Use send endpoints to reply

### Broadcast Messages

1. Create contact list
2. Loop through contacts
3. Send message to each (with delays to avoid rate limiting)
4. Log delivery status

### Group Management

1. Create group with initial members
2. Add/remove members dynamically
3. Send group announcements
4. Archive old groups

## 🔄 Regular Maintenance

- **Daily:** Monitor instance health
- **Weekly:** Check logs for errors
- **Monthly:** Backup database
- **Quarterly:** Update Evolution API image
- **Yearly:** Archive old message data
