# https://superuser.com/a/613817
ZLE_REMOVE_SUFFIX_CHARS=""

function upgrade_omz_plugins {
  wd=$(pwd)
  for plugin in $(find ~/.oh-my-zsh/custom/plugins -type d -iregex ".*\.git" -exec dirname {} \;); do
    info_log "Upgrading ${plugin}"
    cd $plugin
    git pull
  done
  cd $wd
}

function upgrade_omz {
  upgrade_omz_plugins
  omz update
}
