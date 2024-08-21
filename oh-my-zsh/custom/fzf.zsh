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
  --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
  --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
  --color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
  --color=selected-bg:#45475a \
  --highlight-line \
  --info=inline-right \
  --layout=reverse \
  --border=none
"
