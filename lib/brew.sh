#!/usr/bin/env zsh

# Homebrew management utilities

source "$(dirname "${(%):-%N}")/utils.sh"

# Enhanced brew function with additional commands
brew() {
    case "$1" in
        "bump")
            shift
            brew_bump "$@"
            ;;
        "cleanup-all")
            brew_cleanup_all
            ;;
        *)
            command brew "$@"
            ;;
    esac
}

# Update, upgrade, and cleanup brew
brew_bump() {
    info "Updating Homebrew..."
    command brew update
    
    info "Upgrading installed packages..."
    command brew upgrade
    
    if [[ "$1" == "--cleanup" ]] || [[ "$1" == "-c" ]]; then
        brew_cleanup_all
    fi
    
    success "Homebrew bump complete"
}

# Comprehensive cleanup
brew_cleanup_all() {
    info "Running comprehensive Homebrew cleanup..."
    
    # Standard cleanup
    command brew cleanup --prune=all
    
    # Remove broken symlinks
    command brew cleanup --prune=all
    
    # Doctor check
    info "Running brew doctor..."
    command brew doctor || true
    
    # Show disk usage
    info "Homebrew cache size:"
    du -sh "$(brew --cache)" 2>/dev/null || info "Cache directory not found"
    
    success "Homebrew cleanup complete"
}

# Install multiple packages at once
brew_install_packages() {
    local packages=("$@")
    
    for package in "${packages[@]}"; do
        brew_install "$package"
    done
}

# Install multiple casks at once
brew_install_casks() {
    local casks=("$@")
    
    for cask in "${casks[@]}"; do
        brew_install "$cask" true
    done
}

# Check if Homebrew is installed and install if missing
ensure_homebrew() {
    if ! has_command brew; then
        info "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        
        # Add Homebrew to PATH for Apple Silicon Macs
        if [[ -d "/opt/homebrew" ]]; then
            export PATH="/opt/homebrew/bin:$PATH"
        fi
    fi
}

# Export the enhanced brew function (zsh style)
# Function is automatically available when sourced in zsh