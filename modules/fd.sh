#!/usr/bin/env zsh

# fd (better find) configuration

source "$(dirname "${(%):-%N}")/../lib/utils.sh"
source "$(dirname "${(%):-%N}")/../lib/brew.sh"

install_fd() {
    info "Installing fd..."
    
    # Install fd via Homebrew
    brew_install "fd"
    
    # Create aliases for fd
    local fd_config='
# fd aliases - better find
if command -v fd > /dev/null 2>&1; then
    alias find="fd"
fi
'
    
    # Add fd configuration to shell config
    local config_file="${HOME}/.fd_config"
    echo "$fd_config" > "$config_file"
    
    # Source in shell configuration
    source_in_shell "[ -f ~/.fd_config ] && source ~/.fd_config"
    
    success "fd configuration complete"
}