#!/usr/bin/env zsh

# Raycast (productivity tool) configuration

source "$(dirname "${(%):-%N}")/../lib/utils.sh"
source "$(dirname "${(%):-%N}")/../lib/brew.sh"

install_raycast() {
    info "Installing Raycast..."

    # Install Raycast via Homebrew Cask
    brew_install "raycast" true

    success "Raycast installation complete"
    info "Launch Raycast and configure your preferred hotkey"
}