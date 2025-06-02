#!/usr/bin/env zsh

# bat (better cat) configuration

source "$(dirname "${(%):-%N}")/../lib/utils.sh"
source "$(dirname "${(%):-%N}")/../lib/brew.sh"

install_bat() {
    info "Installing bat..."
    
    # Install bat via Homebrew
    info "DEBUG: Installing bat via brew..."
    brew_install "bat"
    info "DEBUG: bat installation completed"
    
    # Create bat config directory
    info "DEBUG: Creating bat config directory..."
    local bat_config_dir="${HOME}/.config/bat"
    info "DEBUG: Config dir: $bat_config_dir"
    info "DEBUG: Checking if bat config directory exists..."
    if [[ ! -d "$bat_config_dir" ]]; then
        info "DEBUG: Directory doesn't exist, creating..."
        mkdir -p "$bat_config_dir" 2>/dev/null || {
            error "Failed to create directory: $bat_config_dir"
            return 1
        }
        info "DEBUG: Directory created successfully"
    else
        info "DEBUG: Directory already exists"
    fi
    info "DEBUG: Config directory setup completed"
    
    # Create bat configuration file
    info "DEBUG: Creating bat config file..."
    cat > "${bat_config_dir}/config" << 'EOF'
# bat configuration
--theme="Dracula"
--style="numbers,changes,header"
--wrap="auto"
--pager="less -FR"
EOF
    info "DEBUG: Config file created"
    
    # Create aliases and environment variables
    info "DEBUG: Setting up bat aliases and environment..."
    local bat_config='
# bat configuration
if command -v bat > /dev/null 2>&1; then
    alias cat="bat"
    alias less="bat"
    
    # Use bat as manpager
    export MANPAGER="sh -c '\''col -bx | bat -l man -p'\''"
    export MANROFFOPT="-c"
fi
'
    
    # Add bat configuration to shell config
    info "DEBUG: Adding bat config to shell..."
    local config_file="${HOME}/.bat_config"
    echo "$bat_config" > "$config_file"
    info "DEBUG: Config file written"
    
    # Source in shell configuration
    info "DEBUG: Sourcing in shell configuration..."
    source_in_shell "[ -f ~/.bat_config ] && source ~/.bat_config"
    info "DEBUG: Shell configuration completed"
    
    info "DEBUG: bat module completing..."
    success "bat configuration complete"
    info "DEBUG: bat module completed successfully"
}