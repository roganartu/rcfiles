# Exit immediately if not interactive
if [[ ${-} != *i* ]]; then return; fi

# Use starship.rs
eval "$(starship init bash)"
. "$HOME/.cargo/env"
