#!/usr/bin/env zsh

# System utility functions and configurations

source "$(dirname "${(%):-%N}")/../lib/utils.sh"
source "$(dirname "${(%):-%N}")/../lib/brew.sh"

install_system() {
    info "Installing system utilities..."
    
    # Install useful system tools
    install_system_tools
    
    # Set up system functions
    setup_system_functions
    
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

setup_system_functions() {
    info "Setting up system functions..."
    
    # Link system functions
    local functions_source="${DOTFILES_DIR}/scripts/system/system_functions.sh"
    info "DEBUG: Functions source: $functions_source"
    create_symlink "$functions_source" "${HOME}/.system_functions"
    
    # Create system configuration
    local system_config='
# System utility functions
if [ -f ~/.system_functions ]; then
    source ~/.system_functions
fi

# Useful environment variables
export EDITOR="${EDITOR:-code}"
export VISUAL="$EDITOR"
export PAGER="${PAGER:-less}"

# History configuration (zsh optimized)
export HISTSIZE=10000
export SAVEHIST=10000
export HISTFILE="$HOME/.zsh_history"
setopt HIST_VERIFY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_EXPIRE_DUPS_FIRST
setopt SHARE_HISTORY
setopt EXTENDED_HISTORY

# Less configuration
export LESS="-R -F -X"

# zsh-specific options
setopt AUTO_CD
setopt CORRECT
setopt NO_CASE_GLOB
setopt NUMERIC_GLOB_SORT
setopt EXTENDED_GLOB

# Colored output for common commands
if command -v gls > /dev/null 2>&1; then
    alias ls="gls --color=auto"
elif ls --color=auto &> /dev/null; then
    alias ls="ls --color=auto"
fi

alias grep="grep --color=auto"
alias fgrep="fgrep --color=auto"
alias egrep="egrep --color=auto"

# Useful aliases
alias h="history"
alias j="jobs"
alias c="clear"
alias q="exit"

# Directory navigation
alias md="mkdir -p"
alias rd="rmdir"

# Process management
alias psg="ps aux | grep"
alias topcpu="top -o cpu"
alias topmem="top -o rsize"

# Network utilities
alias ping="ping -c 5"
alias ports="ports"

# Development shortcuts
alias jsonpp="jq ."
alias serve="python3 -m http.server 8000"

# Quick file operations
alias cp="cp -v"
alias mv="mv -v"
alias mkdir="mkdir -pv"

# Search shortcuts
if command -v rg > /dev/null 2>&1; then
    alias search="rg"
elif command -v ag > /dev/null 2>&1; then
    alias search="ag"
else
    alias search="grep -r"
fi
'
    
    # Add system configuration to shell config
    local config_file="${HOME}/.system_config"
    echo "$system_config" > "$config_file"
    
    # Source in shell configuration
    source_in_shell "[ -f ~/.system_config ] && source ~/.system_config"
    
    success "System functions configured"
}

setup_shell_config() {
    info "Setting up shell configurations..."
    
    # Ensure directories exist
    info "DEBUG: Creating projects directory..."
    local projects_dir="${HOME}/projects/github"
    info "DEBUG: Projects dir: $projects_dir"
    if [[ ! -d "$projects_dir" ]]; then
        info "DEBUG: Directory doesn't exist, creating..."
        mkdir -p "$projects_dir" 2>/dev/null || {
            warning "Could not create directory: $projects_dir"
        }
        info "DEBUG: Directory created successfully"
    else
        info "DEBUG: Directory already exists"
    fi
    info "DEBUG: Projects directory setup completed"
    
    # Create .inputrc for better readline behavior
    info "DEBUG: Creating .inputrc file..."
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
    info "DEBUG: .inputrc file created"
    
    # Create .hushlogin to suppress login message
    info "DEBUG: Creating .hushlogin file..."
    touch "${HOME}/.hushlogin"
    info "DEBUG: .hushlogin file created"
    
    info "DEBUG: shell config setup completing..."
    success "Shell configurations set up"
    info "DEBUG: shell config setup completed"
}

setup_default_shell() {
    info "Setting up default shell..."
    
    # Check current shell
    info "DEBUG: Checking current shell..."
    local current_shell="$(dscl . -read /Users/$(whoami) UserShell | cut -d' ' -f2)"
    info "DEBUG: Current shell: $current_shell"
    
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
    info "DEBUG: Found zsh at: $zsh_path"
    
    # Check if zsh is already the default
    if [[ "$current_shell" == "$zsh_path" ]]; then
        info "zsh is already the default shell"
        return 0
    fi
    
    # Ensure zsh is in /etc/shells
    info "DEBUG: Checking if zsh is in /etc/shells..."
    if ! grep -q "^$zsh_path$" /etc/shells 2>/dev/null; then
        info "Adding zsh to /etc/shells..."
        echo "$zsh_path" | sudo tee -a /etc/shells >/dev/null
        info "DEBUG: zsh added to /etc/shells"
    else
        info "DEBUG: zsh already in /etc/shells"
    fi
    
    # Change default shell
    if confirm "Change default shell from $current_shell to $zsh_path?"; then
        info "Changing default shell to zsh..."
        if chsh -s "$zsh_path"; then
            success "Default shell changed to zsh"
            info "Please restart your terminal or log out/in for changes to take effect"
        else
            warning "Failed to change default shell. You may need to run: chsh -s $zsh_path"
        fi
    else
        info "Keeping current shell: $current_shell"
    fi
    
    info "DEBUG: default shell setup completed"
}