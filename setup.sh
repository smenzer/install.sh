#!/bin/bash
# usage: curl -SsL https://raw.github.com/smenzer/terminal/master/setup | bash [-s machine [target]]

# get user inputs
if [ "$1" ]; then
	machine=$1
else
#    read -p "Name the machine; leave blank for default ($(hostname)): " machine
#    if [ -z "$machine" ]; then 
	machine=$(hostname)
#    fi
fi

if [ "$2" ]; then
	target=$2
else
#    read -p "What directory should links be placed in; leave blank for default (~): " target
#    if [ -z "$target" ]; then
	target="~"
#    fi
fi
if [ ! -d "$target" ]; then
	mkdir ${target}
fi


echo "--[ Cloning repo from git@github.com:smenzer/terminal.git"
git clone git@github.com:smenzer/terminal.git terminal

cd terminal
#temporary til we merge to master
git checkout improved_install

echo "--[ Initialize submodules"
git submodule init
git submodule update

cd ..

echo "--[ Configuring git"
ln -s $(pwd)/terminal/git/gitignore_global ${target}/.gitignore_global
ln -s $(pwd)/terminal/git/gitconfig ${target}/.gitconfig


echo "--[ Linking bash profile to bash_profile_${machine}"
if [ ! -f $(pwd)/terminal/bash_profile/bash_profile_${machine} ]; then
	cp $(pwd)/terminal/bash_profile/bash_profile_template $(pwd)/terminal/bash_profile/bash_profile_${machine}
fi
ln -s $(pwd)/terminal/bash_profile/bash_profile_${machine} ${target}/.bash_profile

echo "--[ Linking bash_common"
ln -s $(pwd)/terminal/bash_profile/bash_common ${target}/.bash_common

echo "--[ Creating .bash_aliases"
touch ${target}/.bash_aliases

echo "--[ Linking tmux"
ln -s $(pwd)/terminal/misc/tmux.conf ${target}/.tmux.conf

echo "--[ Linking ack"
ln -s $(pwd)/terminal/misc/ackrc ${target}/.ackrc

echo "--[ Installing vim"
ln -s $(pwd)/terminal/vim ${target}/.vim
ln -s $(pwd)/terminal/vim/vimrc ${target}/.vimrc
#pushd terminal/vim
#vim +PluginInstall +qall
#popd
if [ ! -d $(pwd)/terminal/vim/.vim_backup ]; then
	mkdir $(pwd)/terminal/vim/.vim_backup
fi
if [ ! -d $(pwd)/terminal/vim/.vim_swap ]; then
	mkdir $(pwd)/terminal/vim/.vim_swap
fi






echo "--[ Setup complete"
