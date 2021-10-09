

Forked from carlos fish dotfiles [dotfiles](https://github.com/caarlos0/dotfiles). This is my personal fork with some minor tweaks/changes.

## Installation

### Dependencies

First, make sure you have all those things installed:

- `git`: to clone the repo
- `curl`: to download some stuff
- `tar`: to extract downloaded stuff
- `fish`: the shell
- `sudo`: some configs may need that

### Install

Setup dependencies first.

Macos

```console
$ brew install fish bat git-delta dog exa fd fzf gh grc kubectx ripgrep starship tmux
```

On Ubuntu:

```console
$ sh -c "$(curl -fsSL https://starship.rs/install.sh)"
$ sudo apt install fish grc fzf exa
```

Then, run these steps:

```console
$ git clone https://github.com/jiwidi/dotfiles.git ~/.dotfiles
$ cd ~/.dotfiles
$ ./script/bootstrap.fish
```

> All changed files will be backed up with a `.backup` suffix.

#### Update

To update, you just need to `git pull` and run the bootstrap script again:

```console
$ cd ~/.dotfiles
$ git pull origin master
$ ./script/bootstrap.fish
```

## Revert

Reverting is not totally automated, but it pretty much consists in removing
the fish config and dotfiles folder, as well as moving back some config files.

**Remove the folders:**

```console
$ rm -rf ~/.dotfiles ~/.config/fish
```

**Some config files were changed, you can find them using `fd`:**

```console
$ fd -e backup -e local -H -E Library -d 3 .
```

And then manually inspect/revert them.

## macOS defaults

You use it by running:

```console
~/.dotfiles/macos/set-defaults.sh
```

And logging out and in again or restart.

## Themes and fonts being used

Theme is **[Dracula](https://draculatheme.com)** and font is **Inconsolata**
Nerd Font.

<!-- ## Screenshots

![screenshot 1][scrn1]

![screenshot 2][scrn2]

[scrn1]: /docs/screenshot1.png
[scrn2]: /docs/screenshot2.png -->
