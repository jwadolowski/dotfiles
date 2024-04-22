function jdk() {
  version=$1
  if [[ -n $version ]]; then
    export JAVA_HOME=$(/usr/libexec/java_home -v"$version")
    java -version
  else
    info_log "Available JDK versions:"
    /usr/libexec/java_home -V
  fi
}

export JAVA_HOME=$(/usr/libexec/java_home -v1.11)
