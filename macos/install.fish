#!/usr/bin/env fish
if test (uname) != Darwin
	exit
end

abbr -a airport /System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport
abbr -a afk 'open -a /System/Library/CoreServices/ScreenSaverEngine.app'

set -Ua fish_user_paths /usr/local/sbin

#
# Fixes perf issues completing commands on macOS
# See https://github.com/fish-shell/fish-shell/pull/7365
# Can be removed once Fish 3.2.0 is out
#

function __fish_complete_man; end
funcsave __fish_complete_man

function __fish_describe_command; end
funcsave __fish_describe_command


#Install nice to have programs
brew install --cask stats
brew install --cask rectangle
brew install --cask topnotch
brew install --cask iterm2
brew install --cask telegram-desktop
brew install --cask slack
brew install --cask spotify
brew install --cask maccy
brew install only-switch
brew install btop

if command -qa btop
    abbr -a top 'btop'
end
