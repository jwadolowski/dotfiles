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
# Extensionless $HOME-level configs
# -----------------------------------------------------------------------------
while IFS= read -r -d '' file; do
    filename=$(basename "${file}")

    config_file="${PWD}/${filename}"
    target_file="${HOME}/.${filename}"

    info_log "Processing: ${config_file} -> ${target_file}"
    ln -sf "${config_file}" "${target_file}"
done < <(find -E . -type f -maxdepth 1 -not -iregex "./(README\.md|install\.sh)$" -print0)

output_separator

# -----------------------------------------------------------------------------
# oh-my-zsh customizations
# -----------------------------------------------------------------------------
while IFS= read -r -d '' file; do
    filename=$(basename "${file}")

    config_file="${PWD}/${filename}"
    target_file="${OH_MY_ZSH_ROOT_DIR}/custom/${filename}"

    info_log "Processing: ${config_file} -> ${target_file}"
    ln -sf "${config_file}" "${target_file}"
done < <(find -E oh-my-zsh/custom/ -type f -maxdepth 1 -iregex ".*\.zsh$" -print0)
