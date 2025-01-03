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
# Quick file edit with nvim
#
# Ref: https://github.com/junegunn/fzf/wiki/examples#opening-files
# -----------------------------------------------------------------------------
function v() {
  local root_dir="${PWD}"

  in_git_repo && root_dir=$(git_top_level)

  # Noteworthy info:
  # - fzf's '--bind' approach feels snappier than previous impl: "files=( $(fd | fzf) ); vim -- $files"
  # - does NOT open neovim if nothing got selected
  # - prefer '--exec-batch' over '--exec' (a life-saver for large Git repos - 'realpath' is NOT executed for each found file)
  fd --type file --hidden --follow --base-directory $root_dir --exec-batch realpath --relative-to=${PWD} {} |
    fzf --multi --query="$1" --preview "bat --color=always {}" --bind 'enter:become(nvim {+})'
}

# -----------------------------------------------------------------------------
# fzf-flavoured cd replacement
#
# Ref: https://github.com/junegunn/fzf/wiki/examples#changing-directory
# -----------------------------------------------------------------------------
function c() {
  local dir
  target_dir=$(
    fd --type directory --follow --hidden --base-directory "${HOME}" |
      fzf --query="$1" --preview "eza --tree --level 2 --color=always --icons=always --no-quotes ${HOME}/{}"
  )
  [[ -n $target_dir ]] && cd "${HOME}/${target_dir}"
}

# -----------------------------------------------------------------------------
# Movements within Git repository
# -----------------------------------------------------------------------------
function d() {
  local target_dir

  if in_git_repo; then
    base_directory=$(git_top_level)
    target_dir=$(
      fd --type directory --follow --hidden --base-directory ${base_directory} |
        fzf --query="$1" --preview "eza --tree --level 2 --color=always --icons=always --no-quotes ${base_directory}/{}"
    )
    [[ -n $target_dir ]] && cd "${base_directory}/${target_dir}"
  else
    echo "Not in Git repository!"
  fi
}

function gr() {
  if in_git_repo; then
    cd $(git_top_level)
  else
    echo "Not in Git repository!"
  fi
}

function gsr() {
  if in_git_submodule; then
    cd $(git rev-parse --show-toplevel)
  else
    echo "Not in Git submodule!"
  fi
}

# -----------------------------------------------------------------------------
# delta
# -----------------------------------------------------------------------------
function diff2() {
  delta --side-by-side "$@"
}

# -----------------------------------------------------------------------------
# neovim
# -----------------------------------------------------------------------------
function nvc() {
  cd $HOME/.config/nvim
}

# -----------------------------------------------------------------------------
# zimfw
# -----------------------------------------------------------------------------
function zpc() {
  ${EDITOR} $HOME/.zim/custom/private/init.zsh
}

# -----------------------------------------------------------------------------
# helm
# -----------------------------------------------------------------------------
function in_helm_chart() {
  test -f Chart.yaml
}

function has_makefile() {
  test -f Makefile
}

function has_helm_errors() {
  local file=$1

  grep --ignore-case --quiet 'error' $file
}

function has_empty_helm_output() {
  local file=$1

  # -s flag meaning: true if file exists and has a size greater than zero
  ! test -s $file
}

function ht() {
  ! in_helm_chart && echo "Not in Helm chart directory!" && exit 1
  ! has_makefile && echo "Makefile not found!" && exit 1

  local stdout_file=$(mktemp --suffix "_stdout.yaml")
  local stderr_file=$(mktemp --suffix "_stderr.txt")
  local editor=${1:-$EDITOR}

  # >| got used to bypass NO_CLOBBER opt
  USE_LOCAL_IMAGE=1 make template 2>|$stderr_file | sed -n '/---/,$p' >|$stdout_file

  # Always use bat in case of any error
  if has_helm_errors $stderr_file || has_empty_helm_output $stdout_file; then
    bat $stderr_file $stdout_file
  else
    ${editor} $stdout_file
  fi

  rm -f $stdout_file $stderr_file
}

alias htv="ht"
alias htb="ht bat"

# -----------------------------------------------------------------------------
# checkov
#
# Terraform plan scanning is pointless until
# https://github.com/bridgecrewio/checkov/issues/5212 is resolved
#
# At the time of writing 'checkov --file tfplan.json
# --repo-root-for-plan-enrichment .' does not respect for_each/count
# meta-arguments which makes it useless
# -----------------------------------------------------------------------------
function checkov() {
  docker run \
    --quiet \
    --tty \
    --volume ${PWD}:/data \
    --workdir /data \
    bridgecrew/checkov \
    --directory /data \
    --output cli \
    --skip-framework terraform_plan \
    --quiet "$@"
}
