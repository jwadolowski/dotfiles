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
# oh-my-zsh
# -----------------------------------------------------------------------------
function upgrade_zsh_plugins {
  wd=$(pwd)
  for plugin in $(find ~/.oh-my-zsh/custom/plugins -type d -iregex ".*\.git" -exec dirname {} \;); do
      info_log "Upgrading ${plugin}"
      cd $plugin
      git pull
  done
  cd $wd
}

# Init zsh-completions
autoload -U compinit && compinit

# -----------------------------------------------------------------------------
# Quick file edit with NVIM
#
# https://github.com/junegunn/fzf/wiki/examples#opening-files
# -----------------------------------------------------------------------------

# edit any file
function e() {
  local files
  IFS=$'\n' files=$(fd --type file --follow --hidden . $HOME | fzf --query="$1" --multi --select-1 --exit-0 --preview 'bat --style=numbers --color=always {}')
  [[ -n "$files" ]] && ${EDITOR:-vim} "${files[@]}"
}

# edit file within current directory
function v() {
  local files
  IFS=$'\n' files=$(fd --type file --follow --hidden | fzf --query="$1" --multi --select-1 --exit-0 --preview 'bat --style=numbers --color=always {}')
  [[ -n "$files" ]] && ${EDITOR:-vim} "${files[@]}"
}

# -----------------------------------------------------------------------------
# fzf cd replacement
#
# https://github.com/junegunn/fzf/wiki/examples#changing-directory
# -----------------------------------------------------------------------------
function c() {
  local dir
  dir=$(fd --type directory --follow . $HOME | fzf --query="$1" --no-multi --select-1 --exit-0) && cd "$dir"
}

# -----------------------------------------------------------------------------
# Brew helpers
#
# https://github.com/junegunn/fzf/wiki/examples#homebrew
# -----------------------------------------------------------------------------
function bi() {
  # local inst=$(brew search | fzf -m)

  # if [[ $inst ]]; then
  #   for prog in $(echo $inst);
  #   do; brew install $prog; done;
  #   fi
  local token
  token=$(brew search | fzf-tmux --query="$1" +m --preview 'brew info {}')

  if [ "x$token" != "x" ]; then
    brew install $token
  fi
}

function bci() {
  local token
  token=$(brew search --casks | fzf-tmux --query="$1" +m --preview 'brew cask info {}')

  if [ "x$token" != "x" ]; then
    brew cask install $token
  fi
}
