# .ignore is taken into account while execuiting fd/rg/ag
export FZF_DEFAULT_COMMAND='fd --type file --follow --hidden'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="--preview-window 'right:60%' --preview 'bat --color=always --style=header,grid --line-range :300 {}'"
export FZF_DEFAULT_OPTS="--height 40% --no-multi --select-1 --exit-0"

# ----------------
# tokyonight-night
#
# Ref: https://github.com/folke/tokyonight.nvim/blob/main/extras/fzf/tokyonight_night.sh
#
# Background color changed to #1a1b26 to match iterm color
# ----------------
export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS \
  --highlight-line \
  --info=inline-right \
  --ansi \
  --layout=reverse \
  --border=none
  --color=bg+:#283457 \
  --color=bg:#1a1b26 \
  --color=border:#27a1b9 \
  --color=fg:#c0caf5 \
  --color=gutter:#16161e \
  --color=header:#ff9e64 \
  --color=hl+:#2ac3de \
  --color=hl:#2ac3de \
  --color=info:#545c7e \
  --color=marker:#ff007c \
  --color=pointer:#ff007c \
  --color=prompt:#2ac3de \
  --color=query:#c0caf5:regular \
  --color=scrollbar:#27a1b9 \
  --color=separator:#ff9e64 \
  --color=spinner:#ff007c \
"
