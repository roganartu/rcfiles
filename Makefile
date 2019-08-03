submodules: .PHONY
	git submodule update --init --recursive

vim: .PHONY submodules
	ln -s `pwd`/vim/.vim ~/.vim
	ln -s `pwd`/vim/.vimrc ~/.vimrc

tmux: .PHONY submodules
	ln -s `pwd`/tmux/.tmux.conf ~/.tmux.conf
	mkdir -p ~/.tmux
	ln -s `pwd`/tmux/plugins ~/.tmux/plugins

zsh: .PHONY submodules
	ln -s `pwd`/zsh/.zshrc ~/.zshrc
	ln -s `pwd`/zsh/.zshenv ~/.zshenv
	ln -s `pwd`/zsh/.oh-my-zsh ~/.oh-my-zsh
	
	mkdir -p ~/.zsh
	
	# Pure theme
	mkdir -p ~/.zsh/functions
	ln -s `pwd`/zsh/submodules/pure/pure.zsh ~/.zsh/functions/prompt_pure_setup
	ln -s `pwd`/zsh/submodules/pure/async.zsh ~/.zsh/functions/async
	
	# Syntax highlighting
	ln -s `pwd`/zsh/plugins/zsh-syntax-highlighting ~/.zsh/zsh-syntax-highlighting
	
	# Fishy autosuggestions
	ln -s `pwd`/zsh/plugins/zsh-autosuggestions ~/.zsh/zsh-autosuggestions

fzf: .PHONY submodules
	ln -s `pwd`/fzf/.fzf ~/.fzf
	ln -s `pwd`/fzf/.fzf.zsh ~/.fzf.zsh

bin: .PHONY
	ln -s `pwd`/bin ~/bin

install: submodules vim zsh fzf tmux bin

update: clean install

update_binaries: update_bats

update_bat: .PHONY
	./bat/update.sh

clean: .PHONY
	zsh -c 'setopt null_glob; \
		rm -f \
			~/bin(@) \
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
