# .ignore is taken into account while execuiting fd/rg/ag
export FZF_DEFAULT_COMMAND='fd --type file --follow --hidden --no-ignore-vcs'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="--preview-window 'right:60%' --preview 'bat --color=always --style=header,grid --line-range :300 {}'"

# ----------------
# tokyonight-night
#
# Ref: https://github.com/folke/tokyonight.nvim/blob/main/extras/fzf/tokyonight_night.zsh
# ----------------
export FZF_DEFAULT_OPTS="--height 40% --no-multi --select-1 --exit-0 \
  --color=fg:#c0caf5,bg:#1a1b26,hl:#ff9e64 \
  --color=fg+:#c0caf5,bg+:#292e42,hl+:#ff9e64 \
  --color=info:#7aa2f7,prompt:#7dcfff,pointer:#7dcfff \
  --color=marker:#9ece6a,spinner:#9ece6a,header:#9ece6a"
