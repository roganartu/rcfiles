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

install: submodules vim zsh

update: submodules

.PHONY:
