#!/bin/sh
#
tmux list-windows -f "#{?window_active,,inactive}" -F '#{window_index} #{window_name}' |
	fzf --preview "tmux capture-pane -ep -t 'term-0:{1}' | tail -n 60 | cat" \
		--preview-window=right:60%:wrap \
		--bind "enter:execute(tmux select-window -t 'term-0:{1}')+abort"
