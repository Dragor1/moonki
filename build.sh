#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")"
SDK="$(xcrun --sdk iphoneos --show-sdk-path)"
OUT="$PWD/output"
APP="$OUT/Payload/MoonlightWeb.app"
rm -rf "$OUT"
mkdir -p "$APP"
xcrun --sdk iphoneos clang -target arm64-apple-ios16.0 -isysroot "$SDK" \
  -fobjc-arc -fblocks -O2 -framework UIKit -framework Foundation -framework WebKit \
  MoonlightWeb.m -o "$APP/MoonlightWeb"
cp Info.plist AppIcon*.png "$APP/"
/usr/libexec/PlistBuddy -c "Add :DTPlatformName string iphoneos" "$APP/Info.plist"
/usr/libexec/PlistBuddy -c "Add :DTSDKName string iphoneos$(xcrun --sdk iphoneos --show-sdk-version)" "$APP/Info.plist"
/usr/bin/codesign --force --sign - "$APP"
(cd "$OUT" && /usr/bin/zip -q -r MoonlightWeb.ipa Payload)
/usr/bin/file "$APP/MoonlightWeb"
/usr/bin/unzip -t "$OUT/MoonlightWeb.ipa"
echo "IPA: $OUT/MoonlightWeb.ipa (re-sign with your sideloader)"
