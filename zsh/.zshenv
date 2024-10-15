# ----------------------------------------------------------------------------
# Commons
# ----------------------------------------------------------------------------
export EDITOR="nvim"

# Use US locale settings to keep things consistent across apps/CLIs
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# ----------------------------------------------------------------------------
# Rust
# ----------------------------------------------------------------------------
. "$HOME/.cargo/env"

# -----------------------------------------------------------------------------
# Golang
# -----------------------------------------------------------------------------
export GOPATH="${HOME}/go"
export PATH="${GOPATH}/bin:${PATH}"

# ----------------------------------------------------------------------------
# grep
#
# Do NOT use colors defined by zimfw/utility module
#
# Ref: https://github.com/zimfw/utility
# ----------------------------------------------------------------------------
export GREP_COLOR=""
export GREP_COLORS=""

# ----------------------------------------------------------------------------
# ripgrep command does not look in any predetermined directory for config
#
# Ref: https://github.com/BurntSushi/ripgrep/blob/master/GUIDE.md#configuration-file
# ----------------------------------------------------------------------------
export RIPGREP_CONFIG_PATH="${HOME}/.ripgreprc"

# ----------------------------------------------------------------------------
# azctx displays an error if AZURE_CONFIG_DIR is not explicitly exported
#
# https://github.com/whiteducksoftware/azctx?tab=readme-ov-file#troubleshooting
# ----------------------------------------------------------------------------
export AZURE_CONFIG_DIR=$HOME/.azure

# ----------------------------------------------------------------------------
# FZF
#
# The following FZF_* variables are provided by zimfw/fzf module
#
# - FZF_DEFAULT_COMMAND -> fd
# - FZF_CTRL_T_COMMAND -> FZF_DEFAULT_COMMAND
# - FZF_CTRL_T_OPTS -> bat (preview)
# - FZF_ALT_C_COMMAND -> fd (dead shortcut; I prefer my own 'c' helper func)
#
# Ref: https://github.com/zimfw/fzf
# ----------------------------------------------------------------------------
export FZF_DEFAULT_OPTS="--height 40% \
  --select-1 \
  --exit-0 \
  --highlight-line \
  --info=inline-right \
  --layout=reverse
"

# Ref: https://github.com/catppuccin/fzf
export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS \
  --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
  --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
  --color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
  --color=selected-bg:#45475a
"

# ----------------------------------------------------------------------------
# Zoxide
#
# A mix of default and custom params
#
# Refs:
# - https://github.com/ajeetdsouza/zoxide/blob/main/src/cmd/query.rs#L92-L119
# - https://github.com/ajeetdsouza/zoxide/blob/main/src/util.rs#L54-L82
# ----------------------------------------------------------------------------
export _ZO_FZF_OPTS="$FZF_DEFAULT_OPTS \
  --exact \
  --no-sort \
  --cycle \
  --keep-right \
  --preview 'eza --tree --level 2 --color=always --icons=always --no-quotes {2..}'
"
