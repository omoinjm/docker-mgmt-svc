# Setup Pi-hole 🍒

## Step 1 Disable Ubuntu DNS Stub Listener

Ubuntu runs it's own DNS Stub Listener that is built into the systemd resolve service which will conflict with `Pi-hole`.

```bash
# Edit file resolved.conf
sudo vim /etc/systemd/resolved.conf
```

Find `#DNSStubListener=yes`.

```bash
# Remove the current resolv.conf file
sudo rm /etc/resolv.conf

# Create a symbolic link in its place to point elsewhere
sudo ln -s /run/systemd/resolve/resolv.conf /etc/resolv.conf
```

After making the changes, a restart is required.

```bash
sudo systemctl restart systemd-resolved
```

If you see a message about changes made to your system, restart `daemon` as well

```bash
sudo systemctl restart daemon-relaod
```

## Step 2 Configure Pi-hole with unbound

[Follow the steps listed here](https://ronamosa.io/docs/engineer/LAB/pihole-docker-unbound/)
