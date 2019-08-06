#!/usr/bin/env bash
set -e

_target=$1

echo "Updating ${_target} from GitHub releases"

_url="$(curl --silent "https://api.github.com/repos/neovim/${_target}/releases/latest" \
  | jq -r '.assets[] | select(.name | endswith('\"'.appimage'\"')).browser_download_url')"

if [ -z "${_url}" ]; then \
  printf "\e[38;5;196m\nUnable to determine download link for ${_target} appimage\n\n\e[0m"; \
  exit 1; \
fi

_olddir="$(pwd)"

cd /tmp
wget "${_url}"
mv "nvim.appimage" "${_olddir}/${_target}/"
rm -rf "/tmp/nvim.appimage*"

# Make sure it's executable
chmod +x "${_olddir}/${_target}/"*.appimage
