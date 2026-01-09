#!/usr/bin/env bash
#
# Nativewind + Tailwind CSS Setup Script for Expo (using Bun)
#
# This script automates the configuration of Nativewind with Tailwind CSS in a fresh or existing Expo project.
# It installs required dependencies, initializes Tailwind, configures Babel, Metro, and app entry points,
# and ensures compatibility with both TypeScript and JavaScript projects.
#
# Requirements:
#   - {bun create expo-app}
#   - Must be run from the root of an Expo project (with package.json)
#   - Requires Bun (https://bun.sh) to be installed and available in PATH
#
# Based on official Nativewind documentation:
#   https://www.nativewind.dev/docs/getting-started/installation
#
# Created: January 09, 2026
# Author: Ashik

set -e

echo "==> Nativewind + Tailwind setup for Expo (bun)"

# ---- sanity checks ----
if [ ! -f "package.json" ]; then
  echo "❌ package.json not found. Run this inside your Expo project root."
  exit 1
fi

if ! command -v bun >/dev/null 2>&1; then
  echo "❌ bun not found in PATH."
  exit 1
fi

# ---- install deps ----
echo "==> Installing dependencies..."

bunx expo install nativewind react-native-reanimated react-native-worklets react-native-safe-area-context
bunx expo install --dev tailwindcss@^3.4.17 prettier-plugin-tailwindcss@^0.5.11

# ---- init tailwind ----
if [ ! -f "tailwind.config.js" ]; then
  echo "==> Initializing tailwind..."
  bunx tailwindcss init
fi

# ---- write tailwind config ----
echo "==> Writing tailwind.config.js..."

cat > tailwind.config.js <<'EOF'
/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ["./app/**/*.{js,jsx,ts,tsx}", "./components/**/*.{js,jsx,ts,tsx}"],
  presets: [require("nativewind/preset")],
  theme: {
    extend: {},
  },
  plugins: [],
}
EOF

# ---- create global.css ----
if [ ! -f "global.css" ]; then
  echo "==> Creating global.css..."
  cat > global.css <<'EOF'
@tailwind base;
@tailwind components;
@tailwind utilities;
EOF
fi

# ---- babel config ----
echo "==> Writing babel.config.js..."

cat > babel.config.js <<'EOF'
module.exports = function (api) {
  api.cache(true);
  return {
    presets: [
      ["babel-preset-expo", { jsxImportSource: "nativewind" }],
      "nativewind/babel",
    ],
  };
};
EOF

# ---- metro config ----
echo "==> Writing metro.config.js..."

cat > metro.config.js <<'EOF'
const { getDefaultConfig } = require("expo/metro-config");
const { withNativeWind } = require("nativewind/metro");

const config = getDefaultConfig(__dirname);

module.exports = withNativeWind(config, { input: "./global.css" });
EOF

# ---- patch app.json ----
if [ -f "app.json" ]; then
  echo "==> Patching app.json to force metro bundler..."

  node <<'EOF'
const fs = require("fs");

const path = "app.json";
const json = JSON.parse(fs.readFileSync(path, "utf8"));

json.expo ??= {};
json.expo.web ??= {};
json.expo.web.bundler = "metro";

fs.writeFileSync(path, JSON.stringify(json, null, 2));
EOF
else
  echo "⚠️ app.json not found, skipping bundler config"
fi

# ---- ensure app/_layout.tsx imports global.css ----
if [ -f "app/_layout.tsx" ]; then
  if ! grep -q 'global.css' app/_layout.tsx; then
    echo "==> Patching app/_layout.tsx to import global.css..."
    # Insert at line 1
    sed -i '1i import "../global.css";' app/_layout.tsx
  fi
elif [ -f "app/_layout.js" ]; then
  if ! grep -q 'global.css' app/_layout.js; then
    echo "==> Patching app/_layout.js to import global.css..."
    sed -i '1i import "../global.css";' app/_layout.js
  fi
else
  echo "⚠️ app/_layout not found. Ensure you are in an Expo Router project."
fi

# ---- typescript types (optional) ----
if [ -f "tsconfig.json" ]; then
  if [ ! -f "nativewind-env.d.ts" ]; then
    echo "==> Creating nativewind-env.d.ts..."
    cat > nativewind-env.d.ts <<'EOF'
/// <reference types="nativewind/types" />
EOF
  fi
fi

echo ""
echo "✅ Nativewind setup complete."
echo ""
echo "Next steps:"
echo "  1. Restart Expo: bunx expo start -c"
echo "  2. Use className in React Native components."
echo ""
