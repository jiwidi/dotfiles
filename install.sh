#!/usr/bin/env zsh

set -e

# Colors for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m' # No Color

# Dotfiles directory
readonly DOTFILES_DIR="$(cd "$(dirname "${(%):-%N}")" && pwd)"
export DOTFILES_DIR

# Source utilities
source "${DOTFILES_DIR}/lib/utils.sh"

# Available modules
readonly MODULES=(
    "macos"
    "git"
    "aerospace"
    "bat"
    "exa"
    "fd"
    "fzf"
    "htop"
    "sketchybar"
    "starship"
    "system"
    "terminal"
)

main() {
    print_header "🚀 Dotfiles Installation"
    
    # Check if we're on macOS
    if [[ "$(uname)" != "Darwin" ]]; then
        error "This dotfiles setup is designed for macOS only"
        exit 1
    fi
    
    # Check for required commands
    check_requirements
    
    # Backup existing configurations
    backup_existing_configs
    
    # Install modules
    if [[ $# -eq 0 ]]; then
        # Install all modules
        for module in "${MODULES[@]}"; do
            install_module "$module"
        done
    else
        # Install specific modules
        for module in "$@"; do
            if [[ " ${MODULES[*]} " =~ " ${module} " ]]; then
                install_module "$module"
            else
                warning "Unknown module: $module"
                info "Available modules: ${MODULES[*]}"
            fi
        done
    fi
    
    print_success "✅ Dotfiles installation complete!"
    info "Please restart your terminal or run 'exec \$SHELL' to apply changes"
}

check_requirements() {
    info "Checking requirements..."
    
    # Check for Homebrew
    if ! command -v brew &> /dev/null; then
        warning "Homebrew not found. Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    
    success "Requirements check complete"
}

backup_existing_configs() {
    info "Creating backup of existing configurations..."
    
    local backup_dir="${HOME}/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
    
    # List of config files/directories to backup
    local configs=(
        ".config/aerospace"
        ".config/bat"
        ".config/htop"
        ".config/sketchybar"
        ".config/starship"
        ".gitconfig"
        ".gitignore_global"
        ".bashrc"
        ".bash_profile"
        ".zshrc"
    )
    
    mkdir -p "$backup_dir"
    
    local path
    for config in "${configs[@]}"; do
        path="${HOME}/${config}"
        if [[ -e "$path" ]]; then
            cp -r "$path" "$backup_dir/" 2>/dev/null || true
        fi
    done
    
    if [[ -n "$(ls -A "$backup_dir" 2>/dev/null)" ]]; then
        success "Backup created at: $backup_dir"
    else
        command rm -rf "$backup_dir" 2>/dev/null || /bin/rm -rf "$backup_dir"
    fi
}

install_module() {
    local module="$1"
    local module_script="${DOTFILES_DIR}/modules/${module}.sh"
    
    if [[ ! -f "$module_script" ]]; then
        error "Module script not found: $module_script"
        return 1
    fi
    
    print_header "Installing $module"
    
    # Source the module script and run install function
    source "$module_script"
    
    if declare -f "install_${module}" > /dev/null; then
        "install_${module}"
        success "$module installed successfully"
    else
        error "Install function not found for module: $module"
        return 1
    fi
}

# Show usage if --help is passed
if [[ "$1" == "--help" ]] || [[ "$1" == "-h" ]]; then
    echo "Usage: $0 [module1] [module2] ..."
    echo ""
    echo "Available modules:"
    printf "  %s\n" "${MODULES[@]}"
    echo ""
    echo "If no modules are specified, all modules will be installed."
    exit 0
fi

main "$@"