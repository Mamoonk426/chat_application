#!/bin/bash
# ============================================================================
# Release Build Script — Optimized for size
# ============================================================================
# Usage: ./build_release.sh [apk|appbundle]
# ============================================================================

set -e

BUILD_TYPE="${1:-apk}"

echo "🧹 Cleaning previous build..."
flutter clean
flutter pub get

echo "🔨 Building release $BUILD_TYPE with size optimizations..."

if [ "$BUILD_TYPE" = "appbundle" ]; then
  flutter build appbundle \
    --release \
    --tree-shake-icons \
    --obfuscate \
    --split-debug-info=build/debug-info
  echo "✅ App Bundle built: build/app/outputs/bundle/release/"
else
  flutter build apk \
    --release \
    --tree-shake-icons \
    --obfuscate \
    --split-debug-info=build/debug-info \
    --split-per-abi
  echo "✅ APKs built:"
  ls -lh build/app/outputs/flutter-apk/app-*-release.apk 2>/dev/null || echo "  Check build/app/outputs/flutter-apk/"
fi

echo ""
echo "📦 Debug symbols saved to: build/debug-info/"
echo "   (Keep these for crash report symbolication)"
