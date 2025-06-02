#!/usr/bin/env zsh

# System utility functions

# Edit folders/files with preferred editor
e() {
    local target="${1:-.}"
    local editor="${EDITOR:-code}"
    
    if command -v "$editor" > /dev/null 2>&1; then
        "$editor" "$target" > /tmp/editor-log 2>&1 &
    else
        echo "Editor '$editor' not found. Set EDITOR environment variable."
        return 1
    fi
}

# Quick cd into GitHub projects folder
github() {
    cd ~/projects/github/ || {
        echo "GitHub projects directory not found at ~/projects/github/"
        return 1
    }
}

# Quick cd into home directory with optional subdirectory
home() {
    if [[ $# -eq 0 ]]; then
        cd "$HOME" || return 1
    else
        cd "$HOME/$1" || return 1
    fi
}

# Create directory and cd into it
mkc() {
    if [[ $# -eq 0 ]]; then
        echo "Usage: mkc <directory_name>"
        return 1
    fi
    
    mkdir -p "$1" && cd "$1" || return 1
}

# Get external IP address
myip() {
    curl -w '%{stdout}\n' ifconfig.me 2>/dev/null || {
        echo "Failed to get external IP address"
        return 1
    }
}

# Port management utility
ports() {
    case "$1" in
        "ls"|"list")
            lsof -i -n -P
            ;;
        "show")
            if [[ -z "$2" ]]; then
                echo "Usage: ports show <port_number>"
                return 1
            fi
            lsof -i :"$2" | tail -n 1
            ;;
        "pid")
            if [[ -z "$2" ]]; then
                echo "Usage: ports pid <port_number>"
                return 1
            fi
            ports show "$2" | awk '{ print $2; }'
            ;;
        "kill")
            if [[ -z "$2" ]]; then
                echo "Usage: ports kill <port_number>"
                return 1
            fi
            local pid
            pid=$(ports pid "$2")
            if [[ -n "$pid" && "$pid" =~ ^[0-9]+$ ]]; then
                kill -9 "$pid"
                echo "Killed process $pid on port $2"
            else
                echo "No process found on port $2"
                return 1
            fi
            ;;
        *)
            cat << 'EOF'
NAME:
  ports - a tool to easily see what's happening on your computer's ports

USAGE:
  ports [command] [arguments...]

COMMANDS:
  ls, list          list all open ports and the processes running in them
  show <port>       shows which process is running on a given port
  pid <port>        same as show, but prints only the PID
  kill <port>       kill the process running on the given port with kill -9

EXAMPLES:
  ports ls          # List all open ports
  ports show 3000   # Show process on port 3000
  ports kill 3000   # Kill process on port 3000
EOF
            ;;
    esac
}

# Load environment variables from .env file
loadenv() {
    local print_mode=""
    local unload_mode=false
    local env_file=".env"
    
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -h|--help)
                cat << 'EOF'
Usage: loadenv [OPTIONS] [FILE]

Export keys and values from a dotenv file.

Options:
  --help, -h      Show this help message
  --print         Print env keys (export preview)
  --printb        Print keys with surrounding brackets
  --unload, -U    Unexport all keys defined in the dotenv file

Arguments:
  FILE            Path to dotenv file (default: .env)
EOF
                return 0
                ;;
            --print)
                print_mode="print"
                ;;
            --printb)
                print_mode="printb"
                ;;
            -U|--unload)
                unload_mode=true
                ;;
            -*)
                echo "Unknown option: $1" >&2
                return 1
                ;;
            *)
                if [[ -n "$env_file" && "$env_file" != ".env" ]]; then
                    echo "Too many arguments. Only one file argument is allowed." >&2
                    return 1
                fi
                env_file="$1"
                ;;
        esac
        shift
    done
    
    # Check if file exists
    if [[ ! -f "$env_file" ]]; then
        echo "Error: File '$env_file' not found." >&2
        return 1
    fi
    
    local line_number=0
    
    # Process each line in the file
    while IFS= read -r line || [[ -n "$line" ]]; do
        ((line_number++))
        
        # Skip empty lines and comments
        if [[ "$line" =~ ^[[:space:]]*$ ]] || [[ "$line" =~ ^[[:space:]]*# ]]; then
            continue
        fi
        
        # Check if line is a valid key=value pair
        if [[ ! "$line" =~ ^[A-Za-z_][A-Za-z0-9_]*= ]]; then
            echo "Error: invalid declaration (line $line_number): $line" >&2
            return 1
        fi
        
        # Extract key and value
        local key="${line%%=*}"
        local after_equals="${line#*=}"
        local value
        
        # Parse value (handle quotes and comments)
        if [[ "$after_equals" =~ ^\"(.*)\"[[:space:]]*(#.*)?$ ]]; then
            # Double quoted value
            value="${BASH_REMATCH[1]}"
        elif [[ "$after_equals" =~ ^\'(.*)\'[[:space:]]*(#.*)?$ ]]; then
            # Single quoted value
            value="${BASH_REMATCH[1]}"
        elif [[ "$after_equals" =~ ^([^\'\"[:space:]]*)[[:space:]]*(#.*)?$ ]]; then
            # Plain value
            value="${BASH_REMATCH[1]}"
        else
            echo "Error: invalid value (line $line_number): $line" >&2
            return 1
        fi
        
        # Process based on mode
        if [[ "$print_mode" == "print" ]]; then
            echo "$key=$value"
        elif [[ "$print_mode" == "printb" ]]; then
            echo "[$key=$value]"
        elif [[ "$unload_mode" == true ]]; then
            unset "$key"
        else
            export "$key=$value"
        fi
        
    done < "$env_file"
}

# Quick navigation functions
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# Directory listing shortcuts
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Safety aliases
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Export functions (zsh style)
# Functions are automatically available in zsh when sourced