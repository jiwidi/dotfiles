# Dotfiles

A clean, modular macOS dotfiles setup with zsh-based installation scripts.

## Features

This dotfiles setup includes configurations for:

- **🔍 fzf** - Fuzzy finder with Dracula theme
- **🪟 AeroSpace** - Tiling window manager with vi-like keybindings  
- **🐱 bat** - Better cat with syntax highlighting
- **📁 exa** - Better ls with colors and icons
- **🔎 fd** - Better find command
- **📝 Git** - Enhanced git configuration with delta and useful functions
- **📊 htop** - System monitor with custom layout
- **🍺 Homebrew** - Enhanced brew wrapper with additional commands
- **🍎 macOS** - Comprehensive system defaults and optimizations
- **📊 SketchyBar** - Custom status bar with system info
- **⭐ Starship** - Cross-shell prompt with git integration
- **🛠 System** - Useful utility functions and shell improvements
- **💻 Terminal** - Custom Terminal.app profile

## Installation

### Quick Install (All Components)

```bash
./install.sh
```

### Selective Install

Install specific components:

```bash
./install.sh git fzf starship
```

### Available Modules

```bash
./install.sh --help
```

## Structure

```
dotfiles/
├── install.sh              # Master install script
├── lib/                    # Shared utilities
│   ├── utils.sh           # Common functions
│   └── brew.sh            # Homebrew management
├── configs/               # Configuration files
│   ├── aerospace/
│   ├── bat/
│   ├── git/
│   ├── htop/
│   ├── sketchybar/
│   ├── starship/
│   └── terminal/
├── scripts/               # Utility scripts
│   ├── system/           # System utility functions
│   └── macos/            # macOS-specific scripts
└── modules/              # Individual install modules
    ├── aerospace.sh
    ├── bat.sh
    ├── exa.sh
    ├── fd.sh
    ├── fzf.sh
    ├── git.sh
    ├── htop.sh
    ├── macos.sh
    ├── sketchybar.sh
    ├── starship.sh
    ├── system.sh
    └── terminal.sh
```

## Features

### Idempotent Installation
All install scripts are idempotent - safe to run multiple times without side effects.

### Backup Protection
Existing configurations are automatically backed up before installation.

### Shell Integration
Configurations are automatically sourced in zsh (with bash compatibility).

### macOS Optimized
Comprehensive macOS system defaults for better performance and usability.

## Key Shortcuts

### AeroSpace (Window Manager)
- `Alt+semicolon` - Service mode
- `Alt+h/j/k/l` - Focus windows (vi-style)
- `Alt+Shift+h/j/k/l` - Move windows
- `Alt+1-0` - Switch workspaces
- `Alt+Shift+1-0` - Move window to workspace
- `Alt+f` - Fullscreen
- `Alt+s/v` - Split horizontal/vertical

### Git Functions
- `cdr` - cd to git repository root
- `gpr` - Push and create pull request
- `gwf` - Switch branch with fzf
- `glog` - Pretty git log with graph

### System Functions
- `e [file/dir]` - Open in editor
- `mkc <dir>` - Create and cd to directory
- `myip` - Show external IP
- `ports <command>` - Port management utility
- `loadenv [file]` - Load environment from .env file

### Brew Functions
- `brew bump` - Update and upgrade all packages
- `brew cleanup-all` - Comprehensive cleanup
- `brewup` - Alias for brew bump
- `brewclean` - Alias for cleanup-all

## Requirements

- macOS (tested on macOS 14+)
- zsh (default shell on macOS)
- Homebrew (will be installed if missing)

## Customization

Each module is self-contained and can be customized independently. Configuration files are in the `configs/` directory and are symlinked to their proper locations.

## Uninstallation

To uninstall, remove the symlinked configurations:

```bash
# Remove symlinks (they point to files in this repo)
rm ~/.gitconfig.local ~/.git_functions ~/.fzf_config
rm -rf ~/.config/aerospace ~/.config/bat ~/.config/htop
rm -rf ~/.config/sketchybar ~/.config/starship

# Remove shell integrations
# Edit your ~/.zshrc to remove the sourced config files
```