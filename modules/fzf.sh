#!/usr/bin/env zsh

# fzf (fuzzy finder) configuration

source "$(dirname "${(%):-%N}")/../lib/utils.sh"
source "$(dirname "${(%):-%N}")/../lib/brew.sh"

install_fzf() {
    info "Installing fzf..."
    
    # Install fzf via Homebrew
    brew_install "fzf"
    
    # Configure fzf with Dracula theme colors
    local fzf_config='
# fzf configuration with Dracula theme
export FZF_DEFAULT_OPTS="--color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9 --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9 --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6 --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4"

# Use fd as default finder if available
if command -v fd > /dev/null 2>&1; then
    export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git"
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
fi

# Alt+C to change directory
export FZF_ALT_C_COMMAND="fd --type d --hidden --follow --exclude .git"
'
    
    # Add fzf configuration to shell config
    local config_file="${HOME}/.fzf_config"
    echo "$fzf_config" > "$config_file"
    
    # Source in shell configuration
    source_in_shell "[ -f ~/.fzf_config ] && source ~/.fzf_config"
    
    # Install shell integration
    if [[ -f "/opt/homebrew/opt/fzf/install" ]]; then
        yes | /opt/homebrew/opt/fzf/install --completion --key-bindings --no-update-rc
    elif [[ -f "/usr/local/opt/fzf/install" ]]; then
        yes | /usr/local/opt/fzf/install --completion --key-bindings --no-update-rc
    fi
    
    success "fzf configuration complete"
}