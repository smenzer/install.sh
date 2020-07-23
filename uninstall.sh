#!/bin/bash
# usage: bash <(curl -SsL https://raw.githubusercontent.com/smenzer/terminal-setup/master/uninstall.sh)

target_default="${HOME}/src/github.com/smenzer/terminal"

# get target directory
read -r -p "Enter the location of the \"terminal\" directory (hit Enter to use the default \"${target_default}\"): " target
if [ ! "${target}" ]; then
	target=${target_default}
fi

# run the uninstall from there
cd ${target}
bash ./uninstall.sh -t ${target}
