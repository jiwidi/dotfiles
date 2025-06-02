#!/usr/bin/env zsh

# htop (system monitor) configuration

source "$(dirname "${(%):-%N}")/../lib/utils.sh"
source "$(dirname "${(%):-%N}")/../lib/brew.sh"

install_htop() {
    info "Installing htop..."
    
    # Install htop via Homebrew
    info "DEBUG: Installing htop via brew..."
    brew_install "htop"
    info "DEBUG: htop installation completed"
    
    # Create htop config directory
    info "DEBUG: Creating htop config directory..."
    local htop_config_dir="${HOME}/.config/htop"
    info "DEBUG: Config dir: $htop_config_dir"
    if [[ ! -d "$htop_config_dir" ]]; then
        info "DEBUG: Directory doesn't exist, creating..."
        mkdir -p "$htop_config_dir" 2>/dev/null || {
            error "Failed to create directory: $htop_config_dir"
            return 1
        }
        info "DEBUG: Directory created successfully"
    else
        info "DEBUG: Directory already exists"
    fi
    info "DEBUG: Config directory setup completed"
    
    # Copy configuration file
    info "DEBUG: Setting up htop config file..."
    local config_source="${DOTFILES_DIR}/configs/htop/htoprc"
    info "DEBUG: Config source: $config_source"
    if [[ ! -f "$config_source" ]]; then
        error "Configuration file not found: $config_source"
        return 1
    fi
    info "DEBUG: Creating symlink..."
    create_symlink "$config_source" "${htop_config_dir}/htoprc"
    info "DEBUG: Symlink created successfully"
    
    info "DEBUG: htop module completing..."
    success "htop configuration complete"
    info "DEBUG: htop module completed successfully"
}