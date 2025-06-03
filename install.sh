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

# Available modules with descriptions
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

# Module descriptions
declare -A MODULE_DESCRIPTIONS=(
    ["macos"]="macOS system defaults and tools"
    ["git"]="Git configuration and aliases"
    ["aerospace"]="AeroSpace window manager"
    ["bat"]="Better cat with syntax highlighting"
    ["exa"]="Better ls with colors and icons"
    ["fd"]="Fast find alternative"
    ["fzf"]="Fuzzy finder"
    ["htop"]="System monitor"
    ["sketchybar"]="Status bar for macOS"
    ["starship"]="Cross-shell prompt"
    ["system"]="System utilities and shell setup"
    ["terminal"]="Terminal.app configuration"
)

# Global flags
AUTO_ACCEPT=false
DEBUG_MODE=false

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
        # Install all modules with prompts
        for module in "${MODULES[@]}"; do
            install_module_with_prompt "$module"
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
    info "🔄 Run 'exec zsh' to apply all changes"
    
    # Show benefits
    cat << 'EOF'

🎉 Your dotfiles are now optimized:
• ⚡ Faster shell startup (direct sourcing from dotfiles)
• 🧹 Cleaner home directory (minimal config files)  
• 🔧 Easier maintenance (all configs in dotfiles repo)
• 📁 Better organization (grouped by functionality)

Your ~/.zshrc now sources directly from your dotfiles repository!

EOF
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
        # Backup old dotfiles configs if they exist
        ".system_config"
        ".git_config"
        ".exa_config"
        ".bat_config"
        ".fzf_config"
        ".fd_config"
        ".starship_init"
        ".system_functions"
        ".git_functions"
        ".macos_config"
        ".brew_wrapper"
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

install_module_with_prompt() {
    local module="$1"
    local description="${MODULE_DESCRIPTIONS[$module]}"
    
    # Auto-accept if -y flag is set
    if [[ "$AUTO_ACCEPT" == "true" ]]; then
        install_module "$module"
        return
    fi
    
    # Ask user for confirmation
    if confirm "Install $module ($description)?"; then
        install_module "$module"
    else
        info "Skipping $module installation"
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

# Parse arguments
INSTALL_MODULES=()
while [[ $# -gt 0 ]]; do
    case $1 in
        -y|--yes)
            AUTO_ACCEPT=true
            shift
            ;;
        -d|--debug)
            DEBUG_MODE=true
            export DEBUG_MODE
            shift
            ;;
        -h|--help)
            echo "Usage: $0 [OPTIONS] [module1] [module2] ..."
            echo ""
            echo "🎯 Optimized Dotfiles Installation"
            echo "Clean, fast shell setup with minimal home directory clutter!"
            echo ""
            echo "Options:"
            echo "  -y, --yes      Auto-accept all prompts"
            echo "  -d, --debug    Enable debug output"
            echo "  -h, --help     Show this help message"
            echo ""
            echo "Available modules:"
            for module in "${MODULES[@]}"; do
                printf "  %-12s %s\n" "$module" "${MODULE_DESCRIPTIONS[$module]}"
            done
            echo ""
            echo "If no modules are specified, all modules will be installed with prompts."
            echo "Use -y flag to auto-install all modules without prompts."
            echo "Use -d flag to see detailed debug information."
            exit 0
            ;;
        -*)
            error "Unknown option: $1"
            echo "Use --help for usage information."
            exit 1
            ;;
        *)
            INSTALL_MODULES+=("$1")
            shift
            ;;
    esac
done

main "${INSTALL_MODULES[@]}"