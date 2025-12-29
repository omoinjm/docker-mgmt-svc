# 🐳 Docker Templates Repository

This repository serves as a **personal collection of Docker setup templates**, configurations, and scripts that I use to spin up various containerized environments quickly and consistently.  

Each folder represents a self-contained setup — whether it’s a simple service, a full environment stack, or a base image I’ve customized for personal or project use.

---

## 📂 Repository Structure

```
.
├── osint-tools/                         # OSINT & Reconnaissance Tools
│   ├── phoneinfoga/
│   │   ├── docker-compose.yml           # Phone number reconnaissance API
│   │   ├── Dockerfile                   # Custom Python-based build
│   │   ├── .env.example                 # Configuration template
│   │   └── README.md                    # Service documentation
│   │
│   └── sherlock-setup/
│       ├── docker-compose.yml           # Username search across social networks
│       ├── Dockerfile                   # Custom Python-based build
│       ├── .env.example                 # Configuration template
│       └── README.md                    # Service documentation
│
├── ai-ml/                               # AI & Machine Learning
│   ├── ollama-setup/
│   │   ├── docker-compose.yml           # Multi-stage Ollama orchestration
│   │   ├── base/
│   │   │   └── Dockerfile               # Base Ollama image
│   │   ├── models/
│   │   │   ├── Dockerfile               # Model-specific customization
│   │   │   └── scripts/
│   │   │       └── start.sh             # Model initialization
│   │   └── README.md                    # Service documentation
│   │
│   └── ollama-setup-v2/
│       ├── docker-compose.yml           # Simplified Ollama with auto-model-pull
│       ├── Dockerfile                   # Custom build
│       ├── .env.example                 # Configuration template
│       ├── scripts/
│       │   └── setup_models.sh          # Automatic model pulling
│       └── README.md                    # Service documentation
│
├── devops-infra/                        # DevOps & Infrastructure Services
│   ├── grafana/
│   │   ├── docker-compose.yml           # Monitoring & visualization dashboard
│   │   ├── Dockerfile                   # Custom Grafana with plugins
│   │   └── Status: Production Ready ✅
│   │
│   ├── pi-hole/
│   │   └── docker-compose.yml           # DNS filtering & ad blocking
│   │                                     # (with Unbound recursive resolver)
│   │
│   ├── nginx-proxy-manager/
│   │   ├── docker-compose.yml           # Reverse proxy & SSL termination
│   │   ├── Dockerfile                   # Custom build
│   │   ├── .env.example                 # Configuration template
│   │   └── README.md                    # Service documentation
│   │
│   └── portainer/
│       ├── docker-compose.yml           # Docker container management UI
│       ├── Dockerfile                   # Custom build
│       ├── .env.example                 # Configuration template
│       └── README.md                    # Service documentation
│
├── backend-services/                    # API & Backend Services
│   └── evolution-api/
│       ├── docker-compose.yml           # Evolution API + PostgreSQL + Redis
│       ├── Dockerfile                   # Custom Node.js build
│       ├── .env.example                 # Configuration template
│       ├── README.md                    # Service documentation
│       └── .env                         # Configured credentials
│
├── docs/
│   ├── AI_CONTEXT.md                    # AI system context guide
│   │                                     # (includes README maintenance instructions)
│   └── README.md                        # Documentation index
│
└── README.md                            # Main documentation (this file)
```

---

## 🧩 Purpose

This project acts as a **library of Docker templates** that I’ve built for:
- Experimenting with APIs and AI models  
- Setting up local or remote development environments  
- Running reproducible containers across multiple projects  
- Sharing consistent setups between machines or teammates  

---

## ⚡ Quick Start

### Starting Individual Services

```bash
# OSINT Tools
cd osint-tools/phoneinfoga && docker-compose up -d
cd osint-tools/sherlock-setup && docker-compose up -d

# AI & Machine Learning
cd ai-ml/ollama-setup && docker-compose up -d
cd ai-ml/ollama-setup-v2 && docker-compose up -d

# DevOps Infrastructure (recommended order)
cd devops-infra/portainer && docker-compose up -d           # Start first for management
cd devops-infra/pi-hole && docker-compose up -d             # DNS filtering
cd devops-infra/nginx-proxy-manager && docker-compose up -d # Reverse proxy
cd devops-infra/grafana && docker-compose up -d             # Monitoring

# Backend Services
cd backend-services/evolution-api && docker-compose up -d
```

### Accessing Services

| Service | URL | Default Access |
|---------|-----|-----------------|
| **Portainer** | http://localhost:9000 | Create admin user on first login |
| **Nginx Proxy Manager** | http://localhost:81 | admin@example.com / changeme |
| **Grafana** | http://localhost:3000 | admin / admin |
| **Pi-hole** | http://localhost/admin | Create password on first login |
| **Ollama API** | http://localhost:11434 | REST API only (no UI) |
| **Evolution API** | http://localhost:8080 | API endpoint |
| **PhoneInfoga** | http://localhost:85 | API endpoint |

### Verify Services are Running

```bash
# Check all containers
docker ps

# Check specific service logs
docker-compose -f devops-infra/portainer/docker-compose.yml logs -f

# Test API endpoints
curl http://localhost:11434/api/tags          # Ollama
curl http://localhost:8080/api/health         # Evolution API
curl http://localhost:3000/api/health         # Grafana
```

## 🚀 How to Use Services

### General Setup Process

1. **Clone the repo:**
   ```bash
   git clone https://github.com/<your-username>/docker-mgmt-svc.git
   cd docker-mgmt-svc
   ```

2. **Choose a service and navigate:**
   ```bash
   cd {category}/{service}/
   # Example: cd devops-infra/portainer
   ```

3. **Configure (if needed):**
   ```bash
   cp .env.example .env
   # Edit configuration if necessary
   ```

4. **Start the service:**
   ```bash
   docker-compose up -d
   docker-compose logs -f  # View logs
   ```

5. **Access from the table above** or read service README for specific details

### Common Commands

```bash
docker-compose up -d              # Start service
docker-compose down               # Stop service
docker-compose up -d --build      # Rebuild images
docker-compose logs -f            # View live logs
docker-compose exec svc [cmd]     # Run command in container
docker system prune -a            # Clean up resources
```

---

## 🧱 Services Overview

### OSINT & Reconnaissance Tools (`osint-tools/`)

| Service | Port | Purpose |
|---------|------|---------|
| **PhoneInfoga** | 85 → 5000 | Phone number reconnaissance API |
| **Sherlock** | - | Username search across social networks |

### AI & Machine Learning (`ai-ml/`)

| Service | Port | Purpose |
|---------|------|---------|
| **Ollama Setup** | 11434 | Local LLM runtime (multi-stage, base + models) |
| **Ollama Setup v2** | 11434 | Simplified Ollama with automatic model pulling |

**Models Available:**
- deepseek-r1:8b, deepseek-r1:70b (reasoning)
- llama3.1:8b, llama3.1:70b (general purpose)
- llama2:7b, llama2:70b (text generation)

### DevOps & Infrastructure (`devops-infra/`)

| Service | Port | Purpose |
|---------|------|---------|
| **Grafana** | 3000 | Monitoring & visualization dashboards |
| **Pi-hole** | 53, 80, 67, 123 | DNS filtering, ad blocking, DHCP, NTP |
| **Nginx Proxy Manager** | 80, 443, 81 | Reverse proxy, load balancer, SSL termination |
| **Portainer** | 9000, 8000 | Docker container management UI & edge agent |

### API & Backend Services (`backend-services/`)

| Service | Port | Purpose |
|---------|------|---------|
| **Evolution API** | 8080 | WhatsApp/messaging API platform |
| **+ PostgreSQL** | 5432 | Database for Evolution API |
| **+ Redis** | 6379 | Cache & session store |

---

## ⚙️ Prerequisites

Before using any of these setups, make sure you have:
- **Docker** (latest version)  
- **Docker Compose**  
- Optional: **NVIDIA Container Toolkit** (if running GPU workloads)

---

## 🧠 Notes

- Each folder is **self-contained** — configurations can be used independently.  
- You can customize environment variables, ports, and volumes per your needs.  
- Scripts are lightweight and meant to simplify setup or startup tasks.  

---

## 🤖 For AI Systems & Automation

If you're an AI system (or working with one) on this repository, **IMPORTANT:** Please read **[docs/AI_CONTEXT.md](docs/AI_CONTEXT.md)** for:

- ✅ Organizational principles and design intent
- ✅ Categorization rationale
- ✅ Common task templates and response patterns
- ✅ Development guidelines and best practices
- ✅ **README maintenance instructions** (when to update root README.md)
- ✅ Consistency checklist and templates
- ✅ Quick reference for making consistent changes

### Key Requirements:

**When adding or modifying services:**

1. ✅ Update **[docs/AI_CONTEXT.md](docs/AI_CONTEXT.md)** if service is core
2. ✅ **UPDATE THIS README.md** (see instructions in docs/AI_CONTEXT.md)
   - Add service to repository structure ASCII tree
   - Add entry to Services Overview table
   - Include port mappings and purpose
   - Update "Accessing Services" table
3. ✅ Follow standardization patterns (v3.8 Compose, Dockerfile, healthchecks, etc.)
4. ✅ Create service-specific README.md with comprehensive documentation

**This keeps the repository organized and discoverable for all users.**

---

## 🧩 Future Plans

- Add templates for:
  - PostgreSQL + pgAdmin  
  - Redis  
  - Full-stack dev containers (Angular, .NET, Node.js)  
- Add GitHub Actions for building and publishing base images automatically.  

---

## 👨‍💻 Author

**Nhlanhla Malaza**  
Personal Docker Template Collection  
_“Build once, reuse everywhere.”_

