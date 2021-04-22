#!/usr/bin/env bash
set -e

_target=starship

echo "Updating ${_target} from GitHub releases"

_url="$(curl --silent "https://api.github.com/repos/starship/${_target}/releases/latest" \
  | jq -r '.assets[] | select(.name | contains('\"'x86_64'\"')) | select(.name | endswith('\"'musl.tar.gz'\"')).browser_download_url')"

if [ -z "${_url}" ]; then \
  printf "\e[38;5;196m\nUnable to determine download link for ${_target} static binary\n\n\e[0m"; \
  exit 1; \
fi

_olddir="$(pwd)"

cd /tmp
wget ${_url}
tar -xzvf "$(basename ${_url})"
mv ${_target} "${_olddir}/${_target}/${_target}"
rm -rf /tmp/${_target}*

# Make sure it's executable
chmod +x "${_olddir}/${_target}/${_target}"
