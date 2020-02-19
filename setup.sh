#!/bin/bash
# usage: bash <(curl -SsL https://raw.github.com/smenzer/terminal/master/setup.sh)

repo="git@bitbucket.org:smenzer/terminal.git"
target_default="${HOME}/src/bitbucket.org"

# get machine name
read -r -p "Enter the machine name (hit Enter to use the default \"$(hostname)\"): " machine
if [ ! "${machine}" ]; then
	machine=$(hostname)
fi

# get target directory
read -r -p "Enter the target directory to place \"terminal\" in (hit Enter to use the default \"${target_default}\"): " target
if [ ! "${target}" ]; then
	target=${target_default}
fi
if [ ! -d "${target}" ]; then
	mkdir -p ${target}
fi
# we don't want to create the terminal directory because git clone will do that for us
target="${target}/terminal"

echo "--[ Cloning repo from ${repo}"
# git clone ${repo} ${target}

cd ${target}
bash ./setup.sh -m ${machine} -t ${target}