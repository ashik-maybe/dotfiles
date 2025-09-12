#!/bin/bash

# Toggle Cloudflare WARP connection

if warp-cli status 2>/dev/null | grep -q "Status update: Connected"; then
    warp-cli disconnect >/dev/null
    echo "🔸 Disconnected from WARP"
else
    warp-cli connect >/dev/null
    echo "🔹 Connected to WARP"
fi
