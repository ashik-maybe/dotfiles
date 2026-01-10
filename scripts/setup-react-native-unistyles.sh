#!/usr/bin/env bash
#
# Unistyles 3.0 Setup Script for Expo (using Bun)
#
# This script automates the configuration of Unistyles 3.0 in an Expo project.
# It handles project reset, native dependencies, entry point redirection,
# and Babel plugin configuration.
#
# Requirements:
#   - Must be run from the root of an Expo project
#   - Requires Bun (https://bun.sh)
#   - React Native 0.78.0+ (New Architecture enabled)
#   - Xcode 16+ (for iOS)
#
# Based on official Unistyles 3.0 documentation:
#   https://www.unistyl.es/v3/start/getting-started
#
# Created: January 10, 2026
# Author: Ashik
set -e

echo "==> Unistyles 3.0 setup for Expo (bun)"

# ---- sanity checks ----
if [ ! -f "package.json" ]; then
  echo "❌ package.json not found."
  exit 1
fi

# ---- 1. reset project ----
echo "==> Resetting project..."
echo "n" | bun run reset-project

# ---- 2. install deps ----
echo "==> Installing Unistyles 3.0 & Peer Deps..."
# Fixed version of nitro-modules is recommended by Unistyles docs
bun add react-native-unistyles react-native-nitro-modules@0.20.0 react-native-edge-to-edge

# ---- 3. babel config ----
echo "==> Writing babel.config.js..."
cat > babel.config.js <<'EOF'
module.exports = function (api) {
  api.cache(true);
  return {
    presets: ['babel-preset-expo'],
    plugins: [
      ['react-native-unistyles/plugin', { root: 'app' }]
    ],
  };
};
EOF

# ---- 4. entry point redirection ----
echo "==> Configuring main entry point..."
# Modify package.json to use index.ts instead of expo-router/entry
sed -i 's/"main": "expo-router\/entry"/"main": "index.ts"/' package.json

cat > index.ts <<'EOF'
import 'expo-router/entry';
import './unistyles';
EOF

cat > unistyles.ts <<'EOF'
import { UnistylesRegistry } from 'react-native-unistyles'

if (UnistylesRegistry) {
  UnistylesRegistry.addBreakpoints({
      xs: 0,
      sm: 576,
      md: 768,
      lg: 992
  });
}
EOF

# ---- 5. web support ----
echo "==> Adding Web Static Support (+html.tsx)..."
cat > app/+html.tsx <<'EOF'
import React from 'react'
import { ScrollViewStyleReset } from 'expo-router/html'
import { type PropsWithChildren } from 'react'
import '../unistyles'

export default function Root({ children }: PropsWithChildren) {
  return (
    <html lang="en">
      <head>
        <meta charSet="utf-8" />
        <meta httpEquiv="X-UA-Compatible" content="IE=edge" />
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
        <ScrollViewStyleReset />
      </head>
      <body>{children}</body>
    </html>
  )
}
EOF

# ---- 6. sample ui ----
echo "==> Creating app/index.tsx..."
cat > app/index.tsx <<'EOF'
import { View, Text } from 'react-native';
import { StyleSheet } from 'react-native-unistyles';

export default function Index() {
  return (
    <View style={styles.container}>
      <Text style={styles.text}>Unistyles 3.0: Ready 🦸‍♂️</Text>
      <View style={styles.box}>
        <Text style={styles.boxText}>Breakpoint Responsive Box</Text>
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#fff'
  },
  text: {
    fontSize: 24,
    fontWeight: 'bold',
    marginBottom: 20
  },
  box: {
    padding: 20,
    borderRadius: 12,
    width: {
      xs: '80%',
      md: '50%'
    },
    backgroundColor: {
      xs: '#ff4757',
      sm: '#2ed573',
      md: '#1e90ff'
    }
  },
  boxText: {
    color: 'white',
    textAlign: 'center'
  }
});
EOF

echo ""
echo "   All set! Run:"
echo "🚀 Web:     bun expo start --web"
echo "🚀 Mobile:  bun expo prebuild && bun expo run:ios # or android"
