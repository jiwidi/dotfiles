#!/usr/bin/env zsh

# Starship (cross-shell prompt) configuration

source "$(dirname "${(%):-%N}")/../lib/utils.sh"
source "$(dirname "${(%):-%N}")/../lib/brew.sh"

install_starship() {
    info "Installing Starship..."
    
    # Install starship via Homebrew
    info "DEBUG: Installing starship via brew..."
    brew_install "starship"
    info "DEBUG: starship installation completed"
    
    # Create starship config directory
    info "DEBUG: Creating starship config directory..."
    local starship_config_dir="${HOME}/.config"
    info "DEBUG: Config dir: $starship_config_dir"
    if [[ ! -d "$starship_config_dir" ]]; then
        info "DEBUG: Directory doesn't exist, creating..."
        mkdir -p "$starship_config_dir" 2>/dev/null || {
            error "Failed to create directory: $starship_config_dir"
            return 1
        }
        info "DEBUG: Directory created successfully"
    else
        info "DEBUG: Directory already exists"
    fi
    info "DEBUG: Config directory setup completed"
    
    # Copy configuration file
    info "DEBUG: Setting up starship config file..."
    local config_source="${DOTFILES_DIR}/configs/starship/starship.toml"
    info "DEBUG: Config source: $config_source"
    if [[ ! -f "$config_source" ]]; then
        error "Configuration file not found: $config_source"
        return 1
    fi
    info "DEBUG: Creating symlink..."
    create_symlink "$config_source" "${starship_config_dir}/starship.toml"
    info "DEBUG: Symlink created successfully"
    
    # Configure starship initialization
    info "DEBUG: Setting up starship initialization..."
    setup_starship_init
    info "DEBUG: Starship initialization completed"
    
    info "DEBUG: starship module completing..."
    success "Starship configuration complete"
    info "DEBUG: starship module completed successfully"
}

setup_starship_init() {
    info "Setting up Starship initialization..."
    
    # Create starship initialization config for zsh
    info "DEBUG: Creating starship init config..."
    local starship_init='
# Starship prompt initialization
if command -v starship > /dev/null 2>&1; then
    eval "$(starship init zsh 2>/dev/null || true)"
fi
'
    
    # Add starship configuration to shell config
    info "DEBUG: Writing starship init file..."
    local config_file="${HOME}/.starship_init"
    echo "$starship_init" > "$config_file"
    info "DEBUG: Init file written"
    
    # Source in shell configuration (prioritizes zsh)
    info "DEBUG: Adding to shell configuration..."
    source_in_shell "[ -f ~/.starship_init ] && source ~/.starship_init"
    info "DEBUG: Shell configuration completed"
    
    info "DEBUG: starship init setup completing..."
    success "Starship initialization configured"
    info "DEBUG: starship init setup completed"
}