#!/usr/bin/env zsh

# Sets reasonable macOS defaults
# Based on https://github.com/mathiasbynens/dotfiles and other sources

set -e

# Colors for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m' # No Color

info() {
    printf "${BLUE}  ▸${NC} %s\n" "$*"
}

success() {
    printf "${GREEN}  ✓${NC} %s\n" "$*"
}

warning() {
    printf "${YELLOW}  ⚠${NC} %s\n" "$*"
}

# Check if we're on macOS
if [[ "$(uname)" != "Darwin" ]]; then
    echo "This script is for macOS only"
    exit 1
fi

# Ask for administrator password upfront
sudo -v

# Keep sudo alive until the script is finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

echo ""
echo "🛠  Configuring macOS System Preferences"
echo "=================================="

echo ""
echo "📱 General System Settings"
info "Setting dark interface style"
defaults write NSGlobalDomain AppleInterfaceStyle -string "Dark"

info "Setting graphite appearance and highlight color"
defaults write NSGlobalDomain AppleAquaColorVariant -int 6
defaults write NSGlobalDomain AppleHighlightColor -string "0.847059 0.847059 0.862745"

info "Disabling smart quotes and smart dashes (annoying when typing code)"
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

info "Disabling auto-correct"
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

info "Always showing scrollbars"
defaults write NSGlobalDomain AppleShowScrollBars -string "Always"

info "Increasing window resize speed for Cocoa applications"
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001

info "Saving to disk by default (instead of iCloud)"
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

info "Expanding save panel by default"
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true

echo ""
echo "🖱  Mouse & Trackpad"
info "Enabling mouse focus follow pointer"
defaults write com.apple.Terminal FocusFollowsMouse -bool true

info "Setting natural scroll direction to false"
defaults write -g com.apple.swipescrolldirection -bool false

info "Setting trackpad & mouse speed"
defaults write -g com.apple.trackpad.scaling 2
defaults write -g com.apple.mouse.scaling 2

echo ""
echo "🔒 Security & Privacy"
info "Requiring password immediately after sleep or screen saver"
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

info "Disabling the 'Are you sure you want to open this application?' dialog"
defaults write com.apple.LaunchServices LSQuarantine -bool false

echo ""
echo "🗂  Finder"
info "Setting Finder view style to list view"
defaults write com.apple.Finder FXPreferredViewStyle Nlsv

info "Showing external drives and removable media on desktop"
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

info "Showing status bar and path bar"
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder ShowPathbar -bool true

info "Displaying full POSIX path as window title"
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

info "Disabling warning when changing file extension"
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

info "Disabling warning before emptying Trash"
defaults write com.apple.finder WarnOnEmptyTrash -bool false

info "Avoiding creation of .DS_Store files on network volumes"
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

info "Showing the ~/Library folder"
chflags nohidden ~/Library

info "Showing the /Volumes folder"
sudo chflags nohidden /Volumes

echo ""
echo "🏠 Dock & Spaces"
info "Setting Dock icon size to 45 pixels"
defaults write com.apple.dock tilesize -int 45

info "Enabling auto-hide Dock"
defaults write com.apple.dock autohide -bool true

info "Removing auto-hide delay"
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0

info "Disabling Dock launch animations"
defaults write com.apple.dock launchanim -bool false

info "Speeding up Mission Control animations"
defaults write com.apple.dock expose-animation-duration -float 0.1
defaults write com.apple.dock "expose-group-by-app" -bool true

info "Disabling automatic Space rearrangement"
defaults write com.apple.dock mru-spaces -bool false

echo ""
echo "📷 Screenshots"
info "Creating Screenshots directory"
mkdir -p ~/Desktop/Screenshots

info "Setting screenshot location to ~/Desktop/Screenshots"
defaults write com.apple.screencapture location ~/Desktop/Screenshots

echo ""
echo "🔋 Energy & Performance"
info "Speeding up wake from sleep (24 hours standby delay)"
sudo pmset -a standbydelay 86400

info "Disabling hibernation (faster sleep mode)"
sudo pmset -a hibernatemode 0

echo ""
echo "🌐 Safari & Web"
info "Enabling Safari development features (may fail if Safari is running)"
set +e  # Temporarily disable exit on error for Safari settings
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true 2>/dev/null
defaults write com.apple.Safari IncludeDevelopMenu -bool true 2>/dev/null
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true 2>/dev/null
defaults write com.apple.Safari "com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" -bool true 2>/dev/null
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true 2>/dev/null

info "Hiding Safari bookmark bar (may fail if Safari is running)"
defaults write com.apple.Safari ShowFavoritesBar -bool false 2>/dev/null
set -e  # Re-enable exit on error

echo ""
echo "📸 Photos"
info "Preventing Photos from opening when devices are connected"
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true

echo ""
echo "💾 Time Machine"
info "Preventing Time Machine from prompting for new disks"
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

echo ""
echo "🧹 Cleanup"
info "Removing duplicates in 'Open With' menu"
/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister \
    -kill -r -domain local -domain system -domain user

echo ""
echo "🔄 Restarting affected applications"
apps=(
    "Activity Monitor"
    "Address Book"
    "Calendar"
    "Contacts"
    "cfprefsd"
    "Dock"
    "Finder"
    "Mail"
    "Messages"
    "Safari"
    "SystemUIServer"
    "Photos"
)

for app in "${apps[@]}"; do
    if killall "$app" >/dev/null 2>&1; then
        info "Restarted $app"
    fi
done

echo ""
success "macOS configuration complete! 🎉"
echo "Some changes may require a logout/restart to take effect."