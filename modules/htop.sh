#!/usr/bin/env zsh

# htop (system monitor) configuration

source "$(dirname "${(%):-%N}")/../lib/utils.sh"
source "$(dirname "${(%):-%N}")/../lib/brew.sh"

install_htop() {
    info "Installing htop..."
    
    # Install htop via Homebrew
    debug "Installing htop via brew..."
    brew_install "htop"
    debug "htop installation completed"
    
    # Create htop config directory
    debug "Creating htop config directory..."
    local htop_config_dir="${HOME}/.config/htop"
    debug "Config dir: $htop_config_dir"
    if [[ ! -d "$htop_config_dir" ]]; then
        debug "Directory doesn't exist, creating..."
        mkdir -p "$htop_config_dir" 2>/dev/null || {
            error "Failed to create directory: $htop_config_dir"
            return 1
        }
        debug "Directory created successfully"
    else
        debug "Directory already exists"
    fi
    debug "Config directory setup completed"
    
    # Copy configuration file
    debug "Setting up htop config file..."
    local config_source="${DOTFILES_DIR}/configs/htop/htoprc"
    debug "Config source: $config_source"
    if [[ ! -f "$config_source" ]]; then
        error "Configuration file not found: $config_source"
        return 1
    fi
    debug "Creating symlink..."
    create_symlink "$config_source" "${htop_config_dir}/htoprc"
    debug "Symlink created successfully"
    
    debug "htop module completing..."
    success "htop configuration complete"
    debug "htop module completed successfully"
}