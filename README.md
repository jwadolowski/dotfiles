# dotfiles

This repository includes all my configuration files.

## Usage

Suggested execution order:

```shell
# Install homebrew and all the packages listed in the Brewfile
$ task homebrew

# Install Zim Framework (zimfw)
$ task zimfw

# Deploy dotfiles with stow
$ task stow

# Install bat themes
$ task bat

# (Optional step) Sync Brewfile
$ task brewfile
```

## Alfred customizations

Alfred settings get synced via Dropbox which should be enough to set everything up, however just in case here's a list of my customizations:

1. Instruct Alfred to use iTerm2 instead of a built-in Terminal app: [link](https://github.com/vitorgalvao/custom-alfred-iterm-scripts)
2. Configure Zoxide integration: [link](https://github.com/yihou/alfred-zoxide)
3. Install Catppuccin themes: [link](https://github.com/catppuccin/alfred)
4. Configure 1Password integration: [link](https://alfred.app/workflows/alfredapp/1password/)
5. Add custom web searches if needed
