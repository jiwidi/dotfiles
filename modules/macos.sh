#!/usr/bin/env zsh

# macOS system configuration and tools

source "$(dirname "${(%):-%N}")/../lib/utils.sh"
source "$(dirname "${(%):-%N}")/../lib/brew.sh"

install_macos() {
    info "Configuring macOS..."
    
    # Check if we're on macOS
    if ! is_macos; then
        warning "This module is for macOS only"
        return 0
    fi
    
    # Install essential tools
    install_macos_tools
    
    # Set up system defaults
    setup_system_defaults
    
    # Set up brew wrapper function
    setup_brew_wrapper
    
    success "macOS configuration complete"
}

install_macos_tools() {
    info "Installing macOS tools..."
    
    # Install btop (better top)
    brew_install "btop"
    
    # Install other useful tools
    brew_install "mas"  # Mac App Store CLI
    brew_install "duti" # Default app manager
    
    # Create aliases for system monitoring
    local macos_config='
# macOS specific aliases and functions
if [[ "$(uname)" == "Darwin" ]]; then
    # Use btop instead of top/htop on macOS
    alias top="btop"
    alias htop="btop"
    
    # Quick system info
    alias sysinfo="system_profiler SPSoftwareDataType SPHardwareDataType"
    
    # Show/hide hidden files in Finder
    alias showfiles="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
    alias hidefiles="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"
    
    # macOS specific utilities
    alias flushdns="sudo dscacheutil -flushcache && sudo killall -HUP mDNSResponder"
    alias updatedb="sudo /usr/libexec/locate.updatedb"
fi
'
    
    # Add macOS configuration to shell config
    local config_file="${HOME}/.macos_config"
    echo "$macos_config" > "$config_file"
    
    # Source in shell configuration
    source_in_shell "[ -f ~/.macos_config ] && source ~/.macos_config"
}

setup_system_defaults() {
    if confirm "Apply macOS system defaults? (This will modify system preferences)"; then
        info "Applying macOS system defaults..."
        
        local defaults_script="${DOTFILES_DIR}/scripts/macos/set-defaults.sh"
        
        if [[ -f "$defaults_script" ]]; then
            if [[ ! -x "$defaults_script" ]]; then
                chmod +x "$defaults_script"
            fi
            zsh "$defaults_script"
        else
            error "macOS defaults script not found at: $defaults_script"
            return 1
        fi
        
        success "System defaults applied"
    else
        info "Skipping system defaults configuration"
    fi
}

setup_brew_wrapper() {
    info "Setting up enhanced brew wrapper..."
    
    # Enhanced brew wrapper function
    local brew_wrapper='
# Enhanced brew function with additional commands
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
'
    
    # Add brew wrapper to shell config
    local config_file="${HOME}/.brew_wrapper"
    echo "$brew_wrapper" > "$config_file"
    
    # Source in shell configuration
    source_in_shell "[ -f ~/.brew_wrapper ] && source ~/.brew_wrapper"
    
    success "Brew wrapper configured"
}