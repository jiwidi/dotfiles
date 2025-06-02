#!/usr/bin/env zsh

# SketchyBar (status bar) configuration

source "$(dirname "${(%):-%N}")/../lib/utils.sh"
source "$(dirname "${(%):-%N}")/../lib/brew.sh"

install_sketchybar() {
    info "Installing SketchyBar..."
    
    # Check if we're on macOS
    if ! is_macos; then
        warning "SketchyBar is only available on macOS"
        return 0
    fi
    
    # Install SketchyBar
    brew_install "felixkratz/formulae/sketchybar"
    
    # Install required fonts
    install_fonts
    
    # Set up configuration
    setup_sketchybar_config
    
    # Start SketchyBar service
    start_sketchybar
    
    success "SketchyBar configuration complete"
}

install_fonts() {
    info "Installing required fonts..."
    
    # Install Hack Nerd Font
    brew_install "font-hack-nerd-font" true
    
    success "Fonts installed"
}

setup_sketchybar_config() {
    info "Setting up SketchyBar configuration..."
    
    # Create SketchyBar config directory
    info "DEBUG: Creating sketchybar config directories..."
    local sketchybar_config_dir="${HOME}/.config/sketchybar"
    info "DEBUG: Config dir: $sketchybar_config_dir"
    
    # Create main directory
    if [[ ! -d "$sketchybar_config_dir" ]]; then
        info "DEBUG: Creating main directory..."
        mkdir -p "$sketchybar_config_dir" 2>/dev/null || {
            error "Failed to create directory: $sketchybar_config_dir"
            return 1
        }
        info "DEBUG: Main directory created"
    else
        info "DEBUG: Main directory already exists"
    fi
    
    # Create plugins directory
    if [[ ! -d "$sketchybar_config_dir/plugins" ]]; then
        info "DEBUG: Creating plugins directory..."
        mkdir -p "$sketchybar_config_dir/plugins" 2>/dev/null || {
            error "Failed to create directory: $sketchybar_config_dir/plugins"
            return 1
        }
        info "DEBUG: Plugins directory created"
    else
        info "DEBUG: Plugins directory already exists"
    fi
    info "DEBUG: Directories setup completed"
    
    # Copy configuration files
    info "DEBUG: Setting up config files..."
    local config_source_dir="${DOTFILES_DIR}/configs/sketchybar"
    info "DEBUG: Config source dir: $config_source_dir"
    
    # Main config
    info "DEBUG: Linking main config..."
    create_symlink "$config_source_dir/sketchybarrc" "$sketchybar_config_dir/sketchybarrc"
    info "DEBUG: Main config linked"
    
    # Plugins
    info "DEBUG: Setting up plugins..."
    local plugins=(
        "aerospace.sh"
        "front_app.sh"
        "clock.sh"
        "battery.sh"
        "volume.sh"
        "wifi.sh"
        "slack.sh"
        "telegram.sh"
        "weather.sh"
    )
    
    for plugin in "${plugins[@]}"; do
        info "DEBUG: Linking plugin: $plugin"
        create_symlink "$config_source_dir/plugins/$plugin" "$sketchybar_config_dir/plugins/$plugin"
        chmod +x "$sketchybar_config_dir/plugins/$plugin" 2>/dev/null || true
        info "DEBUG: Plugin $plugin linked and made executable"
    done
    
    # Make main config executable
    info "DEBUG: Making main config executable..."
    chmod +x "$sketchybar_config_dir/sketchybarrc" 2>/dev/null || true
    info "DEBUG: Main config made executable"
    
    info "DEBUG: sketchybar config setup completing..."
    success "SketchyBar configuration files linked"
    info "DEBUG: sketchybar config setup completed"
}

start_sketchybar() {
    info "Starting SketchyBar service..."
    
    # Stop any existing SketchyBar process
    killall sketchybar 2>/dev/null || true
    
    # Start SketchyBar service
    brew services start sketchybar || {
        warning "Failed to start SketchyBar service, trying manual start..."
        sketchybar &
    }
    
    # Set up AeroSpace integration if available
    if command -v aerospace > /dev/null 2>&1; then
        info "Setting up AeroSpace integration..."
        
        # Add callback to AeroSpace config for workspace changes
        local aerospace_callback='exec-and-forget sketchybar --trigger aerospace_workspace_change'
        
        info "Add this callback to your AeroSpace config:"
        echo "after-startup-command = ['$aerospace_callback']"
        echo "after-workspace-focused-command = ['$aerospace_callback']"
    fi
    
    success "SketchyBar started"
}