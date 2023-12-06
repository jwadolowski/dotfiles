function htv() {
  local out_file=$(mktemp --suffix ".yaml")
  make template 2>/dev/null | tail -n +6 > $out_file
  vim $out_file
  rm -f $out_file
}

function htb() {
  local out_file=$(mktemp --suffix ".yaml")
  make template 2>/dev/null | tail -n +6 > $out_file
  bat $out_file
  rm -f $out_file
}
