#!/usr/bin/env zsh

# exa (better ls) configuration - optimized

source "$(dirname "${(%):-%N}")/../lib/utils.sh"
source "$(dirname "${(%):-%N}")/../lib/brew.sh"

install_exa() {
    info "Installing exa..."
    brew_install "exa"
    success "exa installed (configured via shell configuration)"
}