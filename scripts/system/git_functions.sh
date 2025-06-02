#!/usr/bin/env zsh

# Git utility functions

# cd to the top level directory of the git repository
cdr() {
    local git_root
    git_root=$(git rev-parse --show-toplevel 2>/dev/null)
    if [[ -n "$git_root" ]]; then
        cd "$git_root" || return 1
    else
        echo "Not in a git repository" >&2
        return 1
    fi
}

# git push and create pull request
gpr() {
    if git push origin HEAD; then
        if command -v gh > /dev/null 2>&1; then
            gh pr create --web || gh pr view --web
        else
            echo "gh CLI not available. Please install GitHub CLI for PR functionality."
        fi
    fi
}

# create semantic version tag and push (requires svu)
gtn() {
    if ! command -v svu > /dev/null 2>&1; then
        echo "svu not found. Install with: go install github.com/caarlos0/svu@latest"
        return 1
    fi
    
    local next_tag
    next_tag=$(svu n --force-patch-increment)
    
    if [[ -n "$next_tag" ]]; then
        git tag "$next_tag" && svu c
    else
        echo "Failed to generate next tag"
        return 1
    fi
}

# git switch to branch with fzf
gwf() {
    if ! command -v fzf > /dev/null 2>&1; then
        echo "fzf not found. Please install fzf for branch switching."
        return 1
    fi
    
    local branch
    branch=$(git for-each-ref --sort=-committerdate --format='%(refname:short) (%(committerdate:relative))' refs/heads | \
        fzf --reverse --height 35% --nth 1 | \
        awk '{ print $1 }')
    
    if [[ -n "$branch" ]]; then
        git switch "$branch"
    fi
}

# git branch cleanup - delete merged branches
gbc() {
    local main_branch
    main_branch=$(git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@')
    
    echo "Cleaning up merged branches (keeping $main_branch)..."
    git branch --merged "$main_branch" | grep -v "$main_branch" | xargs -n 1 git branch -d
}

# git log with graph
glog() {
    git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit "$@"
}

# git status short
gst() {
    git status --short --branch
}

# Export functions (zsh style)
# Functions are automatically available in zsh when sourced