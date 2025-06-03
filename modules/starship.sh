#!/usr/bin/env zsh

# Starship (cross-shell prompt) configuration

source "$(dirname "${(%):-%N}")/../lib/utils.sh"
source "$(dirname "${(%):-%N}")/../lib/brew.sh"

install_starship() {
    info "Installing Starship..."
    
    # Install starship via Homebrew
    debug "Installing starship via brew..."
    brew_install "starship"
    debug "starship installation completed"
    
    # Create starship config directory
    debug "Creating starship config directory..."
    local starship_config_dir="${HOME}/.config"
    debug "Config dir: $starship_config_dir"
    if [[ ! -d "$starship_config_dir" ]]; then
        debug "Directory doesn't exist, creating..."
        mkdir -p "$starship_config_dir" 2>/dev/null || {
            error "Failed to create directory: $starship_config_dir"
            return 1
        }
        debug "Directory created successfully"
    else
        debug "Directory already exists"
    fi
    debug "Config directory setup completed"
    
    # Copy configuration file
    debug "Setting up starship config file..."
    local config_source="${DOTFILES_DIR}/configs/starship/starship.toml"
    debug "Config source: $config_source"
    if [[ ! -f "$config_source" ]]; then
        error "Configuration file not found: $config_source"
        return 1
    fi
    debug "Creating symlink..."
    create_symlink "$config_source" "${starship_config_dir}/starship.toml"
    debug "Symlink created successfully"
    
    # Configure starship initialization
    debug "Setting up starship initialization..."
    setup_starship_init
    debug "Starship initialization completed"
    
    debug "starship module completing..."
    success "Starship configuration complete"
    debug "starship module completed successfully"
}

setup_starship_init() {
    info "Setting up Starship initialization..."
    
    # Create starship initialization config for zsh
    debug "Creating starship init config..."
    local starship_init='
# Starship prompt initialization
if command -v starship > /dev/null 2>&1; then
    eval "$(starship init zsh 2>/dev/null || true)"
fi
'
    
    # Add starship configuration to shell config
    debug "Writing starship init file..."
    local config_file="${HOME}/.starship_init"
    echo "$starship_init" > "$config_file"
    debug "Init file written"
    
    # Source in shell configuration (prioritizes zsh)
    debug "Adding to shell configuration..."
    source_in_shell "[ -f ~/.starship_init ] && source ~/.starship_init"
    debug "Shell configuration completed"
    
    debug "starship init setup completing..."
    success "Starship initialization configured"
    debug "starship init setup completed"
}