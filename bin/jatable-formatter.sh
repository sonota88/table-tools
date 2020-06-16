#!/bin/bash

_print_this_dir() {
  local real_path="$(readlink --canonicalize "$0")"
  (
    cd "$(dirname "$real_path")"
    pwd
  )
}

# --------------------------------

__dir__="$(_print_this_dir)"

${__dir__}/bundle_exec.sh ${__dir__}/jatable-formatter.rb "$@"
