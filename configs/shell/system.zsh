#!/usr/bin/env zsh

# System utility functions and configurations

# Source system utility functions directly
[ -f "$DOTFILES_DIR/scripts/system/system_functions.sh" ] && source "$DOTFILES_DIR/scripts/system/system_functions.sh"

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

# Colored output for common commands (ls handled by exa)
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
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# Process management
alias psg="ps aux | grep"
alias topcpu="top -o cpu"
alias topmem="top -o rsize"

# Network utilities
alias ping="ping -c 5"

# Development shortcuts
alias jsonpp="jq ."
alias serve="python3 -m http.server 8000"

# Quick file operations
alias cp="cp -v"
alias mv="mv -v"
alias mkdir="mkdir -pv"

# Safety aliases
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Search shortcuts
if command -v rg > /dev/null 2>&1; then
    alias search="rg"
elif command -v ag > /dev/null 2>&1; then
    alias search="ag"
else
    alias search="grep -r"
fi