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
    debug "Creating config directory..."
    local aerospace_config_dir="${HOME}/.config/aerospace"
    debug "Config dir path: $aerospace_config_dir"
    debug "Checking if directory exists..."
    if [[ ! -d "$aerospace_config_dir" ]]; then
        debug "Directory doesn't exist, creating..."
        mkdir -p "$aerospace_config_dir" 2>/dev/null || {
            error "Failed to create directory: $aerospace_config_dir"
            return 1
        }
        debug "Directory created successfully"
    else
        debug "Directory already exists"
    fi
    debug "Config directory setup completed"
    
    # Copy configuration file
    local config_source="${DOTFILES_DIR}/configs/aerospace/aerospace.toml"
    debug "Config source: $config_source"
    debug "DOTFILES_DIR: $DOTFILES_DIR"
    debug "Checking if source file exists..."
    if [[ ! -f "$config_source" ]]; then
        error "Configuration file not found: $config_source"
        return 1
    fi
    debug "Source file exists, creating symlink..."
    create_symlink "$config_source" "${aerospace_config_dir}/aerospace.toml"
    debug "Symlink created successfully"
    
    # Start borders service (optional)
    debug "Starting borders service check..."
    info "Checking borders service..."
    if pgrep -x "borders" > /dev/null 2>&1; then
        info "Borders is already running"
    elif brew services list 2>/dev/null | grep -q "borders.*started"; then
        info "Borders service already started"
    else
        info "Starting borders service..."
        timeout 5 brew services start borders >/dev/null 2>&1 && info "Borders service started" || warning "Could not start borders service (optional)"
    fi
    debug "Borders service check completed"
    
    # Start AeroSpace (optional - it will auto-start on login due to config)
    debug "Starting AeroSpace check..."
    info "Checking AeroSpace..."
    if pgrep -x "AeroSpace" > /dev/null 2>&1; then
        info "AeroSpace is already running"
    else
        info "AeroSpace will start automatically - skipping manual launch"
    fi
    debug "AeroSpace check completed"
    
    debug "Displaying shortcuts..."
    info "AeroSpace shortcuts:"
    info "  Alt+semicolon: Service mode"
    info "  Alt+h/j/k/l: Focus windows"
    info "  Alt+Shift+h/j/k/l: Move windows"
    info "  Alt+1-0: Switch workspaces"
    info "  Alt+Shift+1-0: Move window to workspace"
    info "  Alt+f: Fullscreen"
    info "  Alt+s/v: Split horizontal/vertical"
    debug "Shortcuts displayed"
    
    debug "AeroSpace module completing..."
    success "AeroSpace configuration complete"
    debug "AeroSpace module completed successfully"
}