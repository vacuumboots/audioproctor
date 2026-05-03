#!/usr/bin/env bash
# bump-extension.sh — bump the extension version in manifest.json
# Usage: ./scripts/bump-extension.sh patch|minor|major|x.y.z
set -euo pipefail

MANIFEST="extension/manifest.json"

current=$(jq -r '.version' "$MANIFEST")
echo "Current version: $current"

bump_type="${1:-patch}"

if [[ "$bump_type" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  new="$bump_type"
else
  IFS='.' read -r major minor patch <<< "$current"
  case "$bump_type" in
    major) new="$((major + 1)).0.0" ;;
    minor) new="$major.$((minor + 1)).0" ;;
    patch) new="$major.$minor.$((patch + 1))" ;;
    *) echo "Unknown bump type: $bump_type (use patch|minor|major|x.y.z)" >&2; exit 1 ;;
  esac
fi

echo "New version: $new"

tmp=$(mktemp)
jq --arg v "$new" --arg vn "v$new" '.version = $v | .version_name = $vn' "$MANIFEST" > "$tmp"
mv "$tmp" "$MANIFEST"

echo "extension/manifest.json updated to v$new"
