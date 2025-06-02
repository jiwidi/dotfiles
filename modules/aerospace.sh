#!/usr/bin/env zsh

# AeroSpace (tiling window manager) configuration

source "$(dirname "${(%):-%N}")/../lib/utils.sh"
source "$(dirname "${(%):-%N}")/../lib/brew.sh"

install_aerospace() {
    info "Installing AeroSpace..."
    
    # Install AeroSpace via Homebrew
    brew_install "nikitabobko/tap/aerospace" true
    
    # Install borders (window borders for tiling WM)
    brew_install "felixkratz/formulae/borders"
    
    # Create AeroSpace config directory
    info "Setting up AeroSpace configuration..."
    info "DEBUG: Creating config directory..."
    local aerospace_config_dir="${HOME}/.config/aerospace"
    info "DEBUG: Config dir path: $aerospace_config_dir"
    info "DEBUG: Checking if directory exists..."
    if [[ ! -d "$aerospace_config_dir" ]]; then
        info "DEBUG: Directory doesn't exist, creating..."
        mkdir -p "$aerospace_config_dir" 2>/dev/null || {
            error "Failed to create directory: $aerospace_config_dir"
            return 1
        }
        info "DEBUG: Directory created successfully"
    else
        info "DEBUG: Directory already exists"
    fi
    info "DEBUG: Config directory setup completed"
    
    # Copy configuration file
    local config_source="${DOTFILES_DIR}/configs/aerospace/aerospace.toml"
    info "DEBUG: Config source: $config_source"
    info "DEBUG: DOTFILES_DIR: $DOTFILES_DIR"
    info "DEBUG: Checking if source file exists..."
    if [[ ! -f "$config_source" ]]; then
        error "Configuration file not found: $config_source"
        return 1
    fi
    info "DEBUG: Source file exists, creating symlink..."
    create_symlink "$config_source" "${aerospace_config_dir}/aerospace.toml"
    info "DEBUG: Symlink created successfully"
    
    # Start borders service (optional)
    info "DEBUG: Starting borders service check..."
    info "Checking borders service..."
    if pgrep -x "borders" > /dev/null 2>&1; then
        info "Borders is already running"
    elif brew services list 2>/dev/null | grep -q "borders.*started"; then
        info "Borders service already started"
    else
        info "Starting borders service..."
        timeout 5 brew services start borders >/dev/null 2>&1 && info "Borders service started" || warning "Could not start borders service (optional)"
    fi
    info "DEBUG: Borders service check completed"
    
    # Start AeroSpace (optional - it will auto-start on login due to config)
    info "DEBUG: Starting AeroSpace check..."
    info "Checking AeroSpace..."
    if pgrep -x "AeroSpace" > /dev/null 2>&1; then
        info "AeroSpace is already running"
    else
        info "AeroSpace will start automatically - skipping manual launch"
    fi
    info "DEBUG: AeroSpace check completed"
    
    info "DEBUG: Displaying shortcuts..."
    info "AeroSpace shortcuts:"
    info "  Alt+semicolon: Service mode"
    info "  Alt+h/j/k/l: Focus windows"
    info "  Alt+Shift+h/j/k/l: Move windows"
    info "  Alt+1-0: Switch workspaces"
    info "  Alt+Shift+1-0: Move window to workspace"
    info "  Alt+f: Fullscreen"
    info "  Alt+s/v: Split horizontal/vertical"
    info "DEBUG: Shortcuts displayed"
    
    info "DEBUG: AeroSpace module completing..."
    success "AeroSpace configuration complete"
    info "DEBUG: AeroSpace module completed successfully"
}