# Sherlock - Username Search

Sherlock is a tool that searches for usernames across social networks and public databases, helping identify online presence and potential accounts associated with a specific username.

## 📋 Overview

- **Image:** `sherlock/sherlock`
- **Tool:** Username reconnaissance across 300+ social networks
- **Output:** Results saved to `./sherlock/results/` directory
- **Type:** OSINT utility

## 🚀 Quick Start

### Basic Search
```bash
cd osint-tools/sherlock-setup
docker-compose run --rm sherlock <username>
```

Example:
```bash
docker-compose run --rm sherlock john_doe
```

### Results
Results are saved to `./sherlock/results/` with:
- JSON output: `sherlock_report_<username>.json`
- HTML output: `sherlock_report_<username>.html`
- CSV output (optional)

## 📖 Usage Examples

### Search for a Single Username
```bash
docker-compose run --rm sherlock --timeout 10 john_doe
```

### Search Multiple Usernames
```bash
docker-compose run --rm sherlock username1 username2 username3
```

### Search with Custom Timeout
```bash
docker-compose run --rm sherlock --timeout 5 myusername
```

### Save Results in Specific Format
```bash
# JSON output (default)
docker-compose run --rm sherlock --json myusername

# HTML output
docker-compose run --rm sherlock --html myusername

# CSV output
docker-compose run --rm sherlock --csv myusername

# All formats
docker-compose run --rm sherlock --json --html --csv myusername
```

### Check Available Sites
```bash
docker-compose run --rm sherlock -l
```

### Search Only Specific Sites
```bash
docker-compose run --rm sherlock --sites instagram twitter github myusername
```

## 📊 Output Format

### JSON Output Example
```json
{
  "username": "john_doe",
  "results": {
    "Instagram": {
      "status": "Found",
      "url": "https://www.instagram.com/john_doe/",
      "http_status": 200
    },
    "Twitter": {
      "status": "Found",
      "url": "https://twitter.com/john_doe",
      "http_status": 200
    }
  }
}
```

## ⚙️ Configuration

### Volume Mount
Results are automatically saved to:
```bash
./sherlock/results/  # Host directory
/opt/sherlock/results/  # Container directory
```

### Add Results Directory
```bash
mkdir -p ./sherlock/results
chmod 777 ./sherlock/results
```

## 🔍 What It Does

Sherlock searches for usernames across:
- ✅ 300+ social networks and websites
- ✅ Forums and communities
- ✅ Public databases
- ✅ Entertainment platforms
- ✅ Professional networks

## ⚠️ Important Notes

- Respects website rate limits
- Uses public information only
- Use responsibly and ethically
- Comply with Terms of Service of each site
- Some sites may block automated requests
- Results accuracy depends on site structure

## 📚 Documentation

- [Sherlock GitHub](https://github.com/sherlock-project/sherlock)
- [Full Documentation](https://github.com/sherlock-project/sherlock/wiki)

## 🆘 Troubleshooting

**Permission Denied on Results:**
```bash
chmod -R 777 ./sherlock/results/
```

**Container Exits Immediately:**
```bash
docker-compose run --rm sherlock --help
```

**Timeout Issues:**
```bash
# Increase timeout (in seconds)
docker-compose run --rm sherlock --timeout 30 username
```

**No Results Found:**
- Check username spelling
- Some popular usernames may not have results
- Site structure may have changed
- Try with `--verbose` flag for more details

**Rate Limiting:**
```bash
# Use longer timeout between requests
docker-compose run --rm sherlock --timeout 15 --retries 3 username
```

## 🧹 Cleanup

To remove the service:
```bash
docker-compose down

# To also clean up results
rm -rf ./sherlock/results/
```

## 💡 Pro Tips

- Use `--timeout 10` for faster searches with less accuracy
- Use `--timeout 30` for thorough searches
- Results are saved even if search is interrupted
- Review both JSON and HTML outputs for complete information
- Check the `http_status` field to verify actual matches

## 📋 Command Reference

```bash
# All available commands
docker-compose run --rm sherlock --help

# Common flags:
--timeout N          # Seconds to wait per site (default: 10)
--retries N          # Number of retries (default: 3)
--json              # JSON output format
--html              # HTML output format
--csv               # CSV output format
-l, --list          # List all supported sites
--sites SITE1 SITE2 # Search only specific sites
-v, --verbose       # Verbose output
```
