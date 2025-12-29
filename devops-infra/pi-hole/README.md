# Pi-hole - DNS-Level Ad Blocking

Pi-hole is a network-wide ad blocker and DNS server that prevents ads and malware at the network level. This setup provides a containerized Pi-hole instance with Unbound for recursive DNS resolution.

## 📋 Overview

- **Image:** `pihole/pihole:latest`
- **DNS Port:** `53` (TCP/UDP)
- **Web UI Port:** `80` (HTTP)
- **DHCP Port:** `67` (UDP) - optional
- **Type:** Network-wide DNS ad blocker

## ⚠️ Prerequisites

### 1. Disable Ubuntu DNS Stub Listener

Ubuntu's systemd-resolved conflicts with Pi-hole. You must disable it first:

```bash
# Edit resolved.conf
sudo nano /etc/systemd/resolved.conf
```

Find and modify this line:

```bash
DNSStubListener=yes
```

Change to:

```bash
DNSStubListener=no
```

### 2. Remove Old resolv.conf and Create Symlink

```bash
# Remove old file
sudo rm /etc/resolv.conf

# Create symlink
sudo ln -s /run/systemd/resolve/resolv.conf /etc/resolv.conf
```

### 3. Restart Services

```bash
# Restart systemd-resolved
sudo systemctl restart systemd-resolved

# If issues persist, restart daemon
sudo systemctl restart systemd-resolved.service
```

### 4. Verify DNS is Working

```bash
# Check DNS resolution
resolvectl status

# Test DNS
nslookup google.com
```

## 🚀 Quick Start

### Start Pi-hole

```bash
cd devops-infra/pi-hole
docker-compose up -d
```

### Access Web UI

```
http://localhost:80
```

### Get Admin Password

```bash
docker logs pihole | grep "password:"

# Or check docker-compose.yml for WEBPASSWORD variable
```

### Stop Pi-hole

```bash
docker-compose down
```

## 📖 Usage Examples

### 1. Access Admin Dashboard

```
http://localhost
```

Login with configured password (see docker-compose.yml)

### 2. Configure System DNS

**Linux (Netplan):**

```yaml
# /etc/netplan/00-installer-config.yaml
network:
  version: 2
  ethernets:
    eth0:
      dhcp4: no
      addresses: [192.168.1.100/24]
      gateway4: 192.168.1.1
      nameservers:
        addresses: [127.0.0.1] # Your Pi-hole server
```

Apply changes:

```bash
sudo netplan apply
```

**macOS:**

1. System Preferences → Network
2. Select active connection
3. DNS Servers → + → Enter Pi-hole IP
4. Apply

**Windows:**

1. Settings → Network & Internet → Change adapter options
2. Select adapter → Properties
3. IPv4 Properties → DNS servers → Enter Pi-hole IP

### 3. Check Dashboard

The web UI shows:

- Queries blocked today
- Percentage of ads blocked
- Top blocked domains
- Top allowed domains
- Recent queries

### 4. Configure Blocklists

1. Go to Admin → Adlists
2. Add blocklist URLs (see examples below)
3. Pi-hole automatically updates them

## ⚙️ Configuration

### Docker Compose Variables

Edit `docker-compose.yml`:

```yaml
environment:
  TZ: "America/Chicago" # Timezone
  WEBPASSWORD: "SecurePassword" # Web UI password
  DHCP_ACTIVE: "true" # Enable DHCP
  DHCP_START: "192.168.1.100" # DHCP range start
  DHCP_END: "192.168.1.200" # DHCP range end
  DHCP_ROUTER: "192.168.1.1" # DHCP gateway
```

### Unbound Configuration

For recursive DNS resolution (included in setup):

- Uses Unbound for upstream DNS
- No reliance on public DNS providers
- Better privacy
- Configuration stored in `unbound_data` Docker volume

### Data Persistence

Pi-hole uses Docker named volumes for data persistence:

```bash
# View volumes
docker volume ls | grep pihole

# Volumes used:
# - pihole_data: Pi-hole configuration and databases
# - dnsmasq_data: DNS masquerading config
# - unbound_data: Unbound DNS resolver config
```

**Backup configuration:**
```bash
docker run --rm -v pihole_data:/data -v $(pwd):/backup \
  alpine tar czf /backup/pihole-backup.tar.gz -C /data .
```

**Restore configuration:**
```bash
docker run --rm -v pihole_data:/data -v $(pwd):/backup \
  alpine tar xzf /backup/pihole-backup.tar.gz -C /data
```

## 📊 Popular Blocklists

Add these via Admin → Adlists:

```
# Standard blocklists
https://adaway.org/hosts.txt
https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts
https://www.malwaredomainlist.com/hostslist/hosts.txt

# More aggressive
https://pgl.yoyo.org/adservers/serverlist.php?hostformat=hosts
https://raw.githubusercontent.com/jdlingley/blocklist/master/ads-and-tracking-extended.txt

# Privacy blocklists
https://raw.githubusercontent.com/Perflyst/PiHoleBlocklist/master/SmartTV.txt
https://raw.githubusercontent.com/Perflyst/PiHoleBlocklist/master/android-tracking.txt
```

## 🔒 Security Features

### Whitelisting Domains

1. Go to Admin → Whitelist
2. Add domains to allow
3. Changes take effect immediately

### Blacklisting Domains

1. Go to Admin → Blacklist
2. Add domains to block
3. Changes take effect immediately

### Regex Filtering

Use regex patterns for advanced filtering:

```
^example\.com$     # Block example.com
^\.ads\..*$       # Block all ads subdomains
^tracker-.*\.net$ # Block tracker subdomains
```

## 📈 Monitoring

### View Statistics

1. Dashboard shows real-time stats
2. Query Log shows all DNS queries
3. Top items show most queried domains

### API Access

Get stats via API:

```bash
curl 'http://localhost/admin/api.php?status'
```

## 💾 Backup & Restore

### Backup All Volumes

```bash
# Backup Pi-hole configuration
docker run --rm -v pihole_data:/data -v $(pwd):/backup \
  alpine tar czf /backup/pihole-config-backup.tar.gz -C /data .

# Backup dnsmasq configuration
docker run --rm -v dnsmasq_data:/data -v $(pwd):/backup \
  alpine tar czf /backup/dnsmasq-backup.tar.gz -C /data .

# Backup Unbound configuration
docker run --rm -v unbound_data:/data -v $(pwd):/backup \
  alpine tar czf /backup/unbound-backup.tar.gz -C /data .
```

### Restore All Volumes

```bash
# Restore Pi-hole
docker run --rm -v pihole_data:/data -v $(pwd):/backup \
  alpine tar xzf /backup/pihole-config-backup.tar.gz -C /data

# Restore dnsmasq
docker run --rm -v dnsmasq_data:/data -v $(pwd):/backup \
  alpine tar xzf /backup/dnsmasq-backup.tar.gz -C /data

# Restore Unbound
docker run --rm -v unbound_data:/data -v $(pwd):/backup \
  alpine tar xzf /backup/unbound-backup.tar.gz -C /data

# Restart services
docker-compose restart
```

## 🆘 Troubleshooting

**DNS Not Resolving:**

```bash
# Check container is running
docker ps | grep pihole

# Check logs
docker-compose logs -f pihole

# Test DNS from host
nslookup google.com 127.0.0.1

# Verify no conflicts on port 53
sudo lsof -i :53
```

**Can't Access Admin Panel:**

```bash
# Check port 80
sudo lsof -i :80

# Test URL
curl http://localhost

# Check container logs
docker-compose logs pihole
```

**Lost Admin Password:**

```bash
# Stop Pi-hole
docker-compose down

# Update docker-compose.yml:
# WEBPASSWORD: 'NewSecurePassword'

# Start again
docker-compose up -d
```

**High CPU Usage:**

```bash
# Check what's consuming CPU
docker stats pihole

# Reduce blocklists (fewer = faster)
# Check for problematic blocklists in Admin → Adlists
```

**Clients Can't Connect:**

```bash
# Check Pi-hole IP address
docker inspect pihole | grep IPAddress

# Verify firewall allows port 53
sudo ufw allow 53

# Test from client
nslookup google.com 192.168.1.x  # Pi-hole IP
```

## 📚 Documentation

- [Pi-hole Official Docs](https://docs.pi-hole.net/)
- [Docker Pi-hole](https://github.com/pi-hole/docker-pi-hole)
- [Unbound Documentation](https://docs.unbound.net/)
- [Blocklist Collections](https://firebog.net/)

## 🧹 Cleanup

### Remove Service

```bash
docker-compose down
```

### Remove with Data

```bash
docker-compose down -v
```

### Reset to Defaults

```bash
docker-compose down -v
# Removes all volumes: pihole_data, dnsmasq_data, unbound_data
docker-compose up -d
```

## 💡 Pro Tips

- Start with fewer blocklists and add gradually
- Monitor query log for false positives
- Whitelist domains that break services
- Use gravity to calculate blocklist efficiency
- Enable DHCP if managing network
- Set up clients to use Pi-hole's IP for DNS
- Regular backups recommended
- Monitor "blocked percentage" - 5-15% is typical

## 📋 Common Configurations

### Typical Setup

```bash
# 1. Disable Ubuntu DNS Stub Listener (see Prerequisites)
# 2. Start Pi-hole
docker-compose up -d

# 3. Point your devices to Pi-hole IP
# 4. Add blocklists in Admin → Adlists
# 5. Monitor in Dashboard
```

### Pi-hole + Unbound (Recursive DNS)

This setup includes Unbound for:

- Better privacy (no reliance on ISP/public DNS)
- Faster resolution
- DNSSEC validation

Configuration in `unbound/` directory handles this automatically.

### Multiple Blocklists

1. Start with 1-2 blocklists
2. Monitor for false positives
3. Add 1-2 more weekly if stable
4. Balance blocking vs. usability

## 🔄 Regular Maintenance

- **Weekly:** Check query logs for issues
- **Monthly:** Review blocklist effectiveness
- **Quarterly:** Update blocklists
- **Yearly:** Backup configuration
