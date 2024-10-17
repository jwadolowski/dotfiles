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
else
  echo "brew is already installed"
fi

brew bundle install
