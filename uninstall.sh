#!/bin/bash
# usage: bash <(curl -SsL https://raw.githubusercontent.com/smenzer/terminal-setup/master/uninstall.sh)

target_default="${HOME}/src/github.com/smenzer/terminal"

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

# get target directory
printf "${FG_SKYBLUE}\nEnter the location of the \"terminal\" directory (hit Enter to use the default ${UL}${target_default}${RUL}):${RESET}\n"
read -r -p "> " target
if [ ! "${target}" ]; then
	target=${target_default}
fi

# run the uninstall from there
cd ${target}
bash ./uninstall.sh -t ${target}
