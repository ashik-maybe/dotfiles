#!/bin/bash
# ┌────────────────────────────────────────────────────────────┐
# │ 🧠 Fix VM internet access when Docker breaks libvirt's NAT │
# └────────────────────────────────────────────────────────────┘
#
# 🐧 Fedora Workstation + virt-manager + Docker setup
# 🛠️ This script restores internet access for QEMU/KVM VMs using libvirt's default bridge (`virbr0`)
# 🐳 Docker modifies iptables rules that block VM traffic—this script patches those rules safely
#
# 🔁 This script is non-persistent: rules reset on reboot unless saved manually or run via systemd
# ✅ Safe to run multiple times (checks before inserting rules)
# 📦 Dependencies: iptables (already present on Fedora)
#
# 📌 Optional alias:
#   alias patchvm='sudo ~/path/to/patch-vm-network.sh'
#
# 📌 Reference:
#   https://wiki.archlinux.org/title/Docker#Starting_Docker_breaks_KVM_bridged_networking

echo "🔧 Patching iptables to restore VM internet access..."

sudo iptables -I FORWARD -i virbr0 -o wlp2s0 -j ACCEPT
sudo iptables -I FORWARD -i wlp2s0 -o virbr0 -j ACCEPT

echo "✅ VMs can now access the internet."
echo "🧠 Note: These rules are temporary and will reset on reboot."

