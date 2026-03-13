#!/bin/bash

# ==============================================================================
# SCRIPT: powersave.sh
# HARDWARE: HP EliteBook 840 G3 (Intel i5-6300U)
# ==============================================================================

# --- ANSI Color Definitions ---
B='\033[1m'    # Bold
G='\033[0;32m' # Green
C='\033[0;36m' # Cyan
Y='\033[1;33m' # Yellow
R='\033[0;31m' # Red
NC='\033[0m'   # Reset

# --- 1. Documentation ---
show_help() {
    echo -e "${B}${C}>> POWERSAVE UTILITY${NC}"
    echo -e "${B}Usage:${NC} powersave [OPTION]\n"
    echo -e "${B}Options:${NC}"
    echo -e "  ${G}(none)${NC}        Tune hardware (requires sudo)."
    echo -e "  ${G}-s, --status${NC}  Show telemetry only."
    echo -e "  ${G}-h, --help${NC}    Display this help."
}

# --- 2. Input Handling ---
case "$1" in
    -h|--help) show_help; exit 0 ;;
    -s|--status) MODE="STATUS" ;;
    "") MODE="TUNE" ;;
    *) echo -e "${R}Error:${NC} Unknown option '$1'"; show_help; exit 1 ;;
esac

# --- 3. Hardware Optimization ---
if [[ "$MODE" == "TUNE" ]]; then
    if ! command -v powertop &> /dev/null; then
        echo -e "${R}Error:${NC} powertop not found.${NC}"
        exit 1
    fi
    echo -e "${B}status:${NC} tuning hardware... "
    sudo powertop --auto-tune &>/dev/null && echo -e "${G}ok${NC}" || echo -e "${R}fail${NC}"
fi

# --- 4. Data Acquisition ---
BAT="/sys/class/power_supply/BAT0"
C_NOW=$(cat "$BAT/charge_now" 2>/dev/null || echo 0)
C_FULL=$(cat "$BAT/charge_full" 2>/dev/null || echo 1)
C_DESIGN=$(cat "$BAT/charge_full_design" 2>/dev/null || echo 1)
I_NOW=$(cat "$BAT/current_now" 2>/dev/null || echo 0)
V_NOW=$(cat "$BAT/voltage_now" 2>/dev/null || echo 0)
STATUS=$(cat "$BAT/status")
PCT=$(cat "$BAT/capacity")
CYCLES=$(cat "$BAT/cycle_count" 2>/dev/null || echo "N/A")
# Get current system time for the header
NOW_TIME=$(date "+%I:%M %p")

# --- 5. Intelligence Calculations ---

# Draw in Watts: (uA * uV) / 10^12
WATTS=$(awk "BEGIN {printf \"%.2f\", ($I_NOW * $V_NOW) / 1000000000000}")

# Health: (Current Max / Design Max)
HEALTH=$(awk "BEGIN {printf \"%.1f\", ($C_FULL / $C_DESIGN) * 100}")

# Time remaining logic
if [[ "$STATUS" == "Discharging" && "$I_NOW" -gt 0 ]]; then
    TIME_LEFT=$(awk "BEGIN {hrs=$C_NOW/$I_NOW; printf \"%dh %dm\", int(hrs), int((hrs-int(hrs))*60)}")

    # Calculate exact wall-clock time for 0%
    SECONDS_LEFT=$(awk "BEGIN {print int(($C_NOW / $I_NOW) * 3600)}")
    DEADLINE=$(date -d "@$(($(date +%s) + $SECONDS_LEFT))" "+%I:%M %p")

    # Efficiency Score
    if (( $(echo "$WATTS < 6.0" | bc -l) )); then
        SCORE="${G}Excellent (Ultra-Low)${NC}"
    elif (( $(echo "$WATTS < 10.0" | bc -l) )); then
        SCORE="${Y}Good (Standard)${NC}"
    else
        SCORE="${R}High (Heavy Drain)${NC}"
    fi
    DRAW_VAL="${Y}${WATTS} W${NC}"
else
    TIME_LEFT="N/A"
    DEADLINE="External Power"
    SCORE="${C}Plugged In${NC}"
    DRAW_VAL="${G}0.00 W (Bypass)${NC}"
fi

# Progress Bar (20 wide)
BAR_WIDTH=20
FILLED=$(awk "BEGIN {printf \"%.0f\", ($PCT / 100) * $BAR_WIDTH}")
EMPTY=$((BAR_WIDTH - FILLED))
BAR_STR=$(printf "%${FILLED}s" | tr ' ' '#')$(printf "%${EMPTY}s" | tr ' ' '-')

# --- 6. UX Output ---
echo -e "\n${B}${C}>> SYSTEM POWER REPORT [${NOW_TIME}]${NC}"
echo -e "${C}========================================${NC}"
echo -e "${B}STATE      :${NC} $STATUS"
echo -e "${B}CHARGE     :${NC} [${G}${BAR_STR}${NC}] ${PCT}%"
echo -e "${B}EFFICIENCY :${NC} $SCORE"
echo -e "${C}----------------------------------------${NC}"
echo -e "${B}DRAW       :${NC} $DRAW_VAL"
echo -e "${B}REMAINING  :${NC} $TIME_LEFT"
echo -e "${B}EST. EMPTY :${NC} ${Y}${DEADLINE}${NC}"
echo -e "${C}----------------------------------------${NC}"
echo -e "${B}HEALTH     :${NC} ${HEALTH}% capacity (${CYCLES} cycles)"
echo -e "${C}========================================${NC}\n"
