#!/bin/bash
# usage: curl -SsL https://raw.githubusercontent.com/smenzer/terminal/master/uninstall | bash [-s target]
# note: will not remove the .bash_aliases file because it is not stored in git

# get user input
if [ "$1" ]; then
	target=$1
else
	target=~/src/github.com/smenzer
fi
target=${target}"/terminal"


# remove all links and finall the target directory
echo "--[ Uninstalling vim"
rm ~/.vim
rm ~/.vimrc

echo "--[ Uninstalling git"
rm ~/.gitignore_global
rm ~/.gitconfig

echo "--[ Uninstalling bash profile"
rm ~/.bash_profile

echo "--[ Uninstalling bash_common"
rm ~/.bash_common

echo "--[ .bash_aliases NOT removed"

echo "--[ Uninstalling tmux"
rm ~/.tmux.conf

echo "--[ Uninstalling ack"
rm ~/.ackrc

echo "--[ Uninstalling git-prompt"
rm ~/.git-prompt.sh

echo "--[ Uninstalling terminal repository from ${target}"
rm -rf ${target}


echo "--[ Uninstallation complete!"
