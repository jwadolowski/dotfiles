#!/usr/bin/env bash

set -o errexit
# errtrace is required to handle ERR trap correctly
#
# Further reading: https://stackoverflow.com/a/35800451/6802186
set -o errtrace
set -o pipefail
set -o nounset

# ------------------------------------------------------------------------------
# Colors
# ------------------------------------------------------------------------------
declare -r RED_COLOR='\033[0;31m'
declare -r YELLOW_COLOR='\033[0;33m'
declare -r BLUE_COLOR='\033[0;34m'
declare -r NO_COLOR='\033[0m'

# ------------------------------------------------------------------------------
# Utils
# ------------------------------------------------------------------------------
function info_log() {
    echo -e "[${BLUE_COLOR}INFO${NO_COLOR}] [$(date -R)] $1"
}

function warn_log() {
    echo -e "[${YELLOW_COLOR}WARN${NO_COLOR}] [$(date -R)] $1"
}

function error_log() {
    echo -e "[${RED_COLOR}ERROR${NO_COLOR}] [$(date -R)] $1"
}

# -----------------------------------------------------------------------------
# Deploy ~/.config
# -----------------------------------------------------------------------------
config_root="$HOME/.config"

if [[ ! -d $config_root ]]; then
    mkdir "$config_root"
fi

for d in config/*; do
    config_name=$(basename "${d}")
    target_dir="${config_root}/${config_name}"

    info_log "Processing: ${PWD}/config/${config_name} -> ${target_dir}"

    rm -rf "${target_dir}"
    ln -sf "${PWD}/config/${config_name}" "${target_dir}"
done
