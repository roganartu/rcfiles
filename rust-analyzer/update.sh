#!/usr/bin/env bash
set -e

_target=$1

echo "Updating ${_target} from GitHub releases"

_url="$(curl --silent "https://api.github.com/repos/rust-lang/${_target}/releases/latest" \
  | jq -r '.assets[] | select(.name | endswith('\"'x86_64-unknown-linux-gnu.gz'\"')).browser_download_url')"

if [ -z "${_url}" ]; then \
  printf "\e[38;5;196m\nUnable to determine download link for ${_target} x86_64-unknown-linux-gnu.gz\n\n\e[0m"; \
  exit 1; \
fi

_olddir="$(pwd)"

cd /tmp
wget "${_url}"
gunzip -f rust-analyzer*-linux-gnu.gz
mv "/tmp/rust-analyzer"*"-linux-gnu" "${_olddir}/${_target}/${_target}"
rm -rf "/tmp/rust-analyzer"*"-linux-gnu"*

# Make sure it's executable
chmod +x "${_olddir}/${_target}/"*
