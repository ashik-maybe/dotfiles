#!/usr/bin/env bash
# net-switcher.sh - Toggle networking between Docker and Virt-Manager

set -euo pipefail

# Colors & formatting
CYAN="\033[1;36m"
GREEN="\033[0;32m"
RED="\033[0;31m"
YELLOW="\033[1;33m"
RESET="\033[0m"

print_help() {
    echo -e "${CYAN}=== Docker & Virt-Manager Network Switcher ===${RESET}"
    echo ""
    echo "Usage:"
    echo "  $0 docker       # Enable Docker networking"
    echo "  $0 vm           # Enable Virt-Manager networking"
    echo "  $0 status       # Show current status"
    echo "  $0 -h|--help    # Show this help message"
    echo "  $0               # Launch interactive menu"
    echo ""
    echo "Description:"
    echo "  This script allows you to toggle networking between Docker and Virt-Manager"
    echo "  bridges (docker0 and virbr0). You can enable one at a time to avoid conflicts."
    echo ""
}

show_status() {
    echo -e "${YELLOW}Current bridge status:${RESET}"
    for iface in docker0 virbr0; do
        if ip link show "$iface" &>/dev/null; then
            state=$(ip -o link show "$iface" | awk '{print $9}')
            if [[ "$state" == "UP" ]]; then
                echo -e "  ${GREEN}$iface: UP${RESET}"
            else
                echo -e "  ${RED}$iface: DOWN${RESET}"
            fi
        else
            echo -e "  ${RED}$iface: Not present${RESET}"
        fi
    done
    echo ""
}

enable_docker() {
    echo -e "${CYAN}→ Enabling Docker networking...${RESET}"
    sudo ip link set virbr0 down 2>/dev/null || true
    sudo ip link set docker0 up 2>/dev/null || true
    echo -e "${GREEN}✔ Docker networking enabled.${RESET}"
}

enable_vm() {
    echo -e "${CYAN}→ Enabling Virt-Manager networking...${RESET}"
    sudo ip link set docker0 down 2>/dev/null || true
    sudo ip link set virbr0 up 2>/dev/null || true
    echo -e "${GREEN}✔ Virt-Manager networking enabled.${RESET}"
}

main_menu() {
    echo -e "${CYAN}=== Docker & Virt-Manager Network Switcher ===${RESET}"
    echo "Toggle networking bridges to avoid conflicts."
    echo "Only one bridge (docker0 or virbr0) should be UP at a time."

    while true; do
        echo ""
        echo "Select an option:"
        echo "  1) Enable Docker networking"
        echo "  2) Enable Virt-Manager networking"
        echo "  3) Show current status"
        echo "  4) Help"
        echo "  5) Quit"
        read -rp "Choice [1-5]: " choice
        echo ""

        case "$choice" in
            1) enable_docker ;;
            2) enable_vm ;;
            3) show_status; continue ;;
            4) print_help; continue ;;
            5) echo "Goodbye."; exit 0 ;;
            *) echo -e "${RED}Invalid choice.${RESET}" ;;
        esac

        show_status
    done
}

# -------- ENTRYPOINT --------
if [[ $# -gt 0 ]]; then
    case "$1" in
        docker) enable_docker ;;
        vm) enable_vm ;;
        status) show_status ;;
        -h|--help) print_help ;;
        *) echo -e "${RED}Unknown argument: $1${RESET}"; print_help; exit 1 ;;
    esac
    exit 0
else
    main_menu
fi
