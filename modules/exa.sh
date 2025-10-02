#!/usr/bin/env zsh

# eza (better ls) configuration - optimized
# eza is the modern maintained fork of exa

source "$(dirname "${(%):-%N}")/../lib/utils.sh"
source "$(dirname "${(%):-%N}")/../lib/brew.sh"

install_exa() {
    info "Installing eza (modern exa replacement)..."

    # Uninstall old exa if present
    if brew list exa &> /dev/null; then
        info "Removing old exa installation..."
        brew uninstall exa 2>/dev/null || true
    fi

    # Install eza
    brew_install "eza"
    success "eza installed (configured via shell configuration)"
}