submodules: .PHONY
	git submodule update --init --recursive

vim: .PHONY submodules vim_py3_venv
	ln -s -n `pwd`/vim/.vim ~/.vim
	ln -s -n `pwd`/vim/.vimrc ~/.vimrc
	# Necessary for mundo to work
	mkdir -p ~/.cache/vim/undo
	# ctrlspace stores it's cachefile here
	mkdir -p ~/.cache/vim/ctrlspace

emacs: .PHONY submodules
	ln -s -n `pwd`/emacs/.emacs.d ~/.emacs.d

venvs: vim_py3_venv

vim_py3_venv: .PHONY
	mkdir -p ~/.venvs
	bash -c "source ~/.venvs/vim/bin/activate" || python3.10 -m venv ~/.venvs/vim
	~/.venvs/vim/bin/pip install --upgrade --upgrade-strategy eager pip black neovim jedi

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
	
	mkdir -p ~/.zsh/plugins
	
	# Syntax highlighting
	ln -s -n `pwd`/zsh/plugins/zsh-syntax-highlighting ~/.zsh/zsh-syntax-highlighting
	
	# Fishy autosuggestions
	ln -s -n `pwd`/zsh/plugins/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
	
	# Extra autocomplete
	ln -s -n `pwd`/zsh/plugins/zsh-completions ~/.zsh/zsh-completions
	
	# systemd aliases
	ln -s -n `pwd`/zsh/plugins/systemd ~/.zsh/systemd
	
	# poetry completions
	ln -s -n `pwd`/zsh/plugins/poetry ~/.zsh/plugins/poetry

bash: .PHONY
	ln -s -n `pwd`/bash/.bashrc ~/.bashrc

starship: .PHONY
	ln -s -n `pwd`/starship/starship.toml ~/.config/starship.toml

fzf: .PHONY submodules
	ln -s -n `pwd`/fzf/.fzf ~/.fzf
	ln -s -n `pwd`/fzf/.fzf.zsh ~/.fzf.zsh

nvim: .PHONY submodules
	ln -s -n `pwd`/neovim/config ~/.config/nvim
	ln -snf ../../custom_config neovim/config/lua/custom
	# Windows doesn't support FUSE yet, so we have to extract the appimage
	bash -c "`pwd`/neovim/nvim.appimage --version" || bash -c "cd `pwd`/neovim && \
		./nvim.appimage --appimage-extract"

pyenv: .PHONY submodules
	ln -sf -n `pwd`/pyenv ~/.pyenv
	@# Try to make the bash extension, it's ok if this fails it's just additive
	-cd pyenv && src/configure && make -C src
	@# Install pyenv-pyright
	[ -d "pyenv/plugins/pyenv-pyright" ] || git clone https://github.com/alefpereira/pyenv-pyright.git pyenv/plugins/pyenv-pyright
	[ -d "pyenv/plugins/pyenv-virtualenv" ] || git clone https://github.com/pyenv/pyenv-virtualenv.git pyenv/plugins/pyenv-virtualenv

bin: .PHONY
	ln -s -n `pwd`/bin ~/bin

kitty: .PHONY
	ln -s -n `pwd`/kitty/config ~/.config/kitty

i3: .PHONY
	ln -s -n `pwd`/i3/config ~/.config/i3

install: submodules vim zsh bash starship fzf tmux nvim bin git emacs pyenv kitty

update: clean install

update_submodules: submodules
	git submodule foreach --recursive git fetch
	git submodule foreach --recursive git pull --ff-only origin master |:
	# coc.nvim should update from the release branch
	cd vim/.vim/bundle/coc.nvim && git checkout release && git pull

update_binaries: update_bat update_fd update_hyperfine update_nvim update_src_cli update_fzf update_starship update_rust_analyzer

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

update_rust_analyzer: .PHONY
	./rust-analyzer/update.sh rust-analyzer

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
			~/.config/kitty(@) \
			~/.config/i3(@) \
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
			~/.zsh/poetry(@) \
			~/.zsh/plugins/poetry(@) \
			~/.fzf(@) \
			~/.fzf.zsh(@) \
			~/.tmux.conf(@) \
			~/.tmux/plugins(@)'

.PHONY:
