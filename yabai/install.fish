#!/usr/bin/env fish
if command -qa brew
    # Installations require many manual steps, here are what commands to use but we will only create symb links.
    # # YABAI
	# brew install koekeishiya/formulae/yabai
    # brew services start yabai

    # echo "
    # # create a new file for writing - visudo uses the vim editor by default.
    # # go read about this if you have no idea what is going on.

    # sudo visudo -f /private/etc/sudoers.d/yabai

    # # input the line below into the file you are editing.
    # #  replace <yabai> with the path to the yabai binary (output of: which yabai).
    # #  replace <user> with your username (output of: whoami).
    # #  replace <hash> with the sha256 hash of the yabai binary (output of: shasum -a 256 $(which yabai)).
    # #   this hash must be updated manually after running brew upgrade.

    # <user> ALL = (root) NOPASSWD: sha256:<hash> <yabai> --load-sa
    # " >> /etc/sudoers
    ln -sf $DOTFILES/yabai/.yabairc ~/.yabairc
    chmod +x ~/.yabairc

    # brew install shkd
    # brew services start skhd
    ln -sf $DOTFILES/yabai/.skhdrc ~/.skhdrc
    chmod +x ~/.skhdrc
end
