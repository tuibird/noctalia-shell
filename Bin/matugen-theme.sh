#!/bin/bash

# matugen-theme.sh - Generate theme colors from wallpaper using matugen
# Usage: ./matugen-theme.sh <wallpaper_path>

set -e

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
CONFIG_FILE="$PROJECT_DIR/Assets/Matugen/matugen.toml"
TEMPLATE_FILE="$PROJECT_DIR/Assets/Matugen/templates/noctalia.json"
OUTPUT_DIR="$HOME/.config/noctalia"
OUTPUT_FILE="$OUTPUT_DIR/theme.json"

# Check if wallpaper path is provided
if [ $# -eq 0 ]; then
    echo "Error: No wallpaper path provided"
    echo "Usage: $0 <wallpaper_path>"
    exit 1
fi

WALLPAPER_PATH="$1"

# Check if wallpaper exists
if [ ! -f "$WALLPAPER_PATH" ]; then
    echo "Error: Wallpaper file not found: $WALLPAPER_PATH"
    exit 1
fi

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Generate theme using matugen
echo "Generating theme from wallpaper: $WALLPAPER_PATH"

# Use matugen to generate colors and transform to our format
matugen image "$WALLPAPER_PATH" \
    --config "$CONFIG_FILE" \
    --json hex | jq -c '
{
  "backgroundPrimary": .colors.dark.surface_dim,
  "backgroundSecondary": .colors.dark.surface,
  "backgroundTertiary": .colors.dark.surface_bright,
  "surface": .colors.dark.surface,
  "surfaceVariant": .colors.dark.surface_variant,
  "textPrimary": .colors.dark.on_surface,
  "textSecondary": .colors.dark.on_surface_variant,
  "textDisabled": .colors.dark.on_surface_variant,
  "accentPrimary": .colors.dark.primary,
  "accentSecondary": .colors.dark.secondary,
  "accentTertiary": .colors.dark.tertiary,
  "error": .colors.dark.error,
  "warning": .colors.dark.error_container,
  "hover": .colors.dark.primary_container,
  "onAccent": .colors.dark.on_primary,
  "outline": .colors.dark.outline,
  "shadow": .colors.dark.shadow,
  "overlay": .colors.dark.scrim
}' > "$OUTPUT_FILE.tmp" && mv "$OUTPUT_FILE.tmp" "$OUTPUT_FILE"

echo "Theme generated successfully: $OUTPUT_FILE" 