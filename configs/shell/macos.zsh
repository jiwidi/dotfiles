#!/usr/bin/env zsh

# macOS specific configurations

# Only load on macOS
if [[ "$(uname)" != "Darwin" ]]; then
    return 0
fi

# === macOS specific aliases and functions ===

# Use btop instead of top/htop on macOS
if command -v btop > /dev/null 2>&1; then
    alias top="btop"
    alias htop="btop"
fi

# Quick system info
alias sysinfo="system_profiler SPSoftwareDataType SPHardwareDataType"

# Show/hide hidden files in Finder
alias showfiles="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
alias hidefiles="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"

# macOS specific utilities
alias flushdns="sudo dscacheutil -flushcache && sudo killall -HUP mDNSResponder"
alias updatedb="sudo /usr/libexec/locate.updatedb"

# === Enhanced brew function ===

# Enhanced brew wrapper function with additional commands
brew() {
    case "$1" in
        "bump")
            shift
            echo "🍺 Updating Homebrew..."
            command brew update
            echo "⬆️  Upgrading packages..."
            command brew upgrade
            if [[ "$1" == "--cleanup" ]] || [[ "$1" == "-c" ]]; then
                echo "🧹 Cleaning up..."
                command brew cleanup --prune=all
                command brew doctor || true
            fi
            echo "✅ Homebrew bump complete"
            ;;
        "cleanup-all")
            echo "🧹 Running comprehensive cleanup..."
            command brew cleanup --prune=all
            command brew cleanup --cask
            command brew doctor || true
            echo "📊 Cache size:"
            du -sh "$(brew --cache)" 2>/dev/null || echo "Cache directory not found"
            echo "✅ Cleanup complete"
            ;;
        "search-cask")
            shift
            command brew search --cask "$@"
            ;;
        "outdated-cask")
            command brew outdated --cask
            ;;
        *)
            command brew "$@"
            ;;
    esac
}

# Aliases for common brew operations
alias brewup="brew bump"
alias brewclean="brew cleanup-all"
alias brewout="brew outdated && brew outdated --cask"