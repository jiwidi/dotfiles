#!/usr/bin/env zsh

# bat (better cat) configuration

source "$(dirname "${(%):-%N}")/../lib/utils.sh"
source "$(dirname "${(%):-%N}")/../lib/brew.sh"

install_bat() {
    info "Installing bat..."
    
    # Install bat via Homebrew
    debug "Installing bat via brew..."
    brew_install "bat"
    debug "bat installation completed"
    
    # Create bat config directory
    debug "Creating bat config directory..."
    local bat_config_dir="${HOME}/.config/bat"
    debug "Config dir: $bat_config_dir"
    debug "Checking if bat config directory exists..."
    if [[ ! -d "$bat_config_dir" ]]; then
        debug "Directory doesn't exist, creating..."
        mkdir -p "$bat_config_dir" 2>/dev/null || {
            error "Failed to create directory: $bat_config_dir"
            return 1
        }
        debug "Directory created successfully"
    else
        debug "Directory already exists"
    fi
    debug "Config directory setup completed"
    
    # Create bat configuration file
    debug "Creating bat config file..."
    cat > "${bat_config_dir}/config" << 'EOF'
# bat configuration
--theme="Dracula"
--style="numbers,changes,header"
--wrap="auto"
--pager="less -FR"
EOF
    debug "Config file created"
    
    # Create aliases and environment variables
    debug "Setting up bat aliases and environment..."
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
    debug "Adding bat config to shell..."
    local config_file="${HOME}/.bat_config"
    echo "$bat_config" > "$config_file"
    debug "Config file written"
    
    # Source in shell configuration
    debug "Sourcing in shell configuration..."
    source_in_shell "[ -f ~/.bat_config ] && source ~/.bat_config"
    debug "Shell configuration completed"
    
    debug "bat module completing..."
    success "bat configuration complete"
    debug "bat module completed successfully"
}