#!/usr/bin/env bash
set -e

PLUGIN_DIR="$HOME/Documents/SwiftBar-plugins"
SCRIPT="$PLUGIN_DIR/claude-stats.1m.sh"
SCRIPT_URL="https://raw.githubusercontent.com/jeremykenedy/claude-swiftbar-monitor/main/claude-stats.1m.sh"

echo ""
echo "🤖 Claude Monitor Installer"
echo "================================"
echo ""

# 1. Install SwiftBar if not present
if [ ! -d "/Applications/SwiftBar.app" ]; then
  echo "📦 Installing SwiftBar..."
  brew install --cask swiftbar
else
  echo "✅ SwiftBar already installed"
fi

# 2. Create plugins folder
mkdir -p "$PLUGIN_DIR"
echo "✅ Plugin folder: $PLUGIN_DIR"

# 3. Download the script
echo "📥 Downloading claude-stats plugin..."
curl -fsSL "$SCRIPT_URL" -o "$SCRIPT"
chmod +x "$SCRIPT"
echo "✅ Plugin installed"

# 4. Set SwiftBar plugin directory
defaults write com.ameba.SwiftBar PluginDirectory "$PLUGIN_DIR"
echo "✅ SwiftBar configured"

# 5. Enable JavaScript from Apple Events in Chrome
if [ -d "/Applications/Google Chrome.app" ]; then
  defaults write com.google.Chrome AllowJavascriptAppleEvents -bool true
  echo "✅ Chrome: JavaScript from Apple Events enabled"
else
  echo "⚠️  Chrome not found -- skipping JS setting"
fi

# 6. Create claude data dir
mkdir -p "$HOME/.claude"

# 7. Launch SwiftBar
echo ""
echo "🚀 Launching SwiftBar..."
pkill -x SwiftBar 2>/dev/null || true
sleep 1
defaults write com.ameba.SwiftBar PluginDirectory "$PLUGIN_DIR"
open -g /Applications/SwiftBar.app

echo ""
echo "================================"
echo "✅ Claude Monitor installed!"
echo ""
echo "🤖 You should see the icon in your menu bar within 60 seconds."
echo ""
echo "📌 Note: Make sure Chrome is open and logged into claude.ai"
echo "   for live usage data to appear."
echo ""
