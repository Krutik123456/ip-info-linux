# IP and location linux — Public IP Lookup Tool

Type `ip` in the terminal and get your **public IPv4**, **IPv6**, **location**, **ISP**, and **timezone** — plus normal `ip` command behavior fully preserved.

```
$ ip
  Public IPv4 : 117.100.217.81
  Public IPv6 : <none>
  Location    : Mumbai, Maharashtra (400017) [IN]
  ISP / Org   : AInternet Backbone
  Timezone    : Asia

When called with no arguments, `ip` shows your public info.
When called with any arguments (e.g. `ip addr`, `ip link`), it passes through to the real system `ip` command — normal behavior is fully preserved.

---

## Requirements

- **Ubuntu 20.04 / 22.04** (also works on any Linux with bash + curl)
- **curl** — for API calls to ipify.org and ipinfo.io

Both are pre-installed on virtually every Ubuntu system. If missing:

```bash
sudo apt update && sudo apt install curl -y
```

---

## Installation (Ubuntu 20.04 / 22.04)

### Option A — One-liner install

```bash
curl -sL https://raw.githubusercontent.com/Krutik123456/ip-info-linux/main/ip-info.sh -o ~/.ip-info.sh && \
echo '
# Public IP lookup: type "ip" (no args)
[ -f ~/.ip-info.sh ] && . ~/.ip-info.sh' >> ~/.bashrc && \
source ~/.bashrc
```

Option A only downloads one file, so to update later just re-run it.

### Option B — Manual install (from a cloned copy)

```bash
git clone https://github.com/Krutik123456/ip-info-linux.git
cd ip-info-linux
cp ip-info.sh ~/.ip-info.sh
echo '
# Public IP lookup: type "ip" (no args)
[ -f ~/.ip-info.sh ] && . ~/.ip-info.sh' >> ~/.bashrc
source ~/.bashrc
```

### Option C — System-wide install (no .bashrc sourcing)

```bash
sudo install -m 755 ip-info.sh /usr/local/bin/ip-info
echo '
# Public IP lookup
ip() { if [ $# -eq 0 ]; then ip-info; else command ip "$@"; fi; }' >> ~/.bashrc
source ~/.bashrc
```

---

## Usage

| Command | What it does |
|---|---|
| `ip` | Show public IP info (IPv4, IPv6, location, ISP, timezone) |
| `ip addr` | Normal system `ip addr` output |
| `ip link` | Normal system `ip link` output |
| `ip-info` | Same info, as a standalone command (Option C) |

---

## How it works

1. **IPv4** — queried via [api.ipify.org](https://api.ipify.org) (IPv4-only endpoint)
2. **IPv6** — queried via [api6.ipify.org](https://api6.ipify.org) (IPv6-only endpoint)
3. **Geo / ISP / timezone** — queried via [ipinfo.io/json](https://ipinfo.io/json) (uses the requesting IP)

All requests have a 5-second timeout. If a service is unreachable, it shows `<none>` or `?` gracefully.

---

## Files

```
ip-info-linux/
├── ip-info.sh    # The script (source it, or run directly)
└── README.md     # This file
```

---

## Uninstall

- **Option A/B**: remove the added lines at the end of `~/.bashrc` and delete `~/.ip-info.sh`
- **Option C**: `sudo rm /usr/local/bin/ip-info` and remove the `ip()` lines from `~/.bashrc`

---

## License

MIT — do whatever you want.
