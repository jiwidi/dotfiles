#!/usr/bin/env zsh

# Git configuration and functions

source "$(dirname "${(%):-%N}")/../lib/utils.sh"
source "$(dirname "${(%):-%N}")/../lib/brew.sh"

install_git() {
    info "Installing Git configuration..."
    
    # Install git and related tools
    brew_install "git"
    brew_install "git-delta"
    brew_install "gh"  # GitHub CLI
    
    # Set up git configuration
    setup_git_config
    
    # Set up git functions
    setup_git_functions
    
    success "Git configuration complete"
}

setup_git_config() {
    info "Setting up Git configuration..."
    
    # Get user information
    local git_user_name git_user_email
    
    git_user_name=$(git config --global user.name 2>/dev/null)
    git_user_email=$(git config --global user.email 2>/dev/null)
    
    if [[ -z "$git_user_name" ]]; then
        printf "Git user name: "
        read -r git_user_name
        git config --global user.name "$git_user_name"
    fi
    
    if [[ -z "$git_user_email" ]]; then
        printf "Git user email: "
        read -r git_user_email
        git config --global user.email "$git_user_email"
    fi
    
    # Link configuration files
    local git_config_source="$(dirname "${(%):-%N}")/../configs/git/gitconfig"
    local gitignore_source="$(dirname "${(%):-%N}")/../configs/git/gitignore_global"
    local template_source="$(dirname "${(%):-%N}")/../configs/git/git_commit_template"
    
    create_symlink "$git_config_source" "${HOME}/.gitconfig.local"
    create_symlink "$gitignore_source" "${HOME}/.gitignore_global"
    create_symlink "$template_source" "${HOME}/.git_commit_template"
    
    # Include local config in main gitconfig
    git config --global include.path "~/.gitconfig.local"
    
    success "Git configuration files linked"
}

setup_git_functions() {
    info "Setting up Git functions..."
    
    # Create git functions config
    local git_functions_config='
# Git utility functions
if [ -f ~/.git_functions ]; then
    source ~/.git_functions
fi

# Git aliases
alias g="git"
alias ga="git add"
alias gaa="git add --all"
alias gb="git branch"
alias gc="git commit"
alias gcm="git commit -m"
alias gco="git checkout"
alias gd="git diff"
alias gl="git pull"
alias gp="git push"
alias gs="gst"  # uses function from git_functions.sh
alias glog="glog"  # uses function from git_functions.sh
'
    
    # Link git functions
    local functions_source="${DOTFILES_DIR}/scripts/system/git_functions.sh"
    create_symlink "$functions_source" "${HOME}/.git_functions"
    
    # Add git configuration to shell config
    local config_file="${HOME}/.git_config"
    echo "$git_functions_config" > "$config_file"
    
    # Source in shell configuration
    source_in_shell "[ -f ~/.git_config ] && source ~/.git_config"
    
    success "Git functions configured"
}