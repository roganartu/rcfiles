#!/bin/bash
_prompt_action() {
    # wait for a lock on the rofi pidfile
    flock "$XDG_RUNTIME_DIR/rofi.pid" true

    # Open fullscreen working from the src dir, with the neovim profile
    # which is configured to automatically restart neovim when it closes.
    gnome-terminal --window-with-profile neovim --working-directory /mnt/home/src --full-screen --hide-menubar
}

if [[ -z "$@" ]]; then
    printf %"s\n" "Open Neovim (nvim)"
else
    # Completely detach from the parent script
    # If in/outputs are not redirected, rofi will wait for the forked process as well.
    _prompt_action "$1" </dev/null >/dev/null 2>/dev/null &
fi

