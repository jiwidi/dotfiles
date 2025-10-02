#!/usr/bin/env zsh

# Tool configurations for modern CLI tools

# === eza (better ls - modern exa replacement) ===
if command -v eza > /dev/null 2>&1; then
    alias ls="eza --icons"
    alias ll="eza --icons -l"
    alias la="eza --icons -la"
    alias lt="eza --icons --tree"
    alias l="eza --icons -lah"
    alias ltr="eza --icons -lah --sort=modified"
    alias tree="eza --icons --tree"
elif command -v exa > /dev/null 2>&1; then
    # Fallback to exa if eza not installed yet
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
    export FZF_DEFAULT_OPTS="--color=fg:#f8f8f2,hl:#bd93f9 --color=fg+:#f8f8f2,hl+:#bd93f9 --color=info:#ffb86c,prompt:#8be9fd,pointer:#ff79c6 --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4"

    # Use fd as default finder if available
    if command -v fd > /dev/null 2>&1; then
        export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git"
        export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
        export FZF_ALT_C_COMMAND="fd --type d --hidden --follow --exclude .git"
    fi
fi

# === zsh-syntax-highlighting ===
# Load syntax highlighting (must be near the end of zshrc)
if [[ -f "/opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
    source "/opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
elif [[ -f "/usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
    source "/usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

# === zsh-autosuggestions ===
# Load autosuggestions
if [[ -f "/opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
    source "/opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
elif [[ -f "/usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
    source "/usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

# Autosuggestions configuration
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#6272a4"  # Dracula comment color
export ZSH_AUTOSUGGEST_STRATEGY=(history completion)