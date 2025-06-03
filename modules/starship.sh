#!/usr/bin/env zsh

# Starship (cross-shell prompt) configuration - optimized

source "$(dirname "${(%):-%N}")/../lib/utils.sh"
source "$(dirname "${(%):-%N}")/../lib/brew.sh"

install_starship() {
    info "Installing Starship..."
    brew_install "starship"
    
    # Create starship config directory
    local starship_config_dir="${HOME}/.config"
    if [[ ! -d "$starship_config_dir" ]]; then
        mkdir -p "$starship_config_dir"
    fi
    
    # Link configuration file directly from dotfiles
    local config_source="$DOTFILES_DIR/configs/starship/starship.toml"
    if [[ ! -f "$config_source" ]]; then
        error "Configuration file not found: $config_source"
        return 1
    fi
    
    create_symlink "$config_source" "${starship_config_dir}/starship.toml"
    
    success "Starship installed and configured"
}