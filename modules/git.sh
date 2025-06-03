#!/usr/bin/env zsh

# Optimized Git configuration and functions

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
    
    # Link configuration files directly from dotfiles
    local git_config_source="$DOTFILES_DIR/configs/git/gitconfig"
    local gitignore_source="$DOTFILES_DIR/configs/git/gitignore_global"
    local template_source="$DOTFILES_DIR/configs/git/git_commit_template"
    
    create_symlink "$git_config_source" "${HOME}/.gitconfig.local"
    create_symlink "$gitignore_source" "${HOME}/.gitignore_global"
    create_symlink "$template_source" "${HOME}/.git_commit_template"
    
    # Include local config in main gitconfig
    git config --global include.path "~/.gitconfig.local"
    
    success "Git configuration files linked"
}