submodules: .PHONY
	git submodule update --init --recursive

vim: .PHONY submodules vim_py3_venv vim_py2_venv
	ln -s -n `pwd`/vim/.vim ~/.vim
	ln -s -n `pwd`/vim/.vimrc ~/.vimrc
	# Necessary for mundo to work
	mkdir -p ~/.cache/vim/undo
	# ctrlspace stores it's cachefile here
	mkdir -p ~/.cache/vim/ctrlspace

emacs: .PHONY submodules
	ln -s -n `pwd`/emacs/.emacs.d ~/.emacs.d

venvs: vim_py3_venv vim_py2_venv

vim_py3_venv: .PHONY
	mkdir -p ~/.venvs
	bash -c "source ~/.venvs/vim/bin/activate" || python3 -m virtualenv -p "`which python3.6`" ~/.venvs/vim
	~/.venvs/vim/bin/pip install --upgrade --upgrade-strategy eager black
	~/.venvs/vim/bin/pip install --upgrade --upgrade-strategy eager neovim
	~/.venvs/vim/bin/pip install --upgrade --upgrade-strategy eager jedi

vim_py2_venv: .PHONY
	mkdir -p ~/.venvs
	bash -c "source ~/.venvs/vim_py2/bin/activate" || python3 -m virtualenv -p "`which python2.7`" ~/.venvs/vim_py2
	~/.venvs/vim_py2/bin/pip install --upgrade --upgrade-strategy eager neovim
	~/.venvs/vim_py2/bin/pip install --upgrade --upgrade-strategy eager jedi

tmux: .PHONY submodules
	ln -s -n `pwd`/tmux/.tmux.conf ~/.tmux.conf
	mkdir -p ~/.tmux
	ln -s -n `pwd`/tmux/plugins ~/.tmux/plugins

git: .PHONY
	ln -s -n `pwd`/git/.gitignore ~/.gitignore
	git config --global core.excludesfile ~/.gitignore

zsh: .PHONY submodules
	ln -s -n `pwd`/zsh/.zshrc ~/.zshrc
	ln -s -n `pwd`/zsh/.zshenv ~/.zshenv
	
	mkdir -p ~/.zsh
	
	# Syntax highlighting
	ln -s -n `pwd`/zsh/plugins/zsh-syntax-highlighting ~/.zsh/zsh-syntax-highlighting
	
	# Fishy autosuggestions
	ln -s -n `pwd`/zsh/plugins/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
	
	# Extra autocomplete
	ln -s -n `pwd`/zsh/plugins/zsh-completions ~/.zsh/zsh-completions
	
	# systemd aliases
	ln -s -n `pwd`/zsh/plugins/systemd ~/.zsh/systemd

bash: .PHONY
	ln -s -n `pwd`/bash/.bashrc ~/.bashrc

starship: .PHONY
	ln -s -n `pwd`/starship/starship.toml ~/.config/starship.toml

fzf: .PHONY submodules
	ln -s -n `pwd`/fzf/.fzf ~/.fzf
	ln -s -n `pwd`/fzf/.fzf.zsh ~/.fzf.zsh

nvim: .PHONY submodules
	ln -s -n `pwd`/neovim ~/.config/nvim
	# Windows doesn't support FUSE yet, so we have to extract the appimage
	bash -c "`pwd`/neovim/nvim.appimage --version" || bash -c "cd `pwd`/neovim && \
		./nvim.appimage --appimage-extract"

bin: .PHONY
	ln -s -n `pwd`/bin ~/bin

install: submodules vim zsh bash starship fzf tmux nvim bin git

update: clean install

update_submodules: submodules
	git submodule foreach --recursive git fetch
	git submodule foreach --recursive git pull --ff-only origin master |:
	# coc.nvim should update from the release branch
	cd vim/.vim/bundle/coc.nvim && git checkout release && git pull

update_binaries: update_bat update_fd update_hyperfine update_nvim update_src_cli update_fzf update_starship

update_fzf: .PHONY
	./fzf/update.sh fzf

update_bat: .PHONY
	./sharkdp/update.sh bat

update_fd: .PHONY
	./sharkdp/update.sh fd

update_hyperfine: .PHONY
	./sharkdp/update.sh hyperfine

update_starship: .PHONY
	./starship/update.sh

update_src_cli: .PHONY
	curl -Lq https://sourcegraph.com/.api/src-cli/src_linux_amd64 -o ./sourcegraph/src

update_nvim: .PHONY
	./neovim/update.sh neovim

clean: .PHONY
	zsh -c 'setopt null_glob; \
		rm -f \
			~/bin(@) \
			~/.config/nvim(@) \
			~/.config/starship.toml(@) \
			~/.emacs.d(@) \
			~/.vim(@) \
			~/.vimrc(@) \
			~/.gitignore(@) \
			~/.zshrc(@) \
			~/.bashrc(@) \
			~/.zshenv(@) \
			~/.oh-my-zsh(@) \
			~/.zsh/functions/prompt_pure_setup(@) \
			~/.zsh/functions/async(@) \
			~/.zsh/zsh-syntax-highlighting(@) \
			~/.zsh/zsh-autosuggestions(@) \
			~/.zsh/zsh-completions(@) \
			~/.zsh/systemd(@) \
			~/.fzf(@) \
			~/.fzf.zsh(@) \
			~/.tmux.conf(@) \
			~/.tmux/plugins(@)'

.PHONY:
