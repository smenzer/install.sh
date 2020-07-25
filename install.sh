#!/bin/bash
# usage: bash <(curl -SsL https://raw.githubusercontent.com/smenzer/terminal-setup/master/install.sh)

# check if tput exists
if [ ! command -v tput &> /dev/null ]; then
    # tput could not be found
    BOLD=""
    RESET=""
    UL=""
    RUL=""
    FG_WHITE=""
    FG_SKYBLUE=""
    FG_ORANGE=""
    BG_AQUA=""
    FG_BLACK=""
    FG_ORANGE=""
else
    BOLD=$(tput bold)
    RESET=$(tput sgr0)
    FG_WHITE=$(tput setf 7)
    FG_SKYBLUE=$(tput setaf 122)
    FG_ORANGE=$(tput setaf 208)
    BG_AQUA=$(tput setab 45)
    FG_BLACK=$(tput setaf 16)
    FG_ORANGE=$(tput setaf 214)
    UL=$(tput smul)
    RUL=$(tput rmul)
fi

repo_default="git@github.com:smenzer/terminal.git"
target_default="${HOME}/src/github.com/smenzer"

# get repo
printf "${FG_SKYBLUE}\nEnter the repo location (hit Enter to use the default ${UL}${repo_default}${RUL}):${RESET}\n"
read -r -p "> " repo
if [ ! "${repo}" ]; then
    repo=${repo_default}
fi

# get machine name
printf "${FG_SKYBLUE}\nEnter the machine name (hit Enter to use the default ${UL}$(hostname)${RUL}):${RESET}\n"
read -r -p "> " machine
if [ ! "${machine}" ]; then
	machine=$(hostname)
fi

# get target directory
printf "${FG_SKYBLUE}\nEnter the parent directory to place the \"terminal\" repository in (hit Enter to use the default ${UL}${target_default}${RUL}):${RESET}\n"
read -r -p "> " target
if [ ! "${target}" ]; then
	target=${target_default}
fi
if [ ! -d "${target}" ]; then
	mkdir -p ${target}
fi
target="${target}/terminal"

# clone the main repo
printf "${FG_ORANGE}${BOLD}\n--[ Cloning repo from ${UL}${repo}${RUL} into ${UL}${target}${RUL}${RESET}\n"
git clone ${repo} ${target}

# # run the setup script from the main repo
cd ${target}
bash ./install.sh -m ${machine} -t ${target}
