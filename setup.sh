#!/bin/bash
# usage: curl -SsL https://raw.github.com/smenzer/terminal/master/setup | bash [-s machine [target]]

# get user inputs
if [ "$1" ]; then
	machine=$1
else
	read -p "Name the machine; leave blank for default ($(hostname)): " machine
	if [ -z "$machine" ]; then 
		machine=$(hostname)
	fi
fi

if [ "$2" ]; then
	target=$2
else
	read -p "What directory should links be placed in; leave blank for default (~): " target
	if [ -z "$target" ]; then
		target="~"
	fi
fi

echo "--[ Cloning repo from git@github.com:smenzer/terminal.git"
git clone git@github.com:smenzer/terminal.git terminal
pushd terminal

echo "--[ Initialize submodules"
git submodule init
git submodule update

echo "--[ Linking bash profile to bash_profile_${machine}"
if [ ! -f ./bash_profile/bash_profile_${machine} ]; then
	touch ./bash_profile/.bash_profile_${machine}
fi
ln -s ./bash_profile/.bash_profile_${machine} ${target}/.bash_profile

echo "--[ Linking bash_common"
ln -s ./bash_profile/.bash_common ${target}/.bash_common

echo "--[ Creating .bash_aliases"
touch ${target}/.bash_aliases

echo "--[ Linking tmux ]"
ln -s ./misc/tmux.conf ${target}/.tmux.conf

echo "--[ Linking ack ]"
ln -s ./misc/ackrc ${target}/.ackrc

echo "--[ Installing VIM"
ln -s ./vim ${target}/.vim
ln -s ./vim/vimrc ${target}/.vimrc
vim +PluginInstall +qall

if [ ! -d ./vim/.vim_backup ]; then
	mkdir ./vim/.vim_backup
fi
if [ ! -d ./vim/.vim_swap ]; then
	mkdir ./vim/.vim_swap
fi






echo "--[ Setup complete"
