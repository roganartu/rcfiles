#!/usr/bin/env bash
set -e 
_url="$(curl --silent "https://api.github.com/repos/sharkdp/bat/releases/latest" \
  | jq -r '.assets[] | select(.name | endswith('\"'musl.tar.gz'\"')).browser_download_url')"

if [ -z "${_url}" ]; then \
  printf "\e[38;5;196m\nUnable to determine download link for bats static binary\n\n\e[0m"; \
  exit 1; \
fi

_olddir="$(pwd)"

cd /tmp
wget ${_url}
tar -xzvf "$(basename ${_url})"
mv bat-v*/bat "${_olddir}/bat/bat"
rm -rf /tmp/bat-v*
