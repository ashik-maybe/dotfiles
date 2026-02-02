#!/bin/bash

set -euo pipefail

APP_DIR="$HOME/.local/share/applications"
ICON_DIR="$HOME/.local/share/icons/webapps"
mkdir -p "$APP_DIR" "$ICON_DIR"

show_usage() {
    echo "Usage:"
    echo "  $0                    → Create web app (Chrome)"
    echo "  $0 -f|--firefox       → Create with Firefox"
    echo "  $0 -b|--brave         → Create with Brave"
    echo "  $0 -r|--remove        → Remove an existing web app"
    exit 1
}

# Parse mode
MODE="chrome"
REMOVE=false

while [[ $# -gt 0 ]]; do
    case "$1" in
        -f|--firefox) MODE="firefox"; shift ;;
        -b|--brave)   MODE="brave"; shift ;;
        -r|--remove)  REMOVE=true; shift ;;
        *) show_usage ;;
    esac
done

# ===== REMOVE MODE =====
if [[ "$REMOVE" == true ]]; then
    mapfile -t desktop_files < <(find "$APP_DIR" -maxdepth 1 -name "*.desktop" -exec grep -l "Comment=Web app for" {} \; 2>/dev/null || true)

    if [[ ${#desktop_files[@]} -eq 0 ]]; then
        echo "No web apps found."
        exit 0
    fi

    declare -a names
    for f in "${desktop_files[@]}"; do
        name=$(grep "^Name=" "$f" | cut -d'=' -f2)
        names+=("$name")
    done

    echo "Select a web app to remove:"
    select choice in "${names[@]}" "Cancel"; do
        [[ "$choice" == "Cancel" ]] && { echo "Aborted."; exit 0; }
        [[ -z "$choice" ]] && { echo "Invalid. Try again."; continue; }

        for i in "${!names[@]}"; do
            if [[ "${names[i]}" == "$choice" ]]; then
                target_desktop="${desktop_files[i]}"
                break
            fi
        done

        if [[ -f "$target_desktop" ]]; then
            icon_line=$(grep "^Icon=" "$target_desktop")
            if [[ "$icon_line" == Icon=$ICON_DIR/* ]]; then
                icon_path="${icon_line#Icon=}"
                [[ -f "$icon_path" ]] && { echo "Deleting icon: $icon_path"; rm -f "$icon_path"; }
            fi
            echo "Deleting: $target_desktop"
            rm -f "$target_desktop"
        fi
        echo "✅ Removed '$choice'"
        update-desktop-database "$APP_DIR" >/dev/null 2>&1 || true
        exit 0
    done
fi

# ===== CREATE MODE =====
read -rp "Enter the full URL (e.g., https://calendar.google.com): " url
[[ "$url" =~ ^https?:// ]] || { echo "Error: Invalid URL"; exit 1; }

# Suggest name from domain
domain="${url#https://}"; domain="${domain#http://}"; domain="${domain%%/*}"
wm_class="$domain" # Used for StartupWMClass
parts=()
IFS='.' read -ra segs <<< "$domain"
for seg in "${segs[@]}"; do
    [[ -n "$seg" && "$seg" != "www" && "$seg" != "app" && "$seg" != "mail" && "$seg" != "com" && "$seg" != "net" && "$seg" != "org" && "$seg" != "io" && "$seg" != "dev" ]] && parts+=("$seg")
done

if [[ ${#parts[@]} -eq 0 ]]; then
    suggested="Web App"
else
    name_parts=()
    for ((i=${#parts[@]}-1; i>=0; i--)); do
        word="${parts[i]}"
        cap="$(tr '[:lower:]' '[:upper:]' <<< "${word:0:1}")${word:1}"
        name_parts+=("$cap")
    done
    suggested="${name_parts[*]}"
fi

read -rp "Suggested name: '$suggested'. Press Enter or type a new name: " app_name
app_name="${app_name:-$suggested}"

# === AUTO-ICON FETCH FROM dashboardicons.com ===
icon_path=""
service_name=""

if [[ ${#parts[@]} -gt 0 ]]; then
    reversed=()
    for ((i=${#parts[@]}-1; i>=0; i--)); do
        reversed+=("${parts[i]}")
    done
    service_name=$(IFS=-; echo "${reversed[*]}" | tr '[:upper:]' '[:lower:]')
fi

# Fallback to a meaningful segment if needed
if [[ -z "$service_name" ]]; then
    for seg in "${segs[@]}"; do
        if [[ "$seg" != "www" && "$seg" != "app" && "$seg" != "mail" && "$seg" != "com" && "$seg" != "net" && "$seg" != "org" && "$seg" != "io" && "$seg" != "dev" ]]; then
            service_name="$seg"
            break
        fi
    done
fi

service_name="${service_name:-web-app}"
auto_icon_url="https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/svg/${service_name}.svg"

echo "🔍 Trying to auto-fetch icon for '$service_name' from dashboardicons.com..."
if curl -sL -f -o "/tmp/${service_name}.svg" "$auto_icon_url" 2>/dev/null; then
    icon_file_safe=$(echo "$app_name" | tr ' /' '__' | tr -cd '[:alnum:]_.-')
    icon_path="$ICON_DIR/${icon_file_safe}.svg"
    mv "/tmp/${service_name}.svg" "$icon_path"
    echo "✓ Auto-icon downloaded: $service_name"
else
    echo "⚠️  No icon found for '$service_name'."
    echo "Tip: Browse icons at https://dashboardicons.com/"
    read -rp "Enter custom icon URL (or press Enter to skip): " manual_icon_url
    if [[ -n "$manual_icon_url" ]]; then
        icon_file_safe=$(echo "$app_name" | tr ' /' '__' | tr -cd '[:alnum:]_.-')
        ext="${manual_icon_url##*.}"
        [[ "$ext" =~ ^(png|svg|jpg|jpeg|ico)$ ]] || ext="png"
        icon_path="$ICON_DIR/${icon_file_safe}.${ext}"
        if curl -sL -f -o "$icon_path" "$manual_icon_url"; then
            echo "✓ Custom icon saved"
        else
            echo "⚠️  Failed to download custom icon. Using default."
            icon_path=""
        fi
    fi
fi

# Finalize paths
desktop_safe=$(echo "$app_name" | tr ' /' '__' | tr -cd '[:alnum:]_.-')
desktop_file="$APP_DIR/${desktop_safe}.desktop"

# Browser-specific command
case "$MODE" in
    chrome)
        exec_cmd="google-chrome --app=$url --disable-extensions --no-default-browser-check --disable-infobars"
        default_icon="google-chrome"
        ;;
    brave)
        exec_cmd="brave-browser --app=$url --disable-extensions --no-default-browser-check --disable-infobars"
        default_icon="brave-browser"
        ;;
    firefox)
        exec_cmd="firefox --ssb=$url"
        default_icon="firefox"
        ;;
esac

# Write .desktop file
cat > "$desktop_file" <<EOF
[Desktop Entry]
Version=1.0
Name=$app_name
Comment=Web app for $url (via $(echo $MODE | tr '[:lower:]' '[:upper:]' | cut -c1)${MODE:1})
Exec=$exec_cmd
Terminal=false
Type=Application
Categories=Network;WebBrowser;
StartupNotify=true
StartupWMClass=$wm_class
Icon=${icon_path:-$default_icon}
EOF

chmod +x "$desktop_file"

echo
echo "✅ Created: $app_name (browser: $MODE)"
echo "   Desktop: $desktop_file"
if [[ -n "${icon_path:-}" ]]; then
    echo "   Icon: $icon_path"
else
    echo "   Icon: Default ($default_icon)"
fi
echo
echo "💡 Run this if the app doesn't appear in your launcher:"
echo "   update-desktop-database ~/.local/share/applications"
