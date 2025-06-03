#!/usr/bin/env zsh

# ZSH enhancements: syntax highlighting and autosuggestions

source "$(dirname "${(%):-%N}")/../lib/utils.sh"
source "$(dirname "${(%):-%N}")/../lib/brew.sh"

install_zsh-enhancements() {
    info "Installing ZSH enhancements..."
    
    # Install zsh-syntax-highlighting
    brew_install "zsh-syntax-highlighting"
    
    # Install zsh-autosuggestions
    brew_install "zsh-autosuggestions"
    
    success "ZSH enhancements installed (configured via shell configuration)"
}