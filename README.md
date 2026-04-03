# homebrew-claude-monitor

Homebrew tap for [Claude Monitor](https://github.com/jeremykenedy/claude-swiftbar-monitor) -- real-time Claude usage stats in your macOS menu bar.

## Install

```bash
brew tap jeremykenedy/claude-monitor
brew install claude-monitor
claude-monitor install
```

That's it. The install command handles everything:

- Installs SwiftBar if not present
- Downloads and installs the plugin
- Configures SwiftBar automatically
- Enables JavaScript from Apple Events in Chrome
- Launches SwiftBar

## Commands

```bash
claude-monitor install    # Set up everything and launch
claude-monitor update     # Update plugin to latest version
claude-monitor restart    # Restart SwiftBar
claude-monitor status     # Show installation status
```

## Requirements

- macOS 12 or later
- Google Chrome logged into claude.ai
