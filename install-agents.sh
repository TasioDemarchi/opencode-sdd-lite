#!/usr/bin/env bash
#
# SDD Lite — Agent Config Installer
# Merges SDD Lite agents into opencode.json using jq
# Requires: jq
#
set -euo pipefail

OPENCODE_DIR="${OPENCODE_DIR:-$HOME/.config/opencode}"
OPENCODE_JSON="$OPENCODE_DIR/opencode.json"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
AGENTS_FILE="$SCRIPT_DIR/agents/sdd-lite-agents.json"

echo "╔══════════════════════════════════════════════════╗"
echo "║      SDD Lite — Agent Config Installer          ║"
echo "╚══════════════════════════════════════════════════╝"
echo ""

# Check jq
if ! command -v jq &> /dev/null; then
    echo "❌ jq is required but not installed."
    echo "   Install it: https://jqlang.github.io/jq/download/"
    exit 1
fi

# Check opencode.json exists
if [ ! -f "$OPENCODE_JSON" ]; then
    echo "❌ opencode.json not found at: $OPENCODE_JSON"
    echo "   Make sure opencode is configured on this machine."
    exit 1
fi

# Backup
BACKUP="$OPENCODE_JSON.backup.$(date +%Y%m%d%H%M%S)"
cp "$OPENCODE_JSON" "$BACKUP"
echo "📦 Backed up opencode.json to: $BACKUP"

# Merge agents
echo "🔧 Merging SDD Lite agents into opencode.json..."

# Read current agents and new agents, merge them
CURRENT_AGENTS=$(jq '.agent' "$OPENCODE_JSON")
NEW_AGENTS=$(jq '.' "$AGENTS_FILE")

# Check for conflicts
CONFLICTS=$(echo "$CURRENT_AGENTS" | jq -r "keys[]" | while read -r key; do
    echo "$NEW_AGENTS" | jq -r "keys[]" | while read -r new_key; do
        if [ "$key" = "$new_key" ]; then
            echo "$key"
        fi
    done
done | sort -u)

if [ -n "$CONFLICTS" ]; then
    echo "⚠️  The following agents already exist and will be OVERWRITTEN:"
    echo "$CONFLICTS" | while read -r key; do
        echo "   - $key"
    done
    echo ""
    read -p "Continue? [y/N] " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "❌ Cancelled."
        exit 1
    fi
fi

# Merge
MERGED=$(echo "$CURRENT_AGENTS" | jq --argjson new "$NEW_AGENTS" '. + $new')
TEMP_FILE=$(mktemp)
jq --argjson agents "$MERGED" '.agent = $agents' "$OPENCODE_JSON" > "$TEMP_FILE"
mv "$TEMP_FILE" "$OPENCODE_JSON"

echo "   ✅ Agents merged successfully"
echo ""
echo "══════════════════════════════════════════════════"
echo "  ✅ SDD Lite agents configured!"
echo "  Restart opencode to activate."
echo "══════════════════════════════════════════════════"