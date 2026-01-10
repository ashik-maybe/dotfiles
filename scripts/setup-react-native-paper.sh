#!/usr/bin/env bash
#
# React Native Paper Setup Script for Expo (using Bun)
#
# This script automates the configuration of React Native Paper in an Expo project.
# It installs required dependencies and configures Babel for production bundle
# size optimization.
#
# Requirements:
#   - Must be run from the root of an Expo project (with package.json)
#   - Requires Bun (https://bun.sh) to be installed and available in PATH
#
# Based on official React Native Paper documentation:
#   https://oss.callstack.com/react-native-paper/docs/guides/getting-started
#
# Created: January 10, 2026
# Author: Ashik
set -e

echo "==> 1. Resetting Project..."
echo "n" | bun run reset-project

echo "==> 2. Installing Paper & Peer Deps..."
bunx expo install react-native-paper react-native-safe-area-context

echo "==> 3. Configuring Babel..."
cat > babel.config.js <<'EOF'
module.exports = function (api) {
  api.cache(true);
  return {
    presets: ['babel-preset-expo'],
    env: { production: { plugins: ['react-native-paper/babel'] } },
  };
};
EOF

echo "==> 4. Wrapping Root Layout (app/_layout.tsx)..."
cat > app/_layout.tsx <<'EOF'
import { Stack } from "expo-router";
import { PaperProvider } from "react-native-paper";

export default function RootLayout() {
  return (
    <PaperProvider>
      <Stack screenOptions={{ headerShown: false }} />
    </PaperProvider>
  );
}
EOF

echo "==> 5. Creating Test UI (app/index.tsx)..."
cat > app/index.tsx <<'EOF'
import { View, StyleSheet } from 'react-native';
import { Button, Text, Card, Avatar } from 'react-native-paper';

export default function Index() {
  return (
    <View style={styles.container}>
      <Card style={styles.card}>
        <Card.Title title="Success!" subtitle="Paper is ready" left={(p) => <Avatar.Icon {...p} icon="check" />} />
        <Card.Content>
          <Text variant="bodyMedium">PaperProvider is active and styling is applied.</Text>
        </Card.Content>
        <Card.Actions>
          <Button mode="contained" onPress={() => alert('It works!')}>Test Interaction</Button>
        </Card.Actions>
      </Card>
    </View>
  );
}
const styles = StyleSheet.create({
  container: { flex: 1, justifyContent: 'center', padding: 20, backgroundColor: '#eee' },
  card: { elevation: 5 }
});
EOF

echo ""
echo "✅ All set! Run: bunx expo start -c"
