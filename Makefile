submodules: .PHONY
	git submodule update --init --recursive

vim: .PHONY submodules
	ln -s `pwd`/vim/.vim ~/.vim
	ln -s `pwd`/vim/.vimrc ~/.vimrc

zsh: .PHONY submodules
	ln -s `pwd`/zsh/.zshrc ~/.zshrc
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

install: submodules vim zsh fzf

update: clean install

clean: .PHONY
	zsh -c 'rm \
		~/.vim(@) \
		~/.vimrc(@) \
		~/.zshrc(@) \
		~/.zshenv(@) \
		~/.oh-my-zsh(@) \
		~/.zsh/functions/prompt_pure_setu(@)p \
		~/.zsh/functions/async(@) \
		~/.zsh/zsh-syntax-highlighting(@) \
		~/.zsh/zsh-autosuggestions(@) \
		~/.fzf(@) \
		~/.fzf.sh(@)'

.PHONY:
