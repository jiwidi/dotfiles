#!/usr/bin/env zsh

# Common utilities for dotfiles installation

# Colors (only define if not already defined)
if [[ -z "$RED" ]]; then
    readonly RED='\033[0;31m'
    readonly GREEN='\033[0;32m'
    readonly YELLOW='\033[1;33m'
    readonly BLUE='\033[0;34m'
    readonly PURPLE='\033[0;35m'
    readonly CYAN='\033[0;36m'
    readonly NC='\033[0m' # No Color
fi

# Logging functions
info() {
    printf "${BLUE}ℹ${NC} %s\n" "$*"
}

success() {
    printf "${GREEN}✓${NC} %s\n" "$*"
}

warning() {
    printf "${YELLOW}⚠${NC} %s\n" "$*"
}

error() {
    printf "${RED}✗${NC} %s\n" "$*" >&2
}

debug() {
    if [[ "${DEBUG_MODE:-false}" == "true" ]]; then
        printf "${CYAN}🔍${NC} %s\n" "$*"
    fi
}

print_header() {
    printf "\n${PURPLE}%s${NC}\n" "$*"
    printf "${PURPLE}%s${NC}\n" "$(printf '=%.0s' $(seq 1 ${#1}))"
}

print_success() {
    printf "\n${GREEN}%s${NC}\n" "$*"
}

# Check if command exists
has_command() {
    command -v "$1" &> /dev/null
}

# Install Homebrew package if not already installed
brew_install() {
    local package="$1"
    local cask="${2:-false}"
    
    if [[ "$cask" == "true" ]]; then
        if ! brew list --cask "$package" &> /dev/null; then
            info "Installing $package (cask)..."
            brew install --cask "$package"
        else
            info "$package (cask) already installed"
        fi
    else
        if ! brew list "$package" &> /dev/null; then
            info "Installing $package..."
            brew install "$package"
        else
            info "$package already installed"
        fi
    fi
}

# Create symlink with backup
create_symlink() {
    local source="$1"
    local target="$2"
    
    # Create target directory if it doesn't exist
    mkdir -p "$(dirname "$target")"
    
    # If target exists and is not a symlink, back it up
    if [[ -e "$target" && ! -L "$target" ]]; then
        local backup="${target}.backup.$(date +%Y%m%d_%H%M%S)"
        warning "Backing up existing $target to $backup"
        mv "$target" "$backup"
    fi
    
    # Remove existing symlink
    [[ -L "$target" ]] && rm "$target"
    
    # Create symlink
    ln -sf "$source" "$target"
    success "Linked $source → $target"
}

# Create directory if it doesn't exist
ensure_dir() {
    local dir="$1"
    [[ ! -d "$dir" ]] && mkdir -p "$dir"
}

# Add line to file if it doesn't exist
add_to_file() {
    local line="$1"
    local file="$2"
    
    if [[ ! -f "$file" ]] || ! grep -Fxq "$line" "$file"; then
        echo "$line" >> "$file"
        success "Added to $file: $line"
    fi
}

# Source file in shell config
source_in_shell() {
    local source_line="$1"
    local shell_config
    
    # Prioritize zsh (default on macOS), then bash
    if [[ -n "$ZSH_VERSION" ]] || [[ "$SHELL" == */zsh ]] || [[ ! -n "$BASH_VERSION" ]]; then
        shell_config="$HOME/.zshrc"
    elif [[ "$SHELL" == */bash ]]; then
        shell_config="$HOME/.bashrc"
        # Also add to .bash_profile for macOS
        add_to_file "$source_line" "$HOME/.bash_profile"
    else
        # Default to zsh on macOS
        shell_config="$HOME/.zshrc"
    fi
    
    add_to_file "$source_line" "$shell_config"
}

# Setup optimized shell configuration
setup_optimized_shell() {
    info "Setting up optimized shell configuration..."
    
    # Create optimized .zshrc that sources directly from dotfiles
    local zshrc_source="$DOTFILES_DIR/configs/shell/zshrc"
    
    if [[ ! -f "$zshrc_source" ]]; then
        error "Optimized zshrc not found at $zshrc_source"
        return 1
    fi
    
    # Backup existing .zshrc if it exists and is not our optimized version
    if [[ -f "$HOME/.zshrc" ]] && ! grep -q "Optimized dotfiles zshrc" "$HOME/.zshrc"; then
        local backup="$HOME/.zshrc.backup.$(date +%Y%m%d_%H%M%S)"
        warning "Backing up existing .zshrc to $backup"
        mv "$HOME/.zshrc" "$backup"
    fi
    
    # Create symlink to optimized zshrc
    create_symlink "$zshrc_source" "$HOME/.zshrc"
    
    success "Optimized shell configuration linked"
}

# Check if running on macOS
is_macos() {
    [[ "$(uname)" == "Darwin" ]]
}

# Get macOS version
macos_version() {
    sw_vers -productVersion
}

# Ask user for confirmation
confirm() {
    local message="$1"
    local response
    
    printf "${YELLOW}❓${NC} %s (y/N): " "$message"
    read -r response
    [[ "$response" =~ ^[Yy]$ ]]
}

# Run command with error handling
run_cmd() {
    local cmd="$*"
    info "Running: $cmd"
    
    if eval "$cmd"; then
        success "Command succeeded: $cmd"
    else
        error "Command failed: $cmd"
        return 1
    fi
}

# Download file if it doesn't exist
download_if_missing() {
    local url="$1"
    local target="$2"
    
    if [[ ! -f "$target" ]]; then
        info "Downloading $url → $target"
        curl -fsSL "$url" -o "$target"
        success "Downloaded $target"
    else
        info "$target already exists"
    fi
}