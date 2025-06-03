#!/usr/bin/env zsh

# Optimized system utility functions and configurations

source "$(dirname "${(%):-%N}")/../lib/utils.sh"
source "$(dirname "${(%):-%N}")/../lib/brew.sh"

install_system() {
    info "Installing system utilities..."
    
    # Install useful system tools
    install_system_tools
    
    # Set up optimized shell configuration
    setup_optimized_shell
    
    # Set up shell configurations
    setup_shell_config
    
    # Set zsh as default shell
    setup_default_shell
    
    success "System utilities configuration complete"
}

install_system_tools() {
    info "Installing system tools..."
    
    # Install essential command line tools
    local tools=(
        "curl"
        "wget"
        "jq"
        "tree"
        "watch"
        "tldr"
        "the_silver_searcher"  # ag
        "ripgrep"             # rg
        "lsof"
    )
    
    for tool in "${tools[@]}"; do
        brew_install "$tool"
    done
}

setup_shell_config() {
    info "Setting up shell configurations..."
    
    # Ensure directories exist
    debug "Creating projects directory..."
    local projects_dir="${HOME}/projects/github"
    debug "Projects dir: $projects_dir"
    if [[ ! -d "$projects_dir" ]]; then
        debug "Directory doesn't exist, creating..."
        mkdir -p "$projects_dir" 2>/dev/null || {
            warning "Could not create directory: $projects_dir"
        }
        debug "Directory created successfully"
    else
        debug "Directory already exists"
    fi
    debug "Projects directory setup completed"
    
    # Create .inputrc for better readline behavior
    debug "Creating .inputrc file..."
    cat > "${HOME}/.inputrc" << 'EOF'
# Better readline behavior
set completion-ignore-case on
set completion-map-case on
set show-all-if-ambiguous on
set show-all-if-unmodified on
set visible-stats on
set page-completions off
set completion-query-items 200

# History search
"\e[A": history-search-backward
"\e[B": history-search-forward

# Better word navigation
"\e[1;5C": forward-word
"\e[1;5D": backward-word
EOF
    debug ".inputrc file created"
    
    # Create .hushlogin to suppress login message
    debug "Creating .hushlogin file..."
    touch "${HOME}/.hushlogin"
    debug ".hushlogin file created"
    
    debug "shell config setup completing..."
    success "Shell configurations set up"
    debug "shell config setup completed"
}

setup_default_shell() {
    info "Setting up default shell..."
    
    # Check current shell
    debug "Checking current shell..."
    local current_shell="$(dscl . -read /Users/$(whoami) UserShell | cut -d' ' -f2)"
    debug "Current shell: $current_shell"
    
    # Check if zsh is available
    local zsh_path="/bin/zsh"
    if [[ ! -x "$zsh_path" ]]; then
        # Try Homebrew zsh location
        zsh_path="/opt/homebrew/bin/zsh"
        if [[ ! -x "$zsh_path" ]]; then
            # Try standard Homebrew location
            zsh_path="/usr/local/bin/zsh"
            if [[ ! -x "$zsh_path" ]]; then
                warning "zsh not found, keeping current shell: $current_shell"
                return 0
            fi
        fi
    fi
    debug "Found zsh at: $zsh_path"
    
    # Check if zsh is already the default
    if [[ "$current_shell" == "$zsh_path" ]]; then
        info "zsh is already the default shell"
        return 0
    fi
    
    # Ensure zsh is in /etc/shells
    debug "Checking if zsh is in /etc/shells..."
    if ! grep -q "^$zsh_path$" /etc/shells 2>/dev/null; then
        info "Adding zsh to /etc/shells..."
        echo "$zsh_path" | sudo tee -a /etc/shells >/dev/null
        debug "zsh added to /etc/shells"
    else
        debug "zsh already in /etc/shells"
    fi
    
    # Change default shell
    if confirm "Change default shell from $current_shell to $zsh_path?"; then
        info "Changing default shell to zsh..."
        if chsh -s "$zsh_path"; then
            success "Default shell changed to zsh"
            info "Please restart your terminal or run 'exec \$SHELL' to apply changes"
        else
            warning "Failed to change default shell. You may need to run: chsh -s $zsh_path"
        fi
    else
        info "Keeping current shell: $current_shell"
    fi
    
    debug "default shell setup completed"
}