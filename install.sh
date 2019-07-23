#!/usr/bin/env bash

set -o errexit
# errtrace is required to handle ERR trap correctly
#
# Further reading: https://stackoverflow.com/a/35800451/6802186
set -o errtrace
set -o pipefail
set -o nounset

# -----------------------------------------------------------------------------
# Constants
# -----------------------------------------------------------------------------
declare -r CONFIG_ROOT_DIR="${HOME}/.config"
declare -r OH_MY_ZSH_ROOT_DIR="${HOME}/.oh-my-zsh"

# -----------------------------------------------------------------------------
# Packages/plugins
# -----------------------------------------------------------------------------
OH_MY_ZSH_PLUGINS=(
    https://github.com/zsh-users/zsh-completions
    https://github.com/zsh-users/zsh-syntax-highlighting
)

BREW_PACKAGES=(
    alexjs
    bat
    coreutils
    ctags
    diff-so-fancy
    fd
    fzf
    git
    glances
    hadolint
    htop
    jq
    jsonlint
    ncdu
    neovim
    prettier
    prettyping
    pstree
    python
    python2
    ripgrep
    shellcheck
    shfmt
    terraform@0.11
    tflint
    tldr
    tree
    vale
    watch
    wget
    yamllint
    zsh
)

BREW_CASK_PACKAGES=(
    adoptopenjdk8
    firefox
    font-hack-nerd-font
    google-chrome
    iterm2
    spectacle
    sourcetree
)

GEM_PACKAGEs=()

# -----------------------------------------------------------------------------
# Colors
# -----------------------------------------------------------------------------
declare -r RED_COLOR='\033[0;31m'
declare -r YELLOW_COLOR='\033[0;33m'
declare -r BLUE_COLOR='\033[0;34m'
declare -r NO_COLOR='\033[0m'

# -----------------------------------------------------------------------------
# Utils
# -----------------------------------------------------------------------------
function info_log() {
    echo -e "[${BLUE_COLOR}INFO${NO_COLOR}] [$(date -R)] $1"
}

function warn_log() {
    echo -e "[${YELLOW_COLOR}WARN${NO_COLOR}] [$(date -R)] $1"
}

function error_log() {
    echo -e "[${RED_COLOR}ERROR${NO_COLOR}] [$(date -R)] $1"
}

function output_separator() {
    echo -e "---"
}

function install_oh_my_zsh_plugin() {
    plugin_name=$(basename "${1}")
    plugin_dir="${OH_MY_ZSH_ROOT_DIR}/custom/plugins/${plugin_name}"

    if [[ ! -d ${plugin_dir} ]]; then
        info_log "Installing ${plugin_name}..."
        # git clone ${1} ${}
    else
        info_log "${plugin_name} is already installed"
    fi
}

# -----------------------------------------------------------------------------
# brew.sh
# -----------------------------------------------------------------------------
if [[ $(command -v brew) == "" ]]; then
    info_log "Intalling brew..."
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
    info_log "brew is already installed"
fi

output_separator

# -----------------------------------------------------------------------------
# oh-my-zsh
# -----------------------------------------------------------------------------
if [[ ! -d $OH_MY_ZSH_ROOT_DIR ]]; then
    info_log "Installing oh-my-zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
else
    info_log "oh-my-zsh is already installed"
fi

output_separator

# -----------------------------------------------------------------------------
# oh-my-zsh plugins
# -----------------------------------------------------------------------------
for p in "${OH_MY_ZSH_PLUGINS[@]}"; do
    install_oh_my_zsh_plugin "$p"
done

output_separator

# -----------------------------------------------------------------------------
# Deploy ~/.config
# -----------------------------------------------------------------------------
if [[ ! -d $CONFIG_ROOT_DIR ]]; then
    mkdir "$CONFIG_ROOT_DIR"
fi

for d in config/*; do
    config_name=$(basename "${d}")
    target_dir="${CONFIG_ROOT_DIR}/${config_name}"

    info_log "Processing: ${PWD}/config/${config_name} -> ${target_dir}"

    rm -rf "${target_dir}"
    ln -sf "${PWD}/config/${config_name}" "${target_dir}"
done

output_separator

# -----------------------------------------------------------------------------
# $HOME-level configs
# -----------------------------------------------------------------------------
while IFS= read -r -d '' file; do
    filename=$(basename "${file}")

    config_file="${PWD}/${filename}"
    target_file="${HOME}/.${filename}"

    info_log "Processing: ${config_file} -> ${target_file}"
    ln -sf "${config_file}" "${target_file}"
done < <(find -E . -type f -maxdepth 1 -not -iregex "./(\.gitignore|README\.md|install\.sh)$" -print0)

output_separator

# -----------------------------------------------------------------------------
# oh-my-zsh customizations
# -----------------------------------------------------------------------------
while IFS= read -r -d '' file; do
    filename=$(basename "${file}")

    config_file="${PWD}/${file}"
    target_file="${OH_MY_ZSH_ROOT_DIR}/custom/${filename}"

    info_log "Processing: ${config_file} -> ${target_file}"
    ln -sf "${config_file}" "${target_file}"
done < <(find -E oh-my-zsh/custom -type f -maxdepth 1 -iregex ".*\.zsh$" -print0)
