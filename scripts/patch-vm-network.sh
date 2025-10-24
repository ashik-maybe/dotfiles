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
# 📌 Usage:
#   chmod +x patch-vm-network.sh
#   sudo ./patch-vm-network.sh
#
# 📌 Optional alias:
#   alias patchvm='sudo ~/path/to/patch-vm-network.sh'
#
# 📌 Reference:
#   https://wiki.archlinux.org/title/Docker#Starting_Docker_breaks_KVM_bridged_networking

# 🧩 Define your bridge and outbound interface
BRIDGE=virbr0      # libvirt's default virtual bridge for VMs
OUT_IF=wlp2s0      # your host's outbound network interface (Wi-Fi in this case)

echo "🔧 Patching iptables to restore VM internet access..."

# 🛡️ Allow traffic from VMs (virbr0) to the internet (wlp2s0)
iptables -C FORWARD -i $BRIDGE -o $OUT_IF -j ACCEPT 2>/dev/null || \
iptables -I FORWARD -i $BRIDGE -o $OUT_IF -j ACCEPT

# 🛡️ Allow return traffic from the internet (wlp2s0) back to VMs (virbr0)
iptables -C FORWARD -i $OUT_IF -o $BRIDGE -j ACCEPT 2>/dev/null || \
iptables -I FORWARD -i $OUT_IF -o $BRIDGE -j ACCEPT

echo "✅ VMs on '$BRIDGE' can now access the internet via '$OUT_IF'"
echo "🧠 Note: These rules are temporary and will reset on reboot."

