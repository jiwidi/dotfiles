#!/usr/bin/env zsh

# fd (better find) configuration - optimized

source "$(dirname "${(%):-%N}")/../lib/utils.sh"
source "$(dirname "${(%):-%N}")/../lib/brew.sh"

install_fd() {
    info "Installing fd..."
    brew_install "fd"
    success "fd installed (configured via shell configuration)"
}