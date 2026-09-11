#!/usr/bin/env bash
# ip-info — Show your public IP address, location, ISP, and timezone
# Type 'ip' (no args) for quick lookup, or 'ip-info' directly.
# With any args, falls through to the real system 'ip' command.

_ip_show_my_ip() {
    local v4 v6 info city region country postal org tz
    v4=$(curl -s -4 --max-time 5 https://api.ipify.org 2>/dev/null)
    v6=$(curl -s -6 --max-time 5 https://api6.ipify.org 2>/dev/null)

    # Geolocation from ipinfo.io (uses the requesting IP)
    info=$(curl -s --max-time 5 https://ipinfo.io/json 2>/dev/null)
    if [ -n "$info" ]; then
        city=$(echo "$info"   | grep -o '"city": "[^"]*'    | cut -d'"' -f4)
        region=$(echo "$info" | grep -o '"region": "[^"]*'   | cut -d'"' -f4)
        country=$(echo "$info"| grep -o '"country": "[^"]*'  | cut -d'"' -f4)
        postal=$(echo "$info" | grep -o '"postal": "[^"]*'   | cut -d'"' -f4)
        org=$(echo "$info"    | grep -o '"org": "[^"]*'      | cut -d'"' -f4)
        tz=$(echo "$info"     | grep -o '"timezone": "[^"]*' | cut -d'"' -f4)
    fi

    echo "  Public IPv4 : ${v4:-<none>}"
    echo "  Public IPv6 : ${v6:-<none>}"
    echo "  Location    : ${city:-?}, ${region:-?} ${postal:+($postal)} ${country:+[$country]}"
    echo "  ISP / Org   : ${org:-?}"
    echo "  Timezone    : ${tz:-?}"
}

# If sourced (e.g. from .bashrc): define an "ip" wrapper function instead of
# running immediately, so `. ~/.ip-info.sh` gives you the `ip` command.
if [ "${BASH_SOURCE[0]:-$0}" != "$0" ]; then
    ip() { if [ $# -eq 0 ]; then _ip_show_my_ip; else command ip "$@"; fi; }
    return 0
fi

# If called as "ip" with no args, show public IP info
# Otherwise pass through to the real /sbin/ip
if [ "$(basename "$0")" = "ip" ] && [ $# -eq 0 ]; then
    _ip_show_my_ip
elif [ "$(basename "$0")" = "ip" ]; then
    exec /sbin/ip "$@"
else
    _ip_show_my_ip
fi
