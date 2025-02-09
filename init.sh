#!/usr/bin/env bash

set -o errexit
# errtrace is required to handle ERR trap correctly
#
# Further reading: https://stackoverflow.com/a/35800451/6802186
set -o errtrace
set -o pipefail
set -o nounset

if [[ $(command -v brew) == "" ]]; then
  echo "Intalling brew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # At this stage brew is installed, but not yet initialized therefore not
  # executable in scope of the current shell. Let's temporarily set it up
  # so that 'brew' command can be called.
  #
  # Brew configuration is persisted in zimfw's config file that gets deployed
  # in subseqnet steps.
  eval "$(/opt/homebrew/bin/brew shellenv)"

  # Install core packages (referenced by Taskfile.yaml)
  brew install \
    zsh \
    git \
    starship \
    eza \
    stow \
    go-task \
    bat \
    mise \
    tflint \
    vale
else
  echo "brew is already installed"
fi

# Configure core packages
task zimfw \
  restow \
  bat \
  mise \
  vale \
  tflint

# Some apps require Rosetta to be installed
sudo softwareupdate --install-rosetta --agree-to-license

# Install remaining packages
brew bundle install
