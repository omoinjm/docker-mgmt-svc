# 🤖 AI Context Guide for Docker Management Service Repository

This document provides essential context and instructions for AI systems (like GitHub Copilot, Claude, ChatGPT, OPENCODE etc.) working with this repository.

---

## ⚠️ Maintenance Notice

**THIS DOCUMENT MUST BE UPDATED whenever:**

- ✅ New service categories are added
- ✅ Existing categories are modified or renamed
- ✅ Core services are added/removed from any category
- ✅ Fundamental repository structure changes
- ✅ New organizational principles are introduced

**Who Updates This?** Any contributor adding core features. This keeps AI context accurate for future interactions.

## 📋 Repository Overview at a Glance

**Repository Name:** `docker-mgmt-svc`  
**Type:** Docker Configuration & Templates Library  
**Purpose:** Personal collection of containerized service setups organized by use case  
**Primary Tools:** Docker, Docker Compose, Bash scripts  
**Organization:** Structured by **use case groups** (4 main categories)

---

## 🎯 Core Context for AI Understanding

### What This Repository IS:

- ✅ A **template library** for spinning up containerized environments
- ✅ **Self-contained, modular** — each service can run independently
- ✅ **Development/experimentation focused** — not a production system
- ✅ **Organized by use case** — services grouped by their purpose/domain

### What This Repository IS NOT:

- ❌ A monolithic application
- ❌ A production deployment system
- ❌ A package/library meant for external distribution
- ❌ A CI/CD pipeline or automation framework

---

## 📂 Repository Structure & Categorization

### Use Case Groups (Organizational Principle)

The repository is organized into **4 primary use case categories**. This is the fundamental organizational principle:

```
docker-mgmt-svc/
├── osint-tools/           # Category 1: OSINT & Intelligence Gathering
├── ai-ml/                 # Category 2: AI & Machine Learning
├── devops-infra/          # Category 3: DevOps & Infrastructure
└── backend-services/      # Category 4: API & Backend Services
```

### Detailed Category Information

#### 1. **osint-tools/** — OSINT & Reconnaissance

**Purpose:** Intelligence gathering and person/organization research tools  
**Services:**

- `phoneinfoga/` — Phone number reconnaissance tool
- `sherlock-setup/` — Username search across social networks

**Typical Use:**

```bash
cd osint-tools/phoneinfoga
docker-compose up --build
```

---

#### 2. **ai-ml/** — AI & Machine Learning

**Purpose:** Local AI model runtime and machine learning environments  
**Services:**

- `ollama-setup/` — Ollama runtime with multi-stage base + model setup
  - `base/` — Base Docker image for Ollama
  - `models/` — Custom model configurations (DeepSeek, Llama3.2, etc.)
- `ollama-setup-v2/` — Simplified Ollama v2 runtime with automatic model pulling
  - Single-stage build with integrated model setup script
  - Supports various model sizes and types

**Architecture:**

- Multi-layer approach with base images + model-specific customizations
- Includes startup scripts for model initialization
- GPU acceleration support (optional)
- REST API for inference

**Typical Use:**

```bash
cd ai-ml/ollama-setup
docker build -t ollama-base -f base/Dockerfile .
docker-compose up --build

# OR

cd ai-ml/ollama-setup-v2
docker-compose up --build
```

---

#### 3. **devops-infra/** — DevOps & Infrastructure

**Purpose:** Monitoring, observability, reverse proxy, Docker management, and network management tools  
**Services:**

- `grafana/` — Monitoring and visualization dashboards
- `pi-hole/` — DNS-level ad blocking and network filtering
- `nginx-proxy-manager/` — Reverse proxy and load balancer for routing traffic to all services
- `portainer/` — Docker management UI for container, image, network, and volume management

**Typical Use:**

```bash
cd devops-infra/grafana
docker-compose up --build
```

---

#### 4. **backend-services/** — API & Backend Services

**Purpose:** API platforms and backend service configurations  
**Services:**

- `evolution-api/` — Evolution API service setup with Docker Compose

**Typical Use:**

```bash
cd backend-services/evolution-api
docker-compose up --build
```

---

## 🔧 Common File Patterns & What They Mean

### Docker Compose Files

**Location:** `{category}/{service}/docker-compose.yml`  
**Meaning:** Service can be started with `docker-compose up --build`  
**Typical use:** Orchestrating multiple containers or simplified single-service deployment

**Example:**

```yaml
# These files typically define:
# - Services and their images
# - Port mappings
# - Volume mounts
# - Environment variables
# - Dependencies between services
```

### Dockerfiles

**Location:** `{category}/{service}/Dockerfile` or `{category}/{service}/*/Dockerfile`  
**Meaning:** Custom image builds for that service  
**Typical use:** Building custom images with specific configurations

**Example patterns:**

```bash
# Base image (reused across multiple services)
base/Dockerfile

# Model-specific customizations
models/Dockerfile
```

### Shell Scripts

**Location:** `{category}/{service}/scripts/*.sh`  
**Meaning:** Automation scripts for initialization or setup  
**Common uses:** Model initialization, environment setup, service bootstrapping

### Configuration Files

**.env.example** — Template for environment variables  
**READNE.md** (or README.md) — Service-specific documentation

---

## 💡 Key Design Principles

### 1. **Self-Contained Services**

Each service folder is **completely independent**:

- Contains all necessary configs
- Can be cloned/copied elsewhere and still work
- No external dependencies on other folders

### 2. **Use Case Grouping**

Services are grouped by **business purpose**, not by technology:

- Makes it easy to find related services
- Logical organization for AI understanding
- Supports future scaling (add more services to existing groups)

### 3. **Modular Architecture**

Services use composition over monolithic design:

- Multi-layer Dockerfiles (base + customization)
- Docker Compose for orchestration
- Script-based initialization

### 4. **Development-First**

This is optimized for:

- Quick setup and iteration
- Local experimentation
- Learning and prototyping
- NOT for production-grade deployments

---

## 🚀 Common AI Tasks & Responses

### Task: "Add a new service"

**Response Template:**

1. Determine the **use case category** (OSINT, AI/ML, DevOps, or Backend)
2. Create folder: `{category}/{service-name}/`
3. Add appropriate files:
   - `docker-compose.yml` OR `Dockerfile`
   - `.env.example` (if needed)
   - Service-specific `README.md`
4. Follow patterns from existing services in that category
5. Update main `README.md` repository structure

**Example:**

```
New PostgreSQL service?
→ Goes in devops-infra/postgres-setup/
Follow pattern from devops-infra/grafana/
```

### Task: "Explain this service"

**Response Template:**

1. Identify the **use case category** first
2. Describe the **purpose** within that category
3. List **technologies** used
4. Explain the **typical workflow**
5. Reference relevant files

### Task: "Help me run a service"

**Response Template:**

1. Identify **which category** the service is in
2. Confirm **prerequisites** (Docker, Docker Compose, etc.)
3. Provide step-by-step **navigation & commands**
4. Mention **common customizations** (.env variables, ports, volumes)

### Task: "Understand the architecture"

**Response Template:**

1. Start with **use case grouping** explanation
2. Show the **services hierarchy**
3. Explain **inter-service dependencies** (if any)
4. Describe **data flow** for typical workflows
5. Highlight **customization points**

---

## 🎓 Important Context for AI Systems

### What Makes This Repository Unique

1. **Organization by use case**, not by technology stack
2. **Modular, self-contained** services (no tight coupling)
3. **Template-focused** (reusable, customizable)
4. **Development-oriented** (not production-grade)

### Common Misconceptions to Avoid

- ❌ Don't assume tight dependencies between services
- ❌ Don't suggest moving services to different categories without asking
- ❌ Don't propose production-grade changes (this is for dev/experimentation)
- ❌ Don't assume all services share a common base setup

### Assumptions You CAN Make

- ✅ User has Docker and Docker Compose installed
- ✅ Services are meant to be customized per-project
- ✅ Each folder can operate independently
- ✅ The use case categorization is intentional and should be maintained

---

## 🔄 Workflow for AI Interactions

When working with this repository, follow this mental model:

1. **Identify Use Case Category**
   - Which domain does this belong to? (OSINT/AI/DevOps/Backend)
   - Are there similar services already?

2. **Understand Service Context**
   - What files does it contain?
   - Is it Docker Compose or Dockerfile based?
   - What are its inputs/outputs?

3. **Reference Existing Patterns**
   - Look at similar services in the same category
   - Follow the same structure and naming conventions
   - Maintain consistency with established patterns

4. **Consider Modularity**
   - Keep services self-contained
   - Minimize inter-service dependencies
   - Support independent deployment

5. **Update Documentation**
   - Keep README.md structure consistent
   - Document new additions clearly
   - **Update docs/AI_CONTEXT.md for core features** (new categories, service changes, structural updates)

---

## 📌 File Reference Guide

| File/Folder             | Purpose               | AI Should...                                                 |
| ----------------------- | --------------------- | ------------------------------------------------------------ |
| `README.md`             | Main documentation    | Reference for structure & usage                              |
| `docs/AI_CONTEXT.md`    | This file (in docs/)  | Use to understand organization & **UPDATE for core changes** |
| `{category}/`           | Use case groups       | Respect as organizational principle                          |
| `{category}/{service}/` | Individual services   | Keep self-contained                                          |
| `docker-compose.yml`    | Service orchestration | Expect at service root                                       |
| `Dockerfile`            | Custom image build    | May be at root or in subdirs                                 |
| `.env.example`          | Config template       | Check for customization options                              |
| `scripts/*.sh`          | Automation            | Review for initialization logic                              |

---

## 🛠️ Development Guidelines for AI

### When Suggesting Changes:

1. **Preserve use case categorization** — don't move things around without context
2. **Maintain modularity** — keep services independent
3. **Follow existing patterns** — look at similar services first
4. **Test compatibility** — ensure Docker/Compose syntax is valid
5. **Document clearly** — update READMEs and this context file

### When Recommending Additions:

1. **Choose the right category** — ask if unclear
2. **Create consistent structure** — mirror existing services
3. **Include templates** — provide `.env.example` files
4. **Write clear docs** — service-specific README.md
5. **Reference this guide** — link back to organizational principles
6. **Update root README** — document the new/changed service (see below)

### When Updating Root README:

**CRITICAL:** Every time a service is added or significantly modified, the root `README.md` MUST be updated to reflect changes.

**Root README Sections to Update:**

1. **Repository Structure** section
   - Add new service to ASCII tree
   - Show folder hierarchy
   - Indicate service type/purpose

2. **Quick Start** or **Services Overview** section
   - Add entry for new service
   - Include port mappings
   - Describe purpose and typical use

3. **Category Descriptions** (if applicable)
   - Update category descriptions to include new service
   - Explain how it integrates with existing services
   - Add any new use case categories

**Example Update (when adding a service):**

```markdown
# Before:
## Quick Start
- **Grafana** (Port 3000) - Monitoring dashboards
- **Pi-hole** (Port 53) - DNS filtering

# After:
## Quick Start
- **Grafana** (Port 3000) - Monitoring dashboards
- **Pi-hole** (Port 53) - DNS filtering
- **Portainer** (Port 9000) - Docker management UI
```

**When to Update Root README:**

✅ Add new service category (e.g., osint-tools, devops-infra)
✅ Add new service to existing category
✅ Major changes to service architecture
✅ New port assignments or public-facing endpoints
✅ Change in service purpose or dependencies
✅ Service deprecation or removal

❌ Do NOT update for:
- Internal refactoring without external changes
- Documentation-only updates in service README
- Bug fixes that don't affect functionality

**How to Update:**

1. View the root `README.md` file
2. Locate relevant section (Structure, Quick Start, Services)
3. Add new service entry in same format as existing entries
4. Update repository structure ASCII tree if needed
5. Add brief description and port mapping
6. Commit with message: `docs: Update README for [service-name]`

### When Troubleshooting:

1. **Check prerequisites** — Docker, Docker Compose versions
2. **Review the service structure** — correct file locations?
3. **Examine environment files** — proper variable setup?
4. **Look at logs** — `docker-compose logs -f`
5. **Consult service README** — service-specific notes

---

## 📞 Quick Reference Commands

```bash
# Navigate to a service
cd {category}/{service}/

# Start a service (Docker Compose)
docker-compose up --build

# Start a service (Dockerfile)
docker build -t {image-name} .
docker run -d {image-name}

# View logs
docker-compose logs -f

# Stop all services
docker-compose down

# Clean up
docker system prune -a
```

---

## 📖 Maintaining the Root README.md

**IMPORTANT:** The root `README.md` is the main entry point for this repository. It must stay current with all service additions and changes.

### What the Root README Contains

The root `README.md` should include:

1. **Project Overview** — What this repository is for
2. **Repository Structure** — ASCII tree showing all categories and services
3. **Quick Start Guide** — How to run services
4. **Services Directory** — List of all services with:
   - Service name
   - Port mappings
   - Brief description
   - Typical use case

### Updating the Root README — Step-by-Step

**When you add a new service:**

1. Open `README.md` (root level)

2. Locate the **Repository Structure** section (typically near top)

3. Add the new service to the ASCII tree:
   ```
   Before:
   docker-mgmt-svc/
   └── devops-infra/
       ├── grafana/
       └── pi-hole/
   
   After:
   docker-mgmt-svc/
   └── devops-infra/
       ├── grafana/
       ├── pi-hole/
       └── portainer/  ← NEW
   ```

4. Find the **Services Overview** or **Quick Start** section

5. Add a new entry in the same format as existing services:
   ```markdown
   ### Portainer (Port 9000)
   **Category:** DevOps Infrastructure  
   **Purpose:** Docker container management UI
   **Quick Start:** `cd devops-infra/portainer && docker-compose up -d`
   ```

6. Save the file

7. Commit with message:
   ```bash
   git commit -m "docs: Add Portainer service to README"
   ```

### Service Entry Format

Use this consistent format for all service entries in the README:

```markdown
### Service Name (Port XXXX)
**Category:** Category Name  
**Purpose:** Brief description (1-2 sentences)  
**Environment:** Technologies used  
**Quick Start:** Command to start the service  
**Documentation:** Link to service README
```

### Example: Adding Ollama v2

```markdown
### Ollama v2 (Port 11434)
**Category:** AI & Machine Learning  
**Purpose:** Local LLM inference with automatic model pulling  
**Environment:** Docker, Python  
**Quick Start:** `cd ai-ml/ollama-setup-v2 && docker-compose up -d`  
**Documentation:** [Ollama v2 README](ai-ml/ollama-setup-v2/README.md)
```

### Updating the ASCII Tree

Always maintain the ASCII tree structure to show:
- Categories (folders)
- Services within each category
- Key files (docker-compose.yml, Dockerfile, README.md)

Format:
```
docker-mgmt-svc/
├── category-name/
│   ├── service-1/
│   │   ├── docker-compose.yml
│   │   ├── Dockerfile
│   │   └── README.md
│   └── service-2/
│       ├── docker-compose.yml
│       └── Dockerfile
└── docs/
    └── AI_CONTEXT.md
```

### What Sections to Update

| Section | Update When | Example |
|---------|------------|---------|
| Structure tree | New service added | Add folder to tree |
| Quick Start | New public-facing service | Add port + command |
| Services List | Any service added/removed | Add/remove entry |
| Port Mappings Table | Port changes | Update table row |
| Category Descriptions | New category created | Add category section |

### What NOT to Update Root README For

❌ Internal refactoring (no external changes)  
❌ Service README-only updates  
❌ Bug fixes (no functionality changes)  
❌ Version bumps (unless breaking changes)  
❌ Script improvements (unless interface changes)

### README Consistency Checklist

Before committing README changes, verify:

- [ ] Service appears in ASCII tree
- [ ] Service has entry in Quick Start section
- [ ] Port mapping is correct
- [ ] Category is correct
- [ ] Description is clear and concise
- [ ] All services alphabetically ordered (if applicable)
- [ ] Links to service README are correct
- [ ] No duplicate entries

### Commit Message Examples

```bash
# Adding a new service
git commit -m "docs: Add Portainer service to README"

# Adding a new category
git commit -m "docs: Add container-management category to README"

# Updating service entry
git commit -m "docs: Update Evolution API port mapping in README"

# Reorganizing structure
git commit -m "docs: Reorganize README service listings"
```

---

## 🎯 Success Metrics for AI Interactions

An AI system is providing good assistance when it:

- ✅ Respects the use case categorization
- ✅ Keeps services self-contained
- ✅ References existing patterns
- ✅ Maintains consistency with established structure
- ✅ Provides complete, tested solutions
- ✅ Updates documentation appropriately
- ✅ Explains the "why" behind recommendations

---

## 📝 Version & History

**Context Guide Version:** 1.1  
**Last Updated:** 2025-12-29  
**Location:** `docs/AI_CONTEXT.md`  
**Repository Structure:** Use case-based categorization (4 categories)  
**Target Audience:** AI systems and humans working with this repository

### Update Triggers

This document MUST be updated when:

- New service categories are created
- Existing categories are renamed or reorganized
- Core services are added to/removed from categories
- Fundamental repository structure changes
- New organizational principles are introduced

---

## 📚 Additional Resources

- **Main Repository README:** `README.md`
- **Service-Specific Documentation:** `{category}/{service}/README.md`
- **Docker Documentation:** https://docs.docker.com
- **Docker Compose Reference:** https://docs.docker.com/compose

---

**Remember:** This repository is a _development/experimentation toolkit_, organized by _use case_, designed for _quick setup and customization_. Respect these principles in all interactions.
