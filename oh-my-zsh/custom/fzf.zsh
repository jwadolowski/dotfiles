# .ignore is taken into account while execuiting fd/rg/ag
export FZF_DEFAULT_COMMAND='fd --type file --follow --hidden --no-ignore-vcs'
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="--preview-window 'right:60%' --preview 'bat --color=always --style=header,grid --line-range :300 {}'"
