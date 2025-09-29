#!/bin/bash
#
# warp - Toggle Cloudflare WARP Connection
#
# Usage:
#   warp [OPTIONS]
#
# Options:
#   -h, --help      Show this help
#
# Features:
#   • Toggles WARP connection on/off with one command
#   • Shows clear status: ● Connected / ○ Disconnected
#   • Silent background operation (no CLI spam)
#
# Examples:
#   warp
#   warp --help
#

if [[ "${1:-}" == "--help" ]] || [[ "${1:-}" == "-h" ]]; then
    grep "^# " "${BASH_SOURCE[0]}" | sed 's/^# //'
    exit 0
fi

if ! command -v warp-cli &> /dev/null; then
    echo "❌ Error: 'warp-cli' not found. Install Cloudflare WARP first." >&2
    exit 1
fi

if warp-cli status 2>/dev/null | grep -q "Status update: Connected"; then
    warp-cli disconnect >/dev/null
    echo "○ Disconnected from Cloudflare WARP"
else
    warp-cli connect >/dev/null
    echo "● Connected to Cloudflare WARP"
fi
