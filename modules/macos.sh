#!/usr/bin/env zsh

# Optimized macOS system configuration and tools

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
    
    success "macOS configuration complete"
}

install_macos_tools() {
    info "Installing macOS tools..."
    
    # Install btop (better top)
    brew_install "btop"
    
    # Install other useful tools
    brew_install "mas"  # Mac App Store CLI
    brew_install "duti" # Default app manager
    
    success "macOS tools installed (configured via optimized shell)"
}

setup_system_defaults() {
    if confirm "Apply macOS system defaults? (This will modify system preferences)"; then
        info "Applying macOS system defaults..."
        
        local defaults_script="$DOTFILES_DIR/scripts/macos/set-defaults.sh"
        
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