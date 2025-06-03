#!/usr/bin/env zsh

# bat (better cat) configuration - optimized

source "$(dirname "${(%):-%N}")/../lib/utils.sh"
source "$(dirname "${(%):-%N}")/../lib/brew.sh"

install_bat() {
    info "Installing bat..."
    brew_install "bat"
    
    # Create bat config directory and file (this is needed)
    local bat_config_dir="${HOME}/.config/bat"
    if [[ ! -d "$bat_config_dir" ]]; then
        mkdir -p "$bat_config_dir"
    fi
    
    # Create bat configuration file
    cat > "${bat_config_dir}/config" << 'EOF'
# bat configuration
--theme="Dracula"
--style="numbers,changes,header"
--wrap="auto"
--pager="less -FR"
EOF
    
    success "bat installed and configured"
}