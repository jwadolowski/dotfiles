# -----------------------------------------------------------------------------
# Colors
# -----------------------------------------------------------------------------
declare -r RED_COLOR='\033[0;31m'
declare -r YELLOW_COLOR='\033[0;33m'
declare -r BLUE_COLOR='\033[0;34m'
declare -r NO_COLOR='\033[0m'

# -----------------------------------------------------------------------------
# Output logging
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

# -----------------------------------------------------------------------------
# Git utils
# -----------------------------------------------------------------------------
function in_git_repo() {
  git rev-parse --git-dir >/dev/null 2>&1
}

function in_git_submodule() {
  [[ -z $(git rev-parse --show-superproject-working-tree 2>/dev/null) ]] && return 1
  return 0
}

function git_top_level() {
  if in_git_submodule; then
    git rev-parse --show-superproject-working-tree
  else
    git rev-parse --show-toplevel
  fi
}

# -----------------------------------------------------------------------------
# Quick file edit with NVIM
#
# https://github.com/junegunn/fzf/wiki/examples#opening-files
# -----------------------------------------------------------------------------

# edit any file
function e() {
  local file
  IFS=$'\n' file=$(fd --type file --follow --hidden . $HOME | fzf --layout=reverse --query="$1" --preview 'bat --style=numbers --color=always {}')
  [[ -n "$file" ]] && ${EDITOR:-vim} "${file}"
}

# edit file within current directory
function v() {
  local file

  IFS=$'\n' file=$(fd --type file --follow --hidden | fzf --layout=reverse --query="$1" --preview 'bat --style=numbers --color=always {}')

  [[ -n "$file" ]] && ${EDITOR:-vim} "${file}"
}

# edit any file in current Git directory
function vv() {
  local file

  if in_git_repo; then
    base_directory=$(git_top_level)

    IFS=$'\n' file=$(fd --type file --follow --hidden --base-directory ${base_directory} -x realpath --relative-to="${PWD}" {} | fzf --layout=reverse --query="$1" --preview 'bat --style=numbers --color=always {}')
    [[ -n "$file" ]] && ${EDITOR:-vim} "${file}"
  else
    error_log "Not in Git repo!"
  fi
}

# -----------------------------------------------------------------------------
# fzf-flavoured cd replacement
#
# https://github.com/junegunn/fzf/wiki/examples#changing-directory
# -----------------------------------------------------------------------------
function c() {
  local dir
  dir=$(fd --type directory --follow --hidden . $HOME | fzf --layout=reverse --query="$1") && cd "$dir"
}

# Quick helper to go into Neovim custom config directory
function nvc() {
  cd $HOME/.config/nvim
}

# -----------------------------------------------------------------------------
# Movements within within Git dir
# -----------------------------------------------------------------------------
function d() {
  local target_dir

  if in_git_repo; then
    base_directory=$(git_top_level)
    target_dir=$(fd --type directory --follow --hidden --base-directory ${base_directory} | fzf --layout=reverse --query="$1")
    [[ -n $target_dir ]] && cd "${base_directory}/${target_dir}"
  else
    error_log "Not in Git repository!"
  fi
}

function gr() {
  if in_git_repo; then
    cd $(git_top_level)
  else
    error_log "Not in Git repository!"
  fi
}

function gsr() {
  if in_git_submodule; then
    cd $(git rev-parse --show-superproject-working-tree)
  else
    error_log "Not in Git submodule!"
  fi
}

# -----------------------------------------------------------------------------
# Brew helpers
#
# https://github.com/junegunn/fzf/wiki/examples#homebrew
# -----------------------------------------------------------------------------
function bi() {
  local token
  token=$(brew formulae | fzf-tmux --query="$1" +m --layout=reverse --preview 'brew info {}')

  if [ "x$token" != "x" ]; then
    brew install $token
  fi
}

function bci() {
  local token
  token=$(brew search --casks | fzf-tmux --query="$1" +m --layout=reverse --preview 'brew info --cask {}')

  if [ "x$token" != "x" ]; then
    brew install --cask $token
  fi
}

# -----------------------------------------------------------------------------
# delta helpers
# -----------------------------------------------------------------------------
function diff2() {
  delta --side-by-side --syntax-theme 'Enki-Tokyo-Night' "$@"
}

# -----------------------------------------------------------------------------
# yq helpers
# -----------------------------------------------------------------------------
function jty() {
  yq --input-format json --output-format yaml
}

function ytj() {
  yq --input-format yaml --output-format json
}
