submodules: .PHONY
	git submodule update --init --recursive

vim: .PHONY submodules
	ln -s -n `pwd`/vim/.vim ~/.vim
	ln -s -n `pwd`/vim/.vimrc ~/.vimrc
	mkdir -p ~/.venvs
	bash -c "source ~/.venvs/vim/bin/activate" || python3.6 -m virtualenv -p $(which python3.6) ~/.venvs/vim
	~/.venvs/vim/bin/pip install black
	# Necessary for mundo to work
	mkdir -p ~/.cache/vim/undo

tmux: .PHONY submodules
	ln -s -n `pwd`/tmux/.tmux.conf ~/.tmux.conf
	mkdir -p ~/.tmux
	ln -s -n `pwd`/tmux/plugins ~/.tmux/plugins

zsh: .PHONY submodules
	ln -s -n `pwd`/zsh/.zshrc ~/.zshrc
	ln -s -n `pwd`/zsh/.zshenv ~/.zshenv
	ln -s -n `pwd`/zsh/.oh-my-zsh ~/.oh-my-zsh
	
	mkdir -p ~/.zsh
	
	# Pure theme
	mkdir -p ~/.zsh/functions
	ln -s -n `pwd`/zsh/submodules/pure/pure.zsh ~/.zsh/functions/prompt_pure_setup
	ln -s -n `pwd`/zsh/submodules/pure/async.zsh ~/.zsh/functions/async
	
	# Syntax highlighting
	ln -s -n `pwd`/zsh/plugins/zsh-syntax-highlighting ~/.zsh/zsh-syntax-highlighting
	
	# Fishy autosuggestions
	ln -s -n `pwd`/zsh/plugins/zsh-autosuggestions ~/.zsh/zsh-autosuggestions

fzf: .PHONY submodules
	ln -s -n `pwd`/fzf/.fzf ~/.fzf
	ln -s -n `pwd`/fzf/.fzf.zsh ~/.fzf.zsh

nvim: .PHONY submodules
	ln -s -n `pwd`/neovim ~/.config/nvim

bin: .PHONY
	ln -s -n `pwd`/bin ~/bin

install: submodules vim zsh fzf tmux nvim bin

update: clean install

update_binaries: update_bat update_fd update_nvim

update_bat: .PHONY
	./sharkdp/update.sh bat

update_fd: .PHONY
	./sharkdp/update.sh fd

update_nvim: .PHONY
	./neovim/update.sh neovim

clean: .PHONY
	zsh -c 'setopt null_glob; \
		rm -f \
			~/bin(@) \
			~/.config/nvim(@) \
			~/.vim(@) \
			~/.vimrc(@) \
			~/.zshrc(@) \
			~/.zshenv(@) \
			~/.oh-my-zsh(@) \
			~/.zsh/functions/prompt_pure_setup(@) \
			~/.zsh/functions/async(@) \
			~/.zsh/zsh-syntax-highlighting(@) \
			~/.zsh/zsh-autosuggestions(@) \
			~/.fzf(@) \
			~/.fzf.zsh(@) \
			~/.tmux.conf(@) \
			~/.tmux/plugins(@)'

.PHONY:
