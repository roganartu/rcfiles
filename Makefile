submodules: .PHONY
	git submodule update --init --recursive

vim: .PHONY
	ln -s `pwd`/vim/.vim ~/.vim
	ln -s `pwd`/vim/.vimrc ~/.vimrc

install: submodules vim

update: submodules

.PHONY:
