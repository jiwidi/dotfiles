#!/usr/bin/env zsh

# fzf (fuzzy finder) configuration - optimized

source "$(dirname "${(%):-%N}")/../lib/utils.sh"
source "$(dirname "${(%):-%N}")/../lib/brew.sh"

install_fzf() {
    info "Installing fzf..."
    brew_install "fzf"
    
    # Install shell integration
    if [[ -f "/opt/homebrew/opt/fzf/install" ]]; then
        yes | /opt/homebrew/opt/fzf/install --completion --key-bindings --no-update-rc
    elif [[ -f "/usr/local/opt/fzf/install" ]]; then
        yes | /usr/local/opt/fzf/install --completion --key-bindings --no-update-rc
    fi
    
    success "fzf installed and configured"
}