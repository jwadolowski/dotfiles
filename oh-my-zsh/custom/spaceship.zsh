# -----------------------------------------------------------------------------
# Order
# -----------------------------------------------------------------------------
SPACESHIP_PROMPT_ORDER=(
  # user          # Username section
  dir           # Current directory section
  # host          # Hostname section
  git           # Git section (git_branch + git_status)
  # hg            # Mercurial section (hg_branch  + hg_status)
  # package       # Package version
  # node          # Node.js section
  # ruby          # Ruby section
  # elixir        # Elixir section
  # xcode         # Xcode section
  # swift         # Swift section
  golang        # Go section
  # php           # PHP section
  rust          # Rust section
  # haskell       # Haskell Stack section
  # julia         # Julia section
  docker        # Docker section
  aws           # Amazon Web Services section
  venv          # virtualenv section
  # conda         # conda virtualenv section
  # pyenv         # Pyenv section
  # dotnet        # .NET section
  # ember         # Ember.js section
  kubecontext   # Kubectl context section
  terraform     # Terraform workspace section
  exec_time     # Execution time
  time          # Time stamps section
  line_sep      # Line break
  # battery       # Battery level and status
  # vi_mode       # Vi-mode indicator
  jobs          # Background jobs indicator
  exit_code     # Exit code section
  char          # Prompt character
)

# -----------------------------------------------------------------------------
# Prompt
# -----------------------------------------------------------------------------
SPACESHIP_PROMPT_FIRST_PREFIX_SHOW=true

# -----------------------------------------------------------------------------
# Char
# -----------------------------------------------------------------------------
SPACESHIP_CHAR_COLOR_SECONDARY=magenta

# -----------------------------------------------------------------------------
# Time
# -----------------------------------------------------------------------------
SPACESHIP_TIME_SHOW=true
SPACESHIP_TIME_PREFIX=
SPACESHIP_TIME_FORMAT="[%*]"
SPACESHIP_TIME_COLOR=white

# -----------------------------------------------------------------------------
# Dir
# -----------------------------------------------------------------------------
SPACESHIP_DIR_COLOR=blue
SPACESHIP_DIR_PREFIX="# "
SPACESHIP_DIR_TRUNC=0

# -----------------------------------------------------------------------------
# Git
# -----------------------------------------------------------------------------
SPACESHIP_GIT_BRANCH_COLOR=yellow

# -----------------------------------------------------------------------------
# Execution time
# -----------------------------------------------------------------------------
SPACESHIP_EXEC_TIME_SHOW=false
