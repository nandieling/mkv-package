#!/bin/bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
APP_NAME="${APP_NAME:-MKV Package}"
BUNDLE_ID="${BUNDLE_ID:-com.local.mkv-package}"
VERSION="${VERSION:-1.0.0}"
MIN_MACOS_VERSION="${MIN_MACOS_VERSION:-14.0}"
BUILD_DIR="$ROOT_DIR/.build/package"
DIST_DIR="$ROOT_DIR/dist"
APP_DIR="$DIST_DIR/$APP_NAME.app"
CONTENTS_DIR="$APP_DIR/Contents"
MACOS_DIR="$CONTENTS_DIR/MacOS"
RESOURCES_DIR="$CONTENTS_DIR/Resources"
APP_EXECUTABLE="$MACOS_DIR/mkv-package"
ICON_SOURCE="$ROOT_DIR/01.png"
MKVMERGE_SOURCE="$ROOT_DIR/mkvmerge_portable/mkvmerge"
MEDIAINFO_SOURCE="$ROOT_DIR/mediainfo_portable/mediainfo"

require_file() {
    if [[ ! -f "$1" ]]; then
        echo "缺少文件：$1" >&2
        exit 1
    fi
}

require_command() {
    if ! command -v "$1" >/dev/null 2>&1; then
        echo "缺少命令：$1" >&2
        exit 1
    fi
}

require_file "$ROOT_DIR/ContentView.swift"
require_file "$ICON_SOURCE"
require_file "$MKVMERGE_SOURCE"
require_file "$MEDIAINFO_SOURCE"
require_command xcrun
require_command sips
require_command otool
require_command install_name_tool
require_command codesign
require_command ditto

rm -rf "$BUILD_DIR" "$APP_DIR" "$DIST_DIR/$APP_NAME.zip"
mkdir -p "$BUILD_DIR" "$MACOS_DIR" "$RESOURCES_DIR"

echo "[1/7] 使用 01.png 生成 AppIcon.icns"
ASSET_CATALOG_DIR="$BUILD_DIR/Assets.xcassets"
ICONSET_DIR="$ASSET_CATALOG_DIR/AppIcon.appiconset"
mkdir -p "$ICONSET_DIR"
sips -z 16 16 "$ICON_SOURCE" --out "$ICONSET_DIR/icon_16x16.png" >/dev/null
sips -z 32 32 "$ICON_SOURCE" --out "$ICONSET_DIR/icon_16x16@2x.png" >/dev/null
sips -z 32 32 "$ICON_SOURCE" --out "$ICONSET_DIR/icon_32x32.png" >/dev/null
sips -z 64 64 "$ICON_SOURCE" --out "$ICONSET_DIR/icon_32x32@2x.png" >/dev/null
sips -z 128 128 "$ICON_SOURCE" --out "$ICONSET_DIR/icon_128x128.png" >/dev/null
sips -z 256 256 "$ICON_SOURCE" --out "$ICONSET_DIR/icon_128x128@2x.png" >/dev/null
sips -z 256 256 "$ICON_SOURCE" --out "$ICONSET_DIR/icon_256x256.png" >/dev/null
sips -z 512 512 "$ICON_SOURCE" --out "$ICONSET_DIR/icon_256x256@2x.png" >/dev/null
sips -z 512 512 "$ICON_SOURCE" --out "$ICONSET_DIR/icon_512x512.png" >/dev/null
sips -z 1024 1024 "$ICON_SOURCE" --out "$ICONSET_DIR/icon_512x512@2x.png" >/dev/null
cat > "$ICONSET_DIR/Contents.json" <<'JSON'
{
  "images" : [
    { "filename" : "icon_16x16.png",      "idiom" : "mac", "scale" : "1x", "size" : "16x16" },
    { "filename" : "icon_16x16@2x.png",   "idiom" : "mac", "scale" : "2x", "size" : "16x16" },
    { "filename" : "icon_32x32.png",      "idiom" : "mac", "scale" : "1x", "size" : "32x32" },
    { "filename" : "icon_32x32@2x.png",   "idiom" : "mac", "scale" : "2x", "size" : "32x32" },
    { "filename" : "icon_128x128.png",    "idiom" : "mac", "scale" : "1x", "size" : "128x128" },
    { "filename" : "icon_128x128@2x.png", "idiom" : "mac", "scale" : "2x", "size" : "128x128" },
    { "filename" : "icon_256x256.png",    "idiom" : "mac", "scale" : "1x", "size" : "256x256" },
    { "filename" : "icon_256x256@2x.png", "idiom" : "mac", "scale" : "2x", "size" : "256x256" },
    { "filename" : "icon_512x512.png",    "idiom" : "mac", "scale" : "1x", "size" : "512x512" },
    { "filename" : "icon_512x512@2x.png", "idiom" : "mac", "scale" : "2x", "size" : "512x512" }
  ],
  "info" : { "author" : "xcode", "version" : 1 }
}
JSON

xcrun actool \
    --compile "$RESOURCES_DIR" \
    --platform macosx \
    --minimum-deployment-target "$MIN_MACOS_VERSION" \
    --app-icon AppIcon \
    --output-partial-info-plist "$BUILD_DIR/AssetInfo.plist" \
    "$ASSET_CATALOG_DIR" >/dev/null

echo "[2/7] 编译 SwiftUI 原生应用"
ENTRY_FILE="$BUILD_DIR/MKVPackageApp.swift"
cat > "$ENTRY_FILE" <<'SWIFT'
import SwiftUI

@main
struct MKVPackageApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
SWIFT

SDK_PATH="$(xcrun --sdk macosx --show-sdk-path)"
HOST_ARCH="$(uname -m)"
if ! lipo -verify_arch "$HOST_ARCH" "$MKVMERGE_SOURCE" >/dev/null 2>&1; then
    HOST_ARCH="$(lipo -archs "$MKVMERGE_SOURCE" | awk '{print $1}')"
fi

export CLANG_MODULE_CACHE_PATH="$BUILD_DIR/ClangModuleCache"
export SWIFT_MODULE_CACHE_PATH="$BUILD_DIR/SwiftModuleCache"
mkdir -p "$CLANG_MODULE_CACHE_PATH" "$SWIFT_MODULE_CACHE_PATH"

xcrun --sdk macosx swiftc \
    -O \
    -whole-module-optimization \
    -module-cache-path "$SWIFT_MODULE_CACHE_PATH" \
    -parse-as-library \
    -sdk "$SDK_PATH" \
    -target "$HOST_ARCH-apple-macos$MIN_MACOS_VERSION" \
    "$ROOT_DIR/ContentView.swift" \
    "$ENTRY_FILE" \
    -o "$APP_EXECUTABLE"

echo "[3/7] 写入 App 元数据"
cat > "$CONTENTS_DIR/Info.plist" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleDevelopmentRegion</key>
    <string>zh_CN</string>
    <key>CFBundleDisplayName</key>
    <string>$APP_NAME</string>
    <key>CFBundleExecutable</key>
    <string>mkv-package</string>
    <key>CFBundleIconFile</key>
    <string>AppIcon</string>
    <key>CFBundleIdentifier</key>
    <string>$BUNDLE_ID</string>
    <key>CFBundleInfoDictionaryVersion</key>
    <string>6.0</string>
    <key>CFBundleName</key>
    <string>$APP_NAME</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleShortVersionString</key>
    <string>$VERSION</string>
    <key>CFBundleVersion</key>
    <string>$VERSION</string>
    <key>LSApplicationCategoryType</key>
    <string>public.app-category.video</string>
    <key>LSMinimumSystemVersion</key>
    <string>$MIN_MACOS_VERSION</string>
    <key>NSHighResolutionCapable</key>
    <true/>
</dict>
</plist>
PLIST

echo "[4/7] 内置 mkvmerge 与 MediaInfo"
ditto "$ROOT_DIR/mkvmerge_portable" "$RESOURCES_DIR/mkvmerge_portable"
ditto "$ROOT_DIR/mediainfo_portable" "$RESOURCES_DIR/mediainfo_portable"
chmod +x "$RESOURCES_DIR/mkvmerge_portable/mkvmerge"
chmod +x "$RESOURCES_DIR/mediainfo_portable/mediainfo"

# 将 mkvmerge 依赖的 Homebrew 动态库递归复制进 App，并改写为 App 内相对路径。
MKV_TOOL_DIR="$RESOURCES_DIR/mkvmerge_portable"
MKV_LIB_DIR="$MKV_TOOL_DIR/libs"
mkdir -p "$MKV_LIB_DIR"

SOURCE_BINARIES=("$MKVMERGE_SOURCE")
STAGED_BINARIES=("$MKV_TOOL_DIR/mkvmerge")
for source_library in "$ROOT_DIR"/mkvmerge_portable/libs/*; do
    if [[ -f "$source_library" ]]; then
        SOURCE_BINARIES+=("$source_library")
        STAGED_BINARIES+=("$MKV_LIB_DIR/$(basename "$source_library")")
    fi
done

is_staged() {
    local candidate="$1"
    local existing
    for existing in "${STAGED_BINARIES[@]}"; do
        if [[ "$existing" == "$candidate" ]]; then
            return 0
        fi
    done
    return 1
}

queue_dependency() {
    local source_path="$1"
    local staged_path="$MKV_LIB_DIR/$(basename "$source_path")"
    if is_staged "$staged_path"; then
        return
    fi
    cp -L "$source_path" "$staged_path"
    chmod +x "$staged_path"
    SOURCE_BINARIES+=("$(realpath "$source_path")")
    STAGED_BINARIES+=("$staged_path")
}

index=0
while [[ $index -lt ${#SOURCE_BINARIES[@]} ]]; do
    source_binary="${SOURCE_BINARIES[$index]}"
    while IFS= read -r dependency; do
        [[ -z "$dependency" ]] && continue
        case "$dependency" in
            /System/*|/usr/lib/*)
                continue
                ;;
            @executable_path/libs/*)
                continue
                ;;
            @loader_path/*)
                resolved_dependency="$(dirname "$source_binary")/${dependency#@loader_path/}"
                ;;
            @rpath/*)
                dependency_name="$(basename "$dependency")"
                resolved_dependency="$(find /opt/homebrew /usr/local -type f -name "$dependency_name" -print -quit 2>/dev/null || true)"
                ;;
            /*)
                resolved_dependency="$dependency"
                ;;
            *)
                continue
                ;;
        esac

        if [[ -n "${resolved_dependency:-}" && -f "$resolved_dependency" ]]; then
            queue_dependency "$resolved_dependency"
        elif [[ "$dependency" != @loader_path/* ]]; then
            echo "无法找到 mkvmerge 依赖：$dependency" >&2
            exit 1
        fi
    done < <(otool -L "$source_binary" | awk 'NR > 1 { print $1 }')
    index=$((index + 1))
done

for staged_binary in "${STAGED_BINARIES[@]}"; do
    while IFS= read -r dependency; do
        case "$dependency" in
            /System/*|/usr/lib/*|@executable_path/libs/*|@loader_path/*)
                continue
                ;;
            /opt/homebrew/*|/usr/local/*|@rpath/*)
                install_name_tool -change "$dependency" "@executable_path/libs/$(basename "$dependency")" "$staged_binary"
                ;;
        esac
    done < <(otool -L "$staged_binary" | awk 'NR > 1 { print $1 }')

    if [[ "$staged_binary" != "$MKV_TOOL_DIR/mkvmerge" ]]; then
        current_id="$(otool -D "$staged_binary" 2>/dev/null | tail -n 1 || true)"
        case "$current_id" in
            /opt/homebrew/*|/usr/local/*)
                install_name_tool -id "@executable_path/libs/$(basename "$staged_binary")" "$staged_binary"
                ;;
        esac
    fi
done

echo "[5/7] 检查便携依赖"
for staged_binary in "${STAGED_BINARIES[@]}"; do
    if otool -L "$staged_binary" | awk 'NR > 1 { print $1 }' | grep -E '^(/opt/homebrew|/usr/local)' >/dev/null; then
        echo "仍存在外部依赖：$staged_binary" >&2
        otool -L "$staged_binary" >&2
        exit 1
    fi
done

echo "[6/7] 对 App 内所有可执行文件进行临时签名"
for staged_binary in "${STAGED_BINARIES[@]}"; do
    codesign --force --sign - --timestamp=none "$staged_binary"
done
codesign --force --sign - --timestamp=none "$RESOURCES_DIR/mediainfo_portable/mediainfo"
codesign --force --sign - --timestamp=none "$APP_EXECUTABLE"
codesign --force --deep --sign - --timestamp=none "$APP_DIR"
codesign --verify --deep --strict --verbose=2 "$APP_DIR"

echo "[7/7] 生成 ZIP 分发包"
ditto -c -k --sequesterRsrc --keepParent "$APP_DIR" "$DIST_DIR/$APP_NAME.zip"

echo
echo "打包完成："
echo "  App: $APP_DIR"
echo "  ZIP: $DIST_DIR/$APP_NAME.zip"
