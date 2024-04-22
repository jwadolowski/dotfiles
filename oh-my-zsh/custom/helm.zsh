function htv() {
  local out_file=$(mktemp --suffix ".yaml")
  make template 2>/dev/null | tail -n +6 >$out_file
  vim $out_file
  rm -f $out_file
}

function htb() {
  local stdout_file=$(mktemp --suffix ".yaml")
  local stderr_file=$(mktemp --suffix ".txt")

  make template 2>"${stderr_file}" >"${stdout_file}"

  if [[ $? == 0 ]]; then
    tail -n +6 "${stdout_file}" | bat --language yaml
  else
    bat "${stderr_file}"
    tail -n +6 "${stdout_file}" | bat --language yaml
  fi

  rm -f "${stdout_file}" "${stderr_file}"
}
