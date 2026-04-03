class ClaudeMonitor < Formula
  desc "Real-time Claude usage stats in your macOS menu bar"
  homepage "https://github.com/jeremykenedy/claude-swiftbar-monitor"
  url "https://github.com/jeremykenedy/claude-swiftbar-monitor/archive/refs/heads/main.tar.gz"
  version "1.0.0"
  license "MIT"

  depends_on :macos

  def install
    (prefix/"install.sh").write <<~SH
      #!/usr/bin/env bash
      set -e
      PLUGIN_DIR="$HOME/Documents/SwiftBar-plugins"
      SCRIPT="$PLUGIN_DIR/claude-stats.1m.sh"
      SCRIPT_URL="https://raw.githubusercontent.com/jeremykenedy/claude-swiftbar-monitor/main/claude-stats.1m.sh"
      echo ""
      echo "🤖 Claude Monitor Installer"
      echo "================================"
      echo ""
      if [ ! -d "/Applications/SwiftBar.app" ]; then
        echo "📦 Installing SwiftBar..."
        brew install --cask swiftbar
      else
        echo "✅ SwiftBar already installed"
      fi
      mkdir -p "$PLUGIN_DIR"
      echo "✅ Plugin folder ready"
      echo "📥 Downloading plugin..."
      curl -fsSL "$SCRIPT_URL" -o "$SCRIPT"
      chmod +x "$SCRIPT"
      echo "✅ Plugin installed"
      defaults write com.ameba.SwiftBar PluginDirectory "$PLUGIN_DIR"
      echo "✅ SwiftBar configured"
      if [ -d "/Applications/Google Chrome.app" ]; then
        defaults write com.google.Chrome AllowJavascriptAppleEvents -bool true
        echo "✅ Chrome: JavaScript from Apple Events enabled"
      else
        echo "⚠️  Chrome not found -- you will need to enable this manually:"
        echo "   Chrome menu bar: View > Developer > Allow JavaScript from Apple Events"
      fi
      mkdir -p "$HOME/.claude"
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
      echo "🤖 The icon will appear in your menu bar within 60 seconds."
      echo "📌 Make sure Chrome is open and logged into claude.ai"
      echo ""
    SH
    chmod "+x", prefix/"install.sh"

    (bin/"claude-monitor").write <<~SH
      #!/usr/bin/env bash
      PLUGIN_DIR="$HOME/Documents/SwiftBar-plugins"
      SCRIPT="$PLUGIN_DIR/claude-stats.1m.sh"
      SCRIPT_URL="https://raw.githubusercontent.com/jeremykenedy/claude-swiftbar-monitor/main/claude-stats.1m.sh"
      HOMEBREW_PREFIX=$(brew --prefix 2>/dev/null || echo "/opt/homebrew")
      INSTALL_SCRIPT="$HOMEBREW_PREFIX/opt/claude-monitor/install.sh"
      cmd="${1:-help}"
      case "$cmd" in
        install)  bash "$INSTALL_SCRIPT" ;;
        update)
          echo "📥 Updating..."
          curl -fsSL "$SCRIPT_URL" -o "$SCRIPT" && chmod +x "$SCRIPT"
          pkill -x SwiftBar 2>/dev/null || true; sleep 1
          defaults write com.ameba.SwiftBar PluginDirectory "$PLUGIN_DIR"
          open -g /Applications/SwiftBar.app
          echo "✅ Updated" ;;
        restart)
          pkill -x SwiftBar 2>/dev/null || true; sleep 1
          defaults write com.ameba.SwiftBar PluginDirectory "$PLUGIN_DIR"
          open -g /Applications/SwiftBar.app
          echo "✅ Restarted" ;;
        status)
          echo ""
          echo "🤖 Claude Monitor Status"
          echo "========================"
          pgrep -x SwiftBar > /dev/null && echo "✅ SwiftBar: running" || echo "❌ SwiftBar: not running"
          [ -f "$SCRIPT" ] && echo "✅ Plugin: installed" || echo "❌ Plugin: not found"
          PDIR=$(defaults read com.ameba.SwiftBar PluginDirectory 2>/dev/null)
          [ -n "$PDIR" ] && echo "✅ Plugin dir: $PDIR" || echo "❌ Plugin dir: not set"
          [ -f "$HOME/.claude/usage-cache.json" ] && echo "✅ Cache: exists" || echo "⚠️  Cache: not yet populated (open claude.ai in Chrome)"
          echo "" ;;
        *)
          echo ""
          echo "🤖 claude-monitor"
          echo ""
          echo "Usage:"
          echo "  claude-monitor install    Set up everything and launch"
          echo "  claude-monitor update     Update plugin to latest version"
          echo "  claude-monitor restart    Restart SwiftBar"
          echo "  claude-monitor status     Show installation status"
          echo "" ;;
      esac
    SH
  end

  def caveats
    <<~EOS
      Run the setup wizard to complete installation:

        claude-monitor install

      This will install SwiftBar, configure everything, and launch automatically.

      Requirements:
        - Google Chrome logged into claude.ai
        - macOS 12 or later
    EOS
  end

  test do
    assert_predicate bin/"claude-monitor", :exist?
  end
end
