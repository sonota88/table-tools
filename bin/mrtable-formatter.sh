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

export PATH="$HOME/.anyenv/bin:$PATH"
eval "$(anyenv init -)"

rbenv shell $(cat ${__dir__}/../.ruby-version)

export BUNDLE_GEMFILE=${__dir__}/../Gemfile

bundle exec ${__dir__}/mrtable-formatter.rb "$@"
