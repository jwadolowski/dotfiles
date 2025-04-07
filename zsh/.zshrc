# Source: https://github.com/zimfw/install/blob/master/src/templates/zimrc

# -----------------
# Zsh configuration
# -----------------

#
# History
#

# Remove older command from the history if a duplicate is to be added.
setopt HIST_IGNORE_ALL_DUPS

#
# Input/output
#

# Set editor default keymap to emacs (`-e`) or vi (`-v`)
bindkey -e

# Prompt for spelling correction of commands.
# setopt CORRECT

# Customize spelling correction prompt.
# SPROMPT='zsh: correct %F{red}%R%f to %F{green}%r%f [nyae]? '

# Remove path separator from WORDCHARS.
WORDCHARS=${WORDCHARS//[\/]}

# -----------------
# Zim configuration
# -----------------

# Use degit instead of git as the default tool to install and update modules.
#zstyle ':zim:zmodule' use 'degit'

# --------------------
# Module configuration
# --------------------

#
# input
#

# Append `../` to your input for each `.` you type after an initial `..`
#zstyle ':zim:input' double-dot-expand yes

#
# termtitle
#

# Set a custom terminal title format using prompt expansion escape sequences.
# See http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html#Simple-Prompt-Escapes
# If none is provided, the default '%n@%m: %~' is used.
zstyle ':zim:termtitle' format '%1~'

#
# zsh-syntax-highlighting
#

# Set what highlighters will be used.
# See https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters.md
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)

# Customize the main highlighter styles.
# See https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters/main.md#how-to-tweak-it
#typeset -A ZSH_HIGHLIGHT_STYLES
#ZSH_HIGHLIGHT_STYLES[comment]='fg=242'

# ------------------
# Initialize modules
# ------------------

ZIM_HOME=${ZDOTDIR:-${HOME}}/.zim
# Download zimfw plugin manager if missing.
if [[ ! -e ${ZIM_HOME}/zimfw.zsh ]]; then
  if (( ${+commands[curl]} )); then
    curl -fsSL --create-dirs -o ${ZIM_HOME}/zimfw.zsh \
        https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
  else
    mkdir -p ${ZIM_HOME} && wget -nv -O ${ZIM_HOME}/zimfw.zsh \
        https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
  fi
fi
# Install missing modules, and update ${ZIM_HOME}/init.zsh if missing or outdated.
if [[ ! ${ZIM_HOME}/init.zsh -nt ${ZDOTDIR:-${HOME}}/.zimrc ]]; then
  source ${ZIM_HOME}/zimfw.zsh init -q
fi
# Initialize modules.
source ${ZIM_HOME}/init.zsh

# ------------------------------
# Post-init module configuration
# ------------------------------

# PATH variable adjustments
#
# It cannot be placed in ~/.zshenv because brew is not available until ~/.zimrc
# gets sourced (happens above). See ~/.zprofile comments for loading details
BREW_PREFIX=$(brew --prefix)
# Prefer coreutils binaries over built-in macOS ones
export PATH="${BREW_PREFIX}/opt/coreutils/libexec/gnubin:${PATH}"
# Prefer gnu-sed over the built-in one
export PATH="${BREW_PREFIX}/opt/gnu-sed/libexec/gnubin:${PATH}"
# Prefer gnu-grep over the built-in one
export PATH="${BREW_PREFIX}/opt/grep/libexec/gnubin:${PATH}"
# Prefer gnu-find over the built-in one
export PATH="${BREW_PREFIX}/opt/findutils/libexec/gnubin:$PATH"
# Prefer curl installed via brew
export PATH="${BREW_PREFIX}/opt/curl/bin:${PATH}"
# Some tools get installed into sbin dir
#
# https://github.com/Homebrew/homebrew-core/issues/14669#issuecomment-353399229
export PATH="${BREW_PREFIX}/sbin:${PATH}"
# Local binaries (usually installed by hand)
export PATH="${HOME}/bin:${PATH}"

# Aliases
source ${HOME}/.zsh_aliases

# Listing colors - supported by ls, tree, fd, dust, etc
#
# Ref: https://github.com/sharkdp/vivid
if [[ ! $(command -v vivid) == "" ]]; then
  export LS_COLORS="$(vivid generate catppuccin-mocha)"
fi

# Prefer 'tfswitch' over brew-installed 'terraform'
#
# Ref: https://developer.hashicorp.com/terraform/cli/commands#shell-tab-completion
complete -o nospace -C "${HOME}/bin/terraform" terraform

# Prefer 'tgswitch' over brew-installed 'terragrunt'
#
# Ref: https://terragrunt.gruntwork.io/docs/getting-started/install/#enable-tab-completion
complete -o nospace -C "${HOME}/bin/terragrunt" terragrunt

# zsh completion fix. Overwrites https://github.com/zimfw/completion/blob/master/init.zsh#L89
#
# Shamelessly stolen from: https://github.com/marlonrichert/zsh-autocomplete/tree/main?tab=readme-ov-file#insert-prefix-instead-of-substring
#
# Refs:
# - https://github.com/zimfw/zimfw/issues/549
# - https://github.com/zimfw/completion/issues/10
zstyle ':completion:*' matcher-list \
  'm:{[:lower:]-}={[:upper:]_} r:|[.]=**' \
  '+l:|=*'

# Re-enable file overwrite via '>'
#
# Ref: https://github.com/zimfw/environment
unsetopt NO_CLOBBER

# Added by LM Studio CLI (lms)
export PATH="${PATH}:${HOME}/.cache/lm-studio/bin"

# pnpm
export PNPM_HOME="/Users/jwadolowski/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
