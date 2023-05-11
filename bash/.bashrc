# Exit immediately if not interactive
if [[ ${-} != *i* ]]; then return; fi

# Use starship.rs
eval "$(starship init bash)"
. "$HOME/.cargo/env"

source /home/tl/.config/broot/launcher/bash/br
source /usr/local/hrt-localcoding/vscode-extensions/vscode-remote.bash
