# dotfiles

This repository includes all my configuration files.

## Usage

Suggested execution order:

```shell
# Install homebrew and all the packages listed in the Brewfile
#
# It cannot be done via Taskfile.yaml simply because task CLI has to be installed first
$ ./init.sh

# Install Zim Framework (zimfw)
$ task zimfw

# Deploy dotfiles with stow (typical use case - deployment from scratch)
$ task restow

# Deploy dotfiles with stow (usually used during consequtive runs)
$ task stow

# Install bat themes
$ task bat

# (Optional step) Sync Brewfile
$ task brewfile
```

## Noteworthy facts

`stow`'s `--adapt` flag is used to set all the symlinks up. If given file exists in target location (but isn't managed by `stow` yet) then `stow` will move it to this repository and configure the symlink afterwards. As a result some unwanted changes may show up here. `task restow` was introduced to resolve that.

## Alfred customizations

Alfred settings get synced through Dropbox that should be enough to set everything up, however just in case here's a list of my customizations:

1. Instruct Alfred to use iTerm2 instead of a built-in Terminal app: [link](https://github.com/vitorgalvao/custom-alfred-iterm-scripts)
2. Configure Zoxide integration: [link](https://github.com/yihou/alfred-zoxide)
3. Install Catppuccin themes: [link](https://github.com/catppuccin/alfred)
4. Configure 1Password integration: [link](https://alfred.app/workflows/alfredapp/1password/)
5. Add custom web searches if needed
