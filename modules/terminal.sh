#!/usr/bin/env zsh

# Terminal.app configuration

source "$(dirname "${(%):-%N}")/../lib/utils.sh"
source "$(dirname "${(%):-%N}")/../lib/brew.sh"

install_terminal() {
    info "Installing Terminal configuration..."
    
    # Check if we're on macOS
    info "DEBUG: Checking if running on macOS..."
    if ! is_macos; then
        warning "Terminal.app configuration is only available on macOS"
        return 0
    fi
    info "DEBUG: macOS check passed"
    
    # Install terminal profile
    info "DEBUG: Setting up terminal profile..."
    setup_terminal_profile
    info "DEBUG: Terminal profile setup completed"
    
    info "DEBUG: terminal module completing..."
    success "Terminal configuration complete"
    info "DEBUG: terminal module completed successfully"
}

setup_terminal_profile() {
    info "Setting up Terminal.app profile..."
    
    info "DEBUG: Setting up terminal profile..."
    local profile_source="${DOTFILES_DIR}/configs/terminal/jiwidi.terminal"
    local profile_name="jiwidi"
    info "DEBUG: Profile source: $profile_source"
    info "DEBUG: DOTFILES_DIR: $DOTFILES_DIR"
    
    if [[ ! -f "$profile_source" ]]; then
        error "Terminal profile not found at $profile_source"
        return 1
    fi
    info "DEBUG: Profile file found"
    
    # Import the terminal profile
    info "Importing Terminal profile: $profile_name"
    open "$profile_source"
    
    # Wait a moment for Terminal to process the import
    sleep 2
    
    # Set as default profile
    if confirm "Set '$profile_name' as default Terminal profile?"; then
        info "Setting default Terminal profile..."
        
        # Use osascript to set the default profile
        osascript -e "
        tell application \"Terminal\"
            set default settings to settings set \"$profile_name\"
            set startup settings to settings set \"$profile_name\"
        end tell
        " 2>/dev/null || {
            warning "Could not set default profile automatically"
            info "Please manually set '$profile_name' as default in Terminal > Preferences > Profiles"
        }
        
        success "Terminal profile '$profile_name' set as default"
    else
        info "Terminal profile imported but not set as default"
        info "You can set it as default in Terminal > Preferences > Profiles"
    fi
    
    # Terminal behavior recommendations
    cat << 'EOF'

📋 Terminal Configuration Tips:
• The profile includes Dracula-inspired colors with SF Mono font
• Consider enabling "Use Option as Meta key" in Terminal preferences
• For best experience with modern terminal tools, ensure your Terminal supports:
  - 256 colors
  - True color (if available)
  - Unicode/UTF-8

EOF
}