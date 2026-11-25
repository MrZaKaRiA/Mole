#!/usr/bin/env bash
set -euo pipefail

APP_NAME="MoleCompanion"
BUNDLE_ID="fit.mole.Companion"
MIN_SYSTEM_VERSION="14.0"
DMG_NAME="MoleCompanion-arm64.dmg"

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REPO_ROOT="$(cd "$PROJECT_ROOT/../.." && pwd)"
DIST_DIR="$PROJECT_ROOT/dist"
BUILD_DIR="$DIST_DIR/package-arm64"
APP_BUNDLE="$BUILD_DIR/$APP_NAME.app"
APP_CONTENTS="$APP_BUNDLE/Contents"
APP_MACOS="$APP_CONTENTS/MacOS"
APP_RESOURCES="$APP_CONTENTS/Resources"
CLI_RESOURCES="$APP_RESOURCES/MoleCLI"
INFO_PLIST="$APP_CONTENTS/Info.plist"
DMG_ROOT="$DIST_DIR/dmg-root"
DMG_PATH="$DIST_DIR/$DMG_NAME"
APP_ICON="$PROJECT_ROOT/Sources/MoleCompanion/Resources/AppIcon.icns"

echo "Building Mole Go helpers for darwin/arm64..."
cd "$REPO_ROOT"
go mod download
CGO_ENABLED=0 GOOS=darwin GOARCH=arm64 go build -ldflags="-s -w" -o "$DIST_DIR/analyze-go-arm64" ./cmd/analyze
CGO_ENABLED=0 GOOS=darwin GOARCH=arm64 go build -ldflags="-s -w" -o "$DIST_DIR/status-go-arm64" ./cmd/status

echo "Building $APP_NAME release app for Apple Silicon..."
cd "$PROJECT_ROOT"
swift build -c release --arch arm64
BUILD_BINARY="$(swift build -c release --arch arm64 --show-bin-path)/$APP_NAME"

rm -rf "$BUILD_DIR" "$DMG_ROOT" "$DMG_PATH"
mkdir -p "$APP_MACOS" "$CLI_RESOURCES/bin" "$CLI_RESOURCES/lib" "$DMG_ROOT"

cp "$BUILD_BINARY" "$APP_MACOS/$APP_NAME"
chmod +x "$APP_MACOS/$APP_NAME"
if [[ -f "$APP_ICON" ]]; then
  cp "$APP_ICON" "$APP_RESOURCES/AppIcon.icns"
fi

cat >"$INFO_PLIST" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>CFBundleExecutable</key>
  <string>$APP_NAME</string>
  <key>CFBundleIdentifier</key>
  <string>$BUNDLE_ID</string>
  <key>CFBundleName</key>
  <string>Mole</string>
  <key>CFBundleDisplayName</key>
  <string>Mole</string>
  <key>CFBundleIconFile</key>
  <string>AppIcon</string>
  <key>CFBundlePackageType</key>
  <string>APPL</string>
  <key>CFBundleShortVersionString</key>
  <string>0.1.0</string>
  <key>CFBundleVersion</key>
  <string>1</string>
  <key>LSMinimumSystemVersion</key>
  <string>$MIN_SYSTEM_VERSION</string>
  <key>NSPrincipalClass</key>
  <string>NSApplication</string>
  <key>NSQuitAlwaysKeepsWindows</key>
  <false/>
</dict>
</plist>
PLIST

echo "Embedding Mole CLI inside the app bundle..."
cp "$REPO_ROOT/mole" "$CLI_RESOURCES/mole"
chmod +x "$CLI_RESOURCES/mole"
rsync -a --include '*/' --include '*.sh' --exclude '*' "$REPO_ROOT/bin/" "$CLI_RESOURCES/bin/"
cp "$DIST_DIR/analyze-go-arm64" "$CLI_RESOURCES/bin/analyze-go"
cp "$DIST_DIR/status-go-arm64" "$CLI_RESOURCES/bin/status-go"
chmod +x "$CLI_RESOURCES/bin/analyze-go" "$CLI_RESOURCES/bin/status-go"
rsync -a "$REPO_ROOT/lib/" "$CLI_RESOURCES/lib/"

echo "Ad-hoc signing app bundle for local Apple Silicon use..."
/usr/bin/codesign --force --deep --sign - "$APP_BUNDLE"

echo "Creating DMG..."
cp -R "$APP_BUNDLE" "$DMG_ROOT/"
ln -s /Applications "$DMG_ROOT/Applications"
/usr/bin/hdiutil create \
  -volname "Mole" \
  -srcfolder "$DMG_ROOT" \
  -ov \
  -format UDZO \
  "$DMG_PATH"

echo "Validating artifact..."
/usr/bin/codesign --verify --deep --strict "$APP_BUNDLE"
file "$APP_MACOS/$APP_NAME"
file "$CLI_RESOURCES/bin/status-go"

echo
echo "Built: $DMG_PATH"
echo "Install: open the DMG, drag MoleCompanion.app to Applications, then open it."
