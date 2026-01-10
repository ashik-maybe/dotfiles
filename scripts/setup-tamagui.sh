#!/usr/bin/env bash
#
# Tamagui Setup Script for Expo (using Bun)
#
# Automates installation of Tamagui, configuration of the optimizing compiler,
# and setup of the TamaguiProvider with Font support.
#
# Requirements:
#   - Run from the root of an Expo project
#   - Bun installed (https://bun.sh)
#
#   Based on official Tamagui documentation:
#   https://tamagui.dev/docs/guides/expo
#
# Created: January 10, 2026
# Author: Ashik
set -e

echo "==> Tamagui setup for Expo (bun)"

# ---- sanity checks ----
if [ ! -f "package.json" ]; then
  echo "❌ package.json not found."
  exit 1
fi

# ---- 1. reset project ----
echo "==> 1. Resetting project..."
echo "n" | bun run reset-project

# ---- 2. install deps ----
echo "==> 2. Installing Tamagui & Peer Deps..."
# core, compiler, config, and fonts
bun add tamagui @tamagui/config @tamagui/babel-plugin @tamagui/font-inter expo-font react-native-reanimated react-native-worklets

# ---- 3. babel config ----
echo "==> 3. Writing babel.config.js (Enabling Optimizing Compiler)..."
cat > babel.config.js <<'EOF'
module.exports = function (api) {
  api.cache(true)
  return {
    presets: ['babel-preset-expo'],
    plugins: [
      [
        '@tamagui/babel-plugin',
        {
          components: ['tamagui'],
          config: './tamagui.config.ts',
          logTimings: true,
          disableExtraction: process.env.NODE_ENV === 'development',
        },
      ],
      'react-native-reanimated/plugin',
    ],
  }
}
EOF

# ---- 4. tamagui config ----
echo "==> 4. Creating tamagui.config.ts..."
cat > tamagui.config.ts <<'EOF'
import { defaultConfig } from '@tamagui/config/v4'
import { createTamagui } from 'tamagui'

export const tamaguiConfig = createTamagui(defaultConfig)

export default tamaguiConfig

export type Conf = typeof tamaguiConfig

declare module 'tamagui' {
  interface TamaguiCustomConfig extends Conf {}
}
EOF

# ---- 5. wrap root layout ----
echo "==> 5. Updating app/_layout.tsx (Provider & Font Loading)..."
cat > app/_layout.tsx <<'EOF'
import { useEffect } from 'react'
import { useColorScheme } from 'react-native'
import { DarkTheme, DefaultTheme, ThemeProvider } from '@react-navigation/native'
import { Stack } from 'expo-router'
import { TamaguiProvider } from 'tamagui'
import { useFonts } from 'expo-font'
import * as SplashScreen from 'expo-splash-screen'

import { tamaguiConfig } from '../tamagui.config'

SplashScreen.preventAutoHideAsync()

export default function RootLayout() {
  const colorScheme = useColorScheme()

  const [interLoaded, interError] = useFonts({
    Inter: require('@tamagui/font-inter/otf/Inter-Medium.otf'),
    InterBold: require('@tamagui/font-inter/otf/Inter-Bold.otf'),
  })

  useEffect(() => {
    if (interLoaded || interError) {
      SplashScreen.hideAsync()
    }
  }, [interLoaded, interError])

  if (!interLoaded && !interError) {
    return null
  }

  return (
    <TamaguiProvider config={tamaguiConfig} defaultTheme={colorScheme!}>
      <ThemeProvider value={colorScheme === 'dark' ? DarkTheme : DefaultTheme}>
        <Stack>
          <Stack.Screen name="index" options={{ title: 'Tamagui Home' }} />
        </Stack>
      </ThemeProvider>
    </TamaguiProvider>
  )
}
EOF

# ---- 6. sample ui ----
echo "==> 6. Creating app/index.tsx (Testing Components)..."
cat > app/index.tsx <<'EOF'
import { YStack, Text, Button, XStack, H1, Card, Linking } from 'tamagui'

export default function Index() {
  return (
    <YStack f={1} jc="center" ai="center" p="$4" space="$4" bg="$background">
      <Card elevate p="$4" bordered animation="lazy" scale={0.9} hoverStyle={{ scale: 0.92 }}>
        <YStack space="$2">
          <H1 textAlign="center">Tamagui 🚀</H1>
          <Text textAlign="center" theme="alt1">Performance-first UI for Expo</Text>

          <XStack space="$2" jc="center" mt="$4">
            <Button themeInverse onPress={() => alert('Tamagui is live!')}>
              Test Button
            </Button>
          </XStack>
        </YStack>
      </Card>
    </YStack>
  )
}
EOF

echo ""
echo "✅ Tamagui setup complete with optimizing compiler!"
echo "🚀 Start with cache clear: bunx expo start -c"
