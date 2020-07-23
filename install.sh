#!/bin/bash
# usage: bash <(curl -SsL https://raw.githubusercontent.com/smenzer/terminal-setup/master/install.sh)

repo_default="git@github.com:smenzer/terminal.git"
target_default="${HOME}/src/github.com/smenzer"

# get repo
read -r -p "Enter the repo to pull from (hit Enter to use the default \"${repo_default}\"): " repo
if [ ! "${repo}" ]; then
    repo=${repo_default}
fi

# get machine name
read -r -p "Enter the machine name (hit Enter to use the default \"$(hostname)\"): " machine
if [ ! "${machine}" ]; then
	machine=$(hostname)
fi

# get target directory
read -r -p "Enter the parent directory to place the \"terminal\" repository in (hit Enter to use the default \"${target_default}\"): " target
if [ ! "${target}" ]; then
	target=${target_default}
fi
if [ ! -d "${target}" ]; then
	mkdir -p ${target}
fi
# we don't want to create the terminal directory because git clone will do that for us
target="${target}/terminal"

# clone the main repo
echo "--[ Cloning repo from ${repo} into ${target}"
git clone ${repo} ${target}

# run the setup script from the main repo
cd ${target}
bash ./install.sh -m ${machine} -t ${target}
