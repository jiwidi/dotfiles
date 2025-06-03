#!/usr/bin/env zsh

# Git configuration and functions

# Source git utility functions directly
[ -f "$DOTFILES_DIR/scripts/system/git_functions.sh" ] && source "$DOTFILES_DIR/scripts/system/git_functions.sh"

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