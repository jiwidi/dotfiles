#!/usr/bin/env zsh

# Tool configurations for modern CLI tools

# === exa (better ls) ===
if command -v exa > /dev/null 2>&1; then
    alias ls="exa"
    alias ll="exa -l"
    alias la="exa -la"
    alias lt="exa --tree"
    alias l="exa -lah"
    alias ltr="exa -lah --sort=modified"
    alias tree="exa --tree"
fi

# === bat (better cat) ===
if command -v bat > /dev/null 2>&1; then
    alias cat="bat"
    alias less="bat"
    
    # Use bat as manpager
    export MANPAGER="sh -c 'col -bx | bat -l man -p'"
    export MANROFFOPT="-c"
fi

# === fd (better find) ===
if command -v fd > /dev/null 2>&1; then
    alias find="fd"
fi

# === fzf (fuzzy finder) ===
if command -v fzf > /dev/null 2>&1; then
    # Dracula theme colors
    export FZF_DEFAULT_OPTS="--color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9 --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9 --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6 --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4"

    # Use fd as default finder if available
    if command -v fd > /dev/null 2>&1; then
        export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git"
        export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
        export FZF_ALT_C_COMMAND="fd --type d --hidden --follow --exclude .git"
    fi
fi