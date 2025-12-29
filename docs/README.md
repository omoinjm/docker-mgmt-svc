# 📚 Documentation Index

This folder contains comprehensive documentation for the `docker-mgmt-svc` repository.

## 📖 Available Documents

### [AI_CONTEXT.md](AI_CONTEXT.md)
**For:** AI systems and automation tools  
**Purpose:** Complete context guide for understanding the repository structure and making consistent decisions

**Key Sections:**
- Repository overview and categorization
- Use case groups explanation (4 categories)
- Design principles and patterns
- Task templates for common AI interactions
- File reference guide
- Development guidelines
- **Update triggers** — when this document must be updated

**Read this when:**
- You're an AI system working on this repo
- You're about to make structural changes
- You need to add new services
- You want to understand the organizational logic

---

## 🔄 Document Maintenance

### Who Updates These Documents?
Anyone making **core feature changes** to the repository:
- Adding new service categories
- Reorganizing existing categories
- Adding/removing major services
- Changing fundamental repository structure

### What Counts as "Core Features"?
- ✅ New use-case category folders (e.g., `monitoring-tools/`)
- ✅ Moving services between categories
- ✅ Adding services to new categories
- ✅ Renaming/restructuring categories
- ❌ Adding a new service to existing category (update `README.md` only)
- ❌ Modifying service-specific configs
- ❌ Documentation fixes in category READMEs

### Update Checklist
When making core changes:
- [ ] Make the structural change (create folders, move files)
- [ ] Update main `README.md` with new structure
- [ ] Update `docs/AI_CONTEXT.md` with new organizational details
- [ ] Commit with clear message explaining the changes
- [ ] Reference the update in commit message

---

## 🚀 Quick Links

- **[Main Repository README](../README.md)** — Usage guide and quick start
- **[Repository Structure](../README.md#-repository-structure)** — Visual overview
- **[Use Case Categories](../README.md#-folder-overview)** — What each category does

---

**Last Updated:** 2025-12-29
