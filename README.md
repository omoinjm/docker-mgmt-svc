# 🐳 Docker Templates Repository

This repository serves as a **personal collection of Docker setup templates**, configurations, and scripts that I use to spin up various containerized environments quickly and consistently.  

Each folder represents a self-contained setup — whether it’s a simple service, a full environment stack, or a base image I’ve customized for personal or project use.

---

## 📂 Repository Structure

```
.
├── evolution-api/
│   └── docker-compose.yml         # Docker Compose setup for the Evolution API
│
└── ollama-setup/
    ├── base/
    │   └── Dockerfile             # Base image used across multiple AI-related setups
    │
    ├── deepseek/
    │   ├── Dockerfile             # Custom image for running DeepSeek or Ollama models
    │   └── scripts/
    │       └── start.sh           # Startup script for model initialization
    │
    └── README.md                  # Details about the Ollama setup
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

2. **Navigate to a specific setup:**
   ```bash
   cd evolution-api
   # or
   cd ollama-setup/deepseek
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
| **evolution-api/** | Contains the Docker Compose configuration for the Evolution API. |
| **ollama-setup/** | Templates for setting up AI-related environments like DeepSeek or Ollama. |
| **base/** | Base image used as a foundation for other Docker builds. |
| **deepseek/** | Custom container setup for DeepSeek model operations. |

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

