#!/usr/bin/env zsh

# exa (better ls) configuration

source "$(dirname "${(%):-%N}")/../lib/utils.sh"
source "$(dirname "${(%):-%N}")/../lib/brew.sh"

install_exa() {
    info "Installing exa..."
    
    # Install exa via Homebrew
    info "DEBUG: Installing exa via brew..."
    brew_install "exa"
    info "DEBUG: exa installation completed"
    
    # Create aliases for exa
    info "DEBUG: Setting up exa aliases..."
    local exa_config='
# exa aliases - better ls
if command -v exa > /dev/null 2>&1; then
    alias ls="exa"
    alias ll="exa -l"
    alias la="exa -la"
    alias lt="exa --tree"
    alias l="exa -lah"
    alias ltr="exa -lah --sort=modified"
    alias tree="exa --tree"
fi
'
    
    # Add exa configuration to shell config
    info "DEBUG: Adding exa config to shell..."
    local config_file="${HOME}/.exa_config"
    echo "$exa_config" > "$config_file"
    info "DEBUG: Config file written"
    
    # Source in shell configuration
    info "DEBUG: Sourcing in shell configuration..."
    source_in_shell "[ -f ~/.exa_config ] && source ~/.exa_config"
    info "DEBUG: Shell configuration completed"
    
    info "DEBUG: exa module completing..."
    success "exa configuration complete"
    info "DEBUG: exa module completed successfully"
}