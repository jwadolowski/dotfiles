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
  # - fzf's '--bind' approach feels a bit snappier than previous impl: "files=( $(fd | fzf) ); vim -- $files"
  # - nvim is not opened if nothing got selected
  # - '--exec-batch' performs way better than '--exec' (a life-saver for large Git repos - 'realpath' is NOT executed for each found file)
  #
  # Single-file Git repositories require special handling:
  # - first of all, '--select-1' must be removed to rely entirely on key/event bindings (make sure it's not definied in $FZF_DEFAULT_OPTS)
  # - unbind 'one' event (see https://junegunn.github.io/fzf/reference/#one) to prevent nvim from auto opening when fzf-driven search yields a single file
  # - remap the 'one' to 'open in $EDITOR'
  #
  # Ref: https://github.com/junegunn/fzf/discussions/3803#discussioncomment-9485659
  fd \
    --type file \
    --hidden \
    --base-directory $root_dir \
    --exec-batch realpath \
    --relative-to=${PWD} {} |
    fzf \
      --multi \
      --query="$1" \
      --preview "bat --color=always {}" \
      --bind 'change:unbind(one),enter:become("$EDITOR" {+}),one:become("$EDITOR" {})'
}

# -----------------------------------------------------------------------------
# Quick file edit with nvim (current directory)
# -----------------------------------------------------------------------------
function vv() {
  local root_dir="${PWD}"

  fd \
    --type file \
    --hidden \
    --base-directory $root_dir |
    fzf \
      --multi \
      --query="$1" \
      --preview "bat --color=always {}" \
      --bind 'change:unbind(one),enter:become("$EDITOR" {+}),one:become("$EDITOR" {})'
}

# -----------------------------------------------------------------------------
# fzf-flavoured cd replacement
#
# Ref: https://github.com/junegunn/fzf/wiki/examples#changing-directory
# -----------------------------------------------------------------------------
function c() {
  cd "${HOME}/$(
    fd \
      --type directory \
      --hidden \
      --base-directory "${HOME}" |
      fzf \
        --query="$1" \
        --preview "eza --tree --level 2 --color=always --icons=always --no-quotes ${HOME}/{}"
  )"
}

# -----------------------------------------------------------------------------
# Movements within Git repository
# -----------------------------------------------------------------------------
function d() {
  if in_git_repo; then
    base_directory=$(git_top_level)
    cd "${base_directory}/$(
      fd \
        --type directory \
        --hidden \
        --base-directory ${base_directory} |
        fzf \
          --query="$1" \
          --preview "eza --tree --level 2 --color=always --icons=always --no-quotes ${base_directory}/{}"
    )"
  else
    echo "Not in Git repository!"
  fi
}

function gr() {
  in_git_repo && cd $(git_top_level) || echo "Not in Git repository!"
}

function gsr() {
  in_git_submodule && cd $(git rev-parse --show-toplevel) || echo "Not in Git submodule!"
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
