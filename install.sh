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
    https://github.com/zsh-users/zsh-syntax-highlighting
    https://github.com/supercrabtree/k
)

OH_MY_ZSH_THEMES=(
    https://github.com/denysdovhan/spaceship-prompt
)

BREW_TAPS=(
    homebrew/cask-versions
    fastly/tap
)

BREW_PACKAGES=(
    ag
    alexjs
    awscli
    bat
    certbot
    colordiff
    coreutils
    csvkit
    ctags
    curl-openssl
    diff-so-fancy
    doctl
    dos2unix
    fd
    fdupes
    ffmpeg
    fzf
    git
    git-extras
    glances
    go
    goaccess
    graphviz
    groovy
    hadolint
    helm
    htop
    imagemagick
    iproute2mac
    jq
    jsonlint
    maven
    minio-mc
    mitmproxy
    mtr
    ncdu
    neovim
    oath-toolkit
    packer
    parallel
    pidof
    prettier
    prettyping
    pstree
    python
    ripgrep
    sf-pwgen
    shellcheck
    shfmt
    speedtest-cli
    sslscan
    terraform
    tflint
    tldr
    tree
    vale
    vegeta
    waflyctl
    watch
    wget
    yamllint
    yarn
    youtube-dl
    zsh
)

BREW_CASK_PACKAGES=(
    adobe-acrobat-reader
    adoptopenjdk8
    alfred
    balenaetcher
    brave-browser
    chef-workstation
    docker
    dropbox
    firefox
    font-hack-nerd-font
    font-montserrat
    forticlient
    google-chrome
    iterm2
    joinme
    kap
    keepassxc
    keycastr
    kitematic
    ngrok
    skype
    sourcetree
    spectacle
    spotify
    tunnelblick
    virtualbox
    visual-studio-code
    visualvm
    vlc
    wireshark
    zoomus
)

GEM_PACKAGES=(
    mdl
    knife-block
)

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
        info_log "Installing ${plugin_name} plugin..."
        git clone "${1}" "${plugin_dir}"
    else
        info_log "${plugin_name} plugin is already installed"
    fi
}

function install_oh_my_zsh_theme() {
    theme_name=$(basename "${1}")
    theme_dir="${OH_MY_ZSH_ROOT_DIR}/custom/themes/${theme_name}"

    if [[ ! -d ${theme_dir} ]]; then
        info_log "Installing ${theme_name} theme..."
        git clone "${1}" "${theme_dir}"
    else
        info_log "${theme_name} theme is already installed"
    fi
}

function install_brew_tap() {
    if brew tap | grep -q "${1}"; then
        info_log "${1} tap is already configured"
    else
        info_log "Configuring ${1} brew tap..."
        brew tap "${1}"
    fi
}

function install_ruby_gem() {
    if chef gem list | grep -q "${1}"; then
        info_log "${1} gem is already installed"
    else
        info_log "Installing ${1} gem..."
        chef gem install "${1}"
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

for tap in "${BREW_TAPS[@]}"; do
    install_brew_tap "${tap}"
done

info_log "Installing brew packages..."
# shellcheck disable=SC2086
brew install ${BREW_PACKAGES[*]}

info_log "Installing brew cask packages..."
# shellcheck disable=SC2086
brew cask install ${BREW_CASK_PACKAGES[*]}

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

for plugin in "${OH_MY_ZSH_PLUGINS[@]}"; do
    install_oh_my_zsh_plugin "$plugin"
done

for theme in "${OH_MY_ZSH_THEMES[@]}"; do
    install_oh_my_zsh_theme "$theme"
done

output_separator

# -----------------------------------------------------------------------------
# Ruby gems
# -----------------------------------------------------------------------------
if [[ $(command -v chef) == "" ]]; then
    error_log "Chef Workstation is not installed. Please install it first!"
else
    info_log "Installing Ruby gems"
    for g in "${GEM_PACKAGES[@]}"; do
        install_ruby_gem "${g}"
    done
fi

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

output_separator
