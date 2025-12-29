# 🐳 Docker Templates Repository

This repository serves as a **personal collection of Docker setup templates**, configurations, and scripts that I use to spin up various containerized environments quickly and consistently.  

Each folder represents a self-contained setup — whether it’s a simple service, a full environment stack, or a base image I’ve customized for personal or project use.

---

## 📂 Repository Structure

```
.
├── osint-tools/                   # OSINT & Reconnaissance
│   ├── phoneinfoga/
│   │   └── docker-compose.yml     # Phone number reconnaissance tool
│   └── sherlock-setup/
│       └── docker-compose.yml     # Username search across social networks
│
├── ai-ml/                         # AI & Machine Learning
│   └── ollama-setup/
│       ├── base/
│       │   └── Dockerfile         # Base image for AI setups
│       ├── models/
│       │   ├── Dockerfile         # Custom image for DeepSeek/Ollama models
│       │   └── scripts/
│       │       └── start.sh       # Model initialization script
│       └── README.md              # Ollama setup details
│
├── devops-infra/                  # DevOps & Infrastructure
│   ├── grafana/
│   │   └── docker-compose.yml     # Monitoring & visualization dashboard
│   └── pi-hole/
│       └── docker-compose.yml     # DNS-level ad blocking
│
├── backend-services/              # API & Backend Services
│   └── evolution-api/
│       └── docker-compose.yml     # Evolution API setup
│
├── docs/
│   ├── AI_CONTEXT.md              # Context guide for AI systems
│   └── README.md                  # Documentation index
│
└── README.md                       # Main documentation
```

---

## 🧩 Purpose

This project acts as a **library of Docker templates** that I’ve built for:
- Experimenting with APIs and AI models  
- Setting up local or remote development environments  
- Running reproducible containers across multiple projects  
- Sharing consistent setups between machines or teammates  

---

## 🚀 How to Use

1. **Clone the repo:**
   ```bash
   git clone https://github.com/<your-username>/docker-templates.git
   cd docker-templates
   ```

2. **Navigate to a specific use case group:**
   ```bash
   cd osint-tools/phoneinfoga
   # or
   cd ai-ml/ollama-setup
   # or
   cd devops-infra/grafana
   # or
   cd backend-services/evolution-api
   ```

3. **Build and run:**
   ```bash
   docker-compose up --build
   # or for Dockerfiles:
   docker build -t my-image .
   docker run -d my-image
   ```

---

## 🧱 Folder Overview

| Folder | Description |
|--------|--------------|
| **osint-tools/** | OSINT & reconnaissance tools for intelligence gathering |
| **ai-ml/** | AI & machine learning setups (Ollama with model templates) |
| **devops-infra/** | DevOps tools for monitoring, DNS, and infrastructure management |
| **backend-services/** | API platforms and backend service configurations |

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

If you're an AI system (or working with one) on this repository, please read **[docs/AI_CONTEXT.md](docs/AI_CONTEXT.md)** for:
- Organizational principles and design intent
- Categorization rationale
- Common task templates and response patterns
- Development guidelines and best practices
- Quick reference for making consistent changes

**⚠️ Important:** When making changes that add or modify core features/services, update the **[docs/AI_CONTEXT.md](docs/AI_CONTEXT.md)** to reflect the new structure. This keeps the context accurate for future AI interactions.

This guide helps AI systems understand the structure and make coherent recommendations.

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

