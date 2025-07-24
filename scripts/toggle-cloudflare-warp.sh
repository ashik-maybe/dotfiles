#!/usr/bin/env bash
# toggle-cloudflare-warp.sh — Toggle Cloudflare WARP connection

set -euo pipefail

# ────── Terminal Colors ──────
RED="\033[0;31m"
GREEN="\033[0;32m"
BLUE="\033[0;34m"
YELLOW="\033[0;33m"
RESET="\033[0m"

# ────── Dependencies Check ──────
if ! command -v warp-cli &>/dev/null; then
  echo -e "${RED}Error:${RESET} warp-cli is not installed or not in PATH."
  exit 1
fi

# ────── Get WARP Status ──────
status_output=$(warp-cli status 2>/dev/null)
warp_status=$(echo "$status_output" | grep 'Status update' | awk -F': ' '{print $2}' | tr -d '\r')

# ────── Toggle Logic ──────
if [[ "$warp_status" == "Connected" ]]; then
  echo -e "${BLUE}Disconnecting Cloudflare WARP...${RESET}"
  if warp-cli disconnect &>/dev/null; then
    echo -e "${GREEN}✓ Disconnected.${RESET}"
    exit 0
  else
    echo -e "${RED}✗ Failed to disconnect WARP.${RESET}"
    exit 1
  fi
else
  echo -e "${BLUE}Connecting Cloudflare WARP...${RESET}"
  if warp-cli connect &>/dev/null; then
    echo -e "${GREEN}✓ Connected.${RESET}"
    exit 0
  else
    echo -e "${RED}✗ Failed to connect WARP.${RESET}"
    exit 1
  fi
fi
