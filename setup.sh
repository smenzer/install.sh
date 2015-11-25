#!/bin/bash
# usage: curl -SsL https://raw.github.com/smenzer/terminal/master/setup.sh | bash [-s machine [target]]

# get user inputs
if [ "$1" ]; then
	machine=$1
else
	machine=$(hostname)
fi

if [ "$2" ]; then
	target=$2
else
	target=~/src/github.com/smenzer
fi
if [ ! -d "$target" ]; then
	mkdir -p ${target}
fi
# we don't want to create the terminal directory because git clone will do that for us
target=${target}"/terminal"


echo "--[ Cloning repo from git@github.com:smenzer/terminal.git"
git clone git@github.com:smenzer/terminal.git ${target} 

echo "--[ Installing vim"
ln -s ${target}/vim ~/.vim
ln -s ${target}/vim/vimrc ~/.vimrc

pushd ${target}
echo "--[ Initialize submodules"
git submodule init
git submodule update
popd

echo "--[ Configuring git"
ln -s ${target}/git/gitignore_global ~/.gitignore_global
ln -s ${target}/git/gitconfig ~/.gitconfig

echo "--[ Linking bash profile to bash_profile_${machine}"
if [ ! -f ${target}/bash_profile/bash_profile_${machine} ]; then
	cp ${target}/bash_profile/bash_profile_template ${target}/bash_profile/bash_profile_${machine}
fi
ln -s ${target}/bash_profile/bash_profile_${machine} ~/.bash_profile

echo "--[ Linking bash_common"
ln -s ${target}/bash_profile/bash_common ~/.bash_common

echo "--[ Creating .bash_aliases"
touch ~/.bash_aliases

echo "--[ Linking tmux"
ln -s ${target}/misc/tmux.conf ~/.tmux.conf

echo "--[ Linking ack"
ln -s ${target}/misc/ackrc ~/.ackrc

echo "--[ Linking git-prompt"
ln -s ${target}/git/git-prompt.sh .git-prompt.sh

echo "--[ Installing vim plugins"
vim +PluginInstall +qall

echo "--[ Command-T setup"
pushd ${target}/vim/bundle/Command-T/ruby/command-t/
ruby extconf.rb
make
popd

echo "--[ YouCompleteMe setup"
pushd ${target}/vim/bundle/YouCompleteMe/
sh ./install.sh --clang-completer
popd


echo "--[ Setup complete"
