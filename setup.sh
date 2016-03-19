#!/bin/bash
# usage: bash <(curl -SsL https://raw.github.com/smenzer/terminal/master/setup.sh)

# get user inputs
read -r -p "Enter the machine name (hit Enter to use the default \"$(hostname)\"): " machine
if [ ! "${machine}" ]; then
	machine=$(hostname)
fi

target_default=~/src/github.com/smenzer
read -r -p "Enter the target directory to place \"terminal\" (hit Enter to use the default \"${target_default}\"): " target
if [ ! "${target}" ]; then
	target=${target_default}
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

echo "--[ Creating .bash_secrets"
touch ~/.bash_secrets

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

echo "--[ Installing iTerm2 shell integration"
curl -L https://iterm2.com/misc/install_shell_integration.sh | bash

echo "--[ Setup complete"
