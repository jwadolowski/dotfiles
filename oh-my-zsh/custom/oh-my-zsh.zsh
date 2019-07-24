# https://superuser.com/a/613817
ZLE_REMOVE_SUFFIX_CHARS=""

function upgrade_oh_my_zsh_plugins {
  wd=$(pwd)
  for plugin in $(find ~/.oh-my-zsh/custom/plugins -type d -iregex ".*\.git" -exec dirname {} \;); do
      info_log "Upgrading ${plugin}"
      cd $plugin
      git pull
  done
  cd $wd
}

function upgrade_oh_my_zsh_themes {
  wd=$(pwd)
  for theme in $(find ~/.oh-my-zsh/custom/themes -type d -iregex ".*\.git" -exec dirname {} \;); do
      info_log "Upgrading ${theme}"
      cd $theme
      git pull
  done
  cd $wd
}

function upgrade_oh_my_zsh_all {
    upgrade_oh_my_zsh
    upgrade_oh_my_zsh_plugins
    upgrade_oh_my_zsh_themes
}
