#!/usr/bin/env bash
#
# SDD Lite — Installer
# Copies skills, prompts, shared files, and AGENTS.md to ~/.config/opencode/
# Prints instructions for adding agent configs to opencode.json
#
set -euo pipefail

OPENCODE_DIR="${OPENCODE_DIR:-$HOME/.config/opencode}"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "╔══════════════════════════════════════════════════╗"
echo "║         SDD Lite — Installer                     ║"
echo "║   Spec-Driven Development for personal projects  ║"
echo "╚══════════════════════════════════════════════════╝"
echo ""

# ──────────────────────────────────────────────
# 1. Copy skills
# ──────────────────────────────────────────────
echo "📦 Installing skills..."
mkdir -p "$OPENCODE_DIR/skills/sdd-lite/templates"
mkdir -p "$OPENCODE_DIR/skills/sdd-lite-apply"
mkdir -p "$OPENCODE_DIR/skills/sdd-lite-design"
mkdir -p "$OPENCODE_DIR/skills/sdd-lite-onboard"
mkdir -p "$OPENCODE_DIR/skills/_shared"

cp -r "$SCRIPT_DIR/skills/sdd-lite/SKILL.md"          "$OPENCODE_DIR/skills/sdd-lite/"
cp -r "$SCRIPT_DIR/skills/sdd-lite/templates/"*.md    "$OPENCODE_DIR/skills/sdd-lite/templates/"
cp -r "$SCRIPT_DIR/skills/sdd-lite-apply/SKILL.md"    "$OPENCODE_DIR/skills/sdd-lite-apply/"
cp -r "$SCRIPT_DIR/skills/sdd-lite-design/SKILL.md"   "$OPENCODE_DIR/skills/sdd-lite-design/"
cp -r "$SCRIPT_DIR/skills/sdd-lite-onboard/SKILL.md"  "$OPENCODE_DIR/skills/sdd-lite-onboard/"
cp -r "$SCRIPT_DIR/_shared/sdd-lite-common.md"        "$OPENCODE_DIR/skills/_shared/"

echo "   ✅ Skills installed"

# ──────────────────────────────────────────────
# 2. Copy prompts
# ──────────────────────────────────────────────
echo "📦 Installing prompts..."
mkdir -p "$OPENCODE_DIR/prompts/sdd-lite"

cp -r "$SCRIPT_DIR/prompts/sdd-lite/"*.md "$OPENCODE_DIR/prompts/sdd-lite/"

echo "   ✅ Prompts installed"

# ──────────────────────────────────────────────
# 3. Copy AGENTS.md (backup existing if present)
# ──────────────────────────────────────────────
if [ -f "$OPENCODE_DIR/AGENTS.md" ]; then
    BACKUP="$OPENCODE_DIR/AGENTS.md.backup.$(date +%Y%m%d%H%M%S)"
    cp "$OPENCODE_DIR/AGENTS.md" "$BACKUP"
    echo "📄 Existing AGENTS.md backed up to: $BACKUP"
fi

cp "$SCRIPT_DIR/AGENTS.md" "$OPENCODE_DIR/AGENTS.md"
echo "   ✅ AGENTS.md installed"

# ──────────────────────────────────────────────
# 4. Instructions for opencode.json
# ──────────────────────────────────────────────
echo ""
echo "⚠️  IMPORTANT: You need to add the SDD Lite agents to your opencode.json"
echo ""
echo "   The agent configs are in: agents/sdd-lite-agents.json"
echo ""
echo "   You have two options:"
echo ""
echo "   Option A — Manual (copy-paste):"
echo "     1. Open ~/.config/opencode/opencode.json"
echo "     2. Copy the contents of agents/sdd-lite-agents.json"
echo "     3. Paste into the \"agent\" section of opencode.json"
echo "     4. Adjust model names if needed (see Models section in README)"
echo ""
echo "   Option B — Automated (requires jq):"
echo "     Run: ./install-agents.sh"
echo ""
echo "   Then restart opencode for changes to take effect."
echo ""
echo "══════════════════════════════════════════════════"
echo "  ✅ SDD Lite installed successfully!"
echo "  Restart opencode to activate."
echo "══════════════════════════════════════════════════"