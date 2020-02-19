#!/bin/bash
# usage: bash <(curl -SsL https://raw.github.com/smenzer/terminal/master/uninstall.sh)

target_default="${HOME}/src/bitbucket.org"

# get target directory
read -r -p "Enter the location of the \"terminal\" directory (hit Enter to use the default \"${target_default}\"): " target
if [ ! "${target}" ]; then
	target=${target_default}
fi
target=${target}"/terminal"

# run the uninstall from there
cd ${target}
bash ./uninstall.sh -t ${target}