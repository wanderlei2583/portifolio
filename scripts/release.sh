#!/usr/bin/env bash

set -e

LATEST=$(git describe --tags --abbrev=0 2>/dev/null || echo "0.1.0")
IFS='.' read -r MA MI PA <<<"$LATEST"

if [[ -n "$PATCH" ]]; then
  PA=$((PA + 1))
elif [[ -n "$MINOR" ]]; then
  MI=$((MI + 1))
  PA=0
elif [[ -n "$MAJOR" ]]; then
  MA=$((MA + 1))
  MI=0
  PA=0
fi

NEW="$MA.$MI.$PA"

git tag -a "$NEW" -m "release $NEW"
git push origin "$NEW"

echo "Release $NEW criado"
