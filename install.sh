#!/bin/zsh
# usage: zsh <(curl -SsL https://raw.githubusercontent.com/smenzer/install.sh/master/install.sh)
#
# Inspired by https://gitlab.com/X99/reinstall.sh

###############################################################################
# Settings
###############################################################################

# variables
TERMINAL_REPO='git@github.com:smenzer/terminal.git'
GIT_PATH="${HOME}/src" # must be the same as set in zshrc files in terminal repo
CONFIG_VAR_DIR="${HOME}/.config"
MACHINE_NAME_FILE="${CONFIG_VAR_DIR}/machine_name" # should match machines in terminal repo
INSTALL_LOG='./install_log.log'

# brew tools that get installed on all macs
# tip: brew leaves --installed-on-request to see what is currently installed
declare -a mac_tools=(
    "ack" # search, like grep but better
    "autojump" # move to directories with "j <dir>"
    "coreutils" # requird for lots of stuff
    # "dockutil" # tool for managing dock items (need to install manually for now until homebrew supports v3)
    "duti" # select default apps for documents and URL schemes
    "iperf3" # network bandwidth analytics tool
    "jq" # json processor
    "m-cli" # mac CLI
    "mas" # mac app store CLI
    "python3" # python
    "rbenv" # for command prompt (although not sure why)
    "shivammathur/php/php@8.1" # php since it's not included with macs anymore
    "shivammathur/php/php@7.4" # other specific php versions we want
    "speedtest-cli" # run speed tests from the commandline
    "subversion" # required for some fonts, and probably other things
)
# brew tools that only go on laptops/computers we use (i.e. not servers)
declare -a mac_tools_clients_only=(
    "exiftool" # read and edit exif information
    "gh" # github cli
    "openjdk@11" # jdk for dbeaver and work dev environment
    "switchaudio-osx" # change macOS audio source from the command-line (SwitchAudioSource)
    "wget" # retrieve remote files
)
# brew tools that only go on work laptops
declare -a tools_work_only=(
    "awscli" # amazon command line
)

# cask apps that go on all macs
declare -a cask_apps=(
    "1password" # password manager
    "alfred" # command / app launcher
    "angry-ip-scanner" # network scanner
    "appcleaner" # delete all extra files from an app
    "caffeine" # prevent sleep
    "docker" # mac ui for docker containers
    "dropbox" # cloud files
    "google-chrome" # primary browser
    "iterm2" # terminal
    "netspot" # wifi / network analyzer
    "nordvpn" # vpn
    # "osxfuse" # mount remote drives (deprecated, should test macfuse instead)
    "sublime-text" # text editor
    "virtualbox" # virtual machines
    "visual-studio-code" # ide
)
# cask apps that only go on laptops/computers we use (i.e. not servers)
declare -a cask_apps_clients_only=(
    "adobe-creative-cloud" # adobe apps
    # "adoptopenjdk8" # jdk required for dbeaver (using jdk11 instead)
    "asana" # stand-alone asana app
    "bartender" # manages menu bar
    "cheatsheet" # hold ⌘ in an app to see all shortcuts
    "dbeaver-community" # ui for db
    "divvy" # window management
    "flotato" # converts websites into native apps
    "gpg-suite" # encryption
    # "intel-power-gadget" # detailed analytics for intel processor; needed for istat menus (causes issues with Vagrant/Virtualbox)
    "istat-menus" # menu bar stats
    "macdown" # markdown editor
    "ngrok" # share dev site externally and (optionally) with https
    "postman" # http request ui for api dev
    "runjs" # javascript playground
    "signal" # messaging platform
    "slack" # messaging platform
    "sourcetree" # source control ui
    "spotify" # music
    "spotmenu" # spotify menu bar
    "vagrant" # dev environment for laravel
    "vlc" # play all videos
    "whatsapp" # whatsapp for desktop
)
# cask apps that only go on work laptops
declare -a cask_apps_work_only=(
    "cyberduck" # ftp gui
    "eqmac" # equaliser for mac, useful for zoom meetings to reduce bass
    "firefox" # alternate browser
    "google-cloud-sdk" # suite of tools for google cloud storage
    "google-drive" # google drive client
    "microsoft-teams" # video conferencing
    "miro" # ui for miro tool
    "zoom" # video conferencing
)

# mac store apps for all macs
declare -a mac_app_store_apps=(
    "speedtest"
)
# mac store apps that only go on laptops/computers we use (i.e. not servers)
declare -a mac_app_store_apps_clients_only=(
    "meeter"
)
# brew taps required
declare -a taps=(
    "homebrew/cask" # homebrew cask
    "buo/cask-upgrade" # update casks easier (brew cu)
    "homebrew/cask-fonts" # fonts
    "shivammathur/php" # php (php was deprecated in MacOs 12.0 - https://wpbeaches.com/updating-to-php-versions-7-4-and-8-on-macos-12-monterey/)
)

# fonts to install
declare -a fonts=(
    "font-meslo-lg-nerd-font"
    "font-meslo-for-powerline"
    "font-open-sans"
    "font-droid-sans-mono-for-powerline"
    "font-droid-sans-mono-nerd-font"
    "font-josefin-sans"
    "font-montserrat"
    "font-hack-nerd-font"
)

# other repos to download locally
declare -a repos=(
    "git@github.com:smenzer/install.sh.git"
    "git@github.com:smenzer/tools-and-scripts.git"
)

# other repos to download locally only for work
declare -a repos_work_only=(
    "git@github.com:smenzer/prebid.github.io.git" # git remote add github-id5 git@github.com:id5io/prebid.github.io.git && git remote add upstream https://github.com/prebid/prebid.github.io.git
    "git@gitlab.com:id5-sync/advertising-identity-guide.git"
    "git@gitlab.com:id5-sync/id-corp-website.git"
    "git@gitlab.com:id5-sync/id5_hosting.git"
    "git@gitlab.com:id5-sync/id5-api.js.git" # git remote add upstream git@github.com:id5io/id5-api.js.git
    "git@gitlab.com:id5-sync/id5.git"
    "git@gitlab.com:id5-sync/ops-apps.git" # git remote add clever git+ssh://git@push-n2-par-clevercloud-customers.services.clever-cloud.com/app_20e8e805-3d17-463b-bccc-a96e0be7c0ee.git
    "git@gitlab.com:id5-sync/Prebid.js.git" # git remote add github-id5 git@github.com:id5io/Prebid.js.git && git remote add upstream git@github.com:prebid/Prebid.js.git
    "git@gitlab.com:id5-sync/samples.git" # git remote add web ssh://smenzer@s00.id5-sync.com/home/smenzer/src/gitlab.com/id5/samples
    "git@gitlab.com:id5-sync/tools-ui.git"
    "git@gitlab.com:id5-sync/universal-id-decryption-java.git"
    "git@gitlab.com:id5-sync/www.git"
    "git@gitlab.com:id5-sync/zoho-crm-functions.git"
    "git@gitlab.com:id5-sync/zoho-crm-functions.git"
)

# colors
reset=$(tput sgr 0)
red=$(tput setaf 1)
green=$(tput setaf 2)
orange=$(tput setaf 208)
blue=$(tput setaf 45)
red_bg=$(tput setab 1)
green_bg=$(tput setab 2)
orange_bg=$(tput setab 208)
aqua_bg=$(tput setab 45)
black=$(tput setaf 16)
bold=$(tput bold)
ul=$(tput smul)
rul=$(tput rmul)
clear=$(tput clear)

###############################################################################
# Useful functions
###############################################################################

# green ✔
print_success() {
    printf "%s✔%s" "${green}${bold}" "${reset}"
}
# red ✘
print_error() {
    printf "%s✘%s" "${red}${bold}" "${reset}"
}
# green skipped
print_skipped() {
    printf "%sskipped%s" "${green}${bold}" "${reset}"
}

# write to error log
# $1 is the command
# $2 is the output
error_log() {
    {
        printf "ERROR with Command: %s\n" "$1"
        printf "Message: %s\n\n" "$2"
    } >> ${INSTALL_LOG}
}

# this functions is the core of mac-install.sh
# It takes a command and its parameters as input, runs the command and
# depending on its success or failure, respectively prints a green check
# or a red cross. In the latter case, it will also log its output and the
# command that failed.
run() {
    output=$(eval "$1" 2>&1)
    if [ $? -eq 0 ]; then
        print_success
    else
        print_error
        error_log $1 $output
    fi
}

# ask for a confirmation
confirm () {
    # call with a prompt string or use a default
    read -q "response?${1:-Are you sure? [y/N]} "
    case "$response" in
        ([yY][eE][sS]|[yY]) true ;;
        (*)                 false ;;
    esac
}

# Checks whether a command exists in current environment or not.
is_command() {
    command -v "${1:?No command specified}" >/dev/null 2>&1
}

# formats an amount of seconds and prints it.
print_seconds() {
    secs=$1
    if [ "$secs" -ge 3600 ]; then
        printf '%02dh %02dm %02ds\n' $((secs/3600)) $((secs%3600/60)) $((secs%60))
    else
        printf '%02dm %02ds\n' $((secs%3600/60)) $((secs%60))
    fi
}

# prints out a section header text
print_section() {
  printf "\n\n%s%s%s" "${bold}" "$1" "${reset}"
}

# prints out an action text
print_action() {
  printf "\n%s%s%s" "--[ " "$1" "${reset}"
}

# prints out a subaction text
print_subaction() {
  printf "\n%s%s%s" "    - " "$1" "${reset}"
}

# ask for password once for all. The aim is to retain it for as long as possible so
# user won't have to type it again.
#
# stores value in ${pw}
ask_for_sudo_password() {
  printf '%s) I will ask once for all your sudo password.\n   Most packages do no need it, but a few will.\n   Asking forit now prevents the script from being paused.\n\nSudo password:\n' "$1"
  read -s 'pw?> '
  printf '\n\n'
}

# ask to set the machine name. priority is:
# 1) user input
# 2) existing value from machine name file
# 3) hostname
#
# stores value in ${machine_name}
ask_for_machine_name() {
    if [ -f ${MACHINE_NAME_FILE} ]; then
        default=$(cat ${MACHINE_NAME_FILE})
    else
        default=$(hostname)
    fi
    printf "%s) What should we call this machine?\n   This will be used for dotfile configuration file names.\n\nHit Enter to use the default: ${green}${default}${reset}\n" "$1"
    read 'input_machine?> '
    if [ ! "${input_machine}" ]; then
        machine_name=${default}
    else
        machine_name="${input_machine}"
    fi
    printf '\n'
}

# get an email to use for this machine. priority is:
#  1) user input
#  2) value already existing in the git config global
#
# stores value in ${machine_email}
ask_for_machine_email() {
    # grab existing email from git;
    machine_email=$(git config --global user.email)

    printf '%s) What email address should be associated with this machine, mostly for git commits?' "$1"
    if [ ${machine_email} ]; then
        printf "\n\nHit Enter to use the default: ${green}${machine_email}${reset}\n"
    else
        printf '\n\nGit email:\n'
    fi
    read 'input_email?> '

    # use user input if provided
    if [ ${input_email} ]; then
        machine_email="${input_email}"
    fi

    printf '\n'
}

# sets a flag for whether this is a work computer or not
# work laptops get extra software installed
#
# stores value in ${is_work}
ask_for_is_work() {
    printf '%s) Is this Mac used for work? [y/n]' "$1"
    printf "\n\nHit Enter to use the default: ${green}no${reset}\n"
    if confirm '>'; then
        is_work=true
    else
        is_work=false
    fi

    printf '\n\n'
}

# sets a flag for whether this is a mac server or not
# mac servers get less software installed
#
# stores value in ${is_mac_server}
ask_for_is_mac_server() {
    printf '%s) Is this Mac used as a server? [y/n]' "$1"
    printf "\n\nHit Enter to use the default: ${green}no${reset}\n"
    if confirm '>'; then
        is_mac_server=true
    else
        is_mac_server=false
    fi
    printf '\n'
}

# whether the machine is a Mac or not
# needed to segregate mac-specific actions
is_mac() {
    if [[ `uname` == 'Darwin' ]]; then
        return 0 # a mac
    else
        return 1 # not a mac
    fi
}

# looks for git on the machine, if not, requests for it to be installed
# if on a mac, we can force this with xcode tools
check_for_git() {
    print_action 'Check that git is installed...'
    if is_command git; then
        run TRUE
        return 1 # git is good to go
    else
        run FALSE
        printf "\n%s%s%s" "${bold}" "It looks like git is not installed!" "${reset} "
        if is_mac; then
            # we can kick off xcode cli tool install
            printf "\n\nWe will kick off an xcode cli install. Check the dialog box that should pop up to finish the installation. Once it completes, come back here to continue this script.\n\n"
            xcode-select --install
        else
            # just tell the user to install git
            printf '\n\nPlease install git and then return to continue this script.'
        fi
        printf '\n'
        confirm "Has git been installed? [y/n]" || exit
    fi
}

# confirms that the user has ssh keys and has set them up in github so
# we can read/write to the repo
check_for_ssh_keys() {
    print_action 'Check that ssh key is generated...'
    FILE=~/.ssh/id_rsa.pub
    if [[ -f "$FILE" ]]; then
        run TRUE
    else
        run FALSE
        printf "\n%s%s%s\n\n%s\n\n" "${bold}" "It looks like you don't have ssh keys yet!" "${reset}" "Please run ${green}${bold}ssh-keygen${reset} and then re-run this script"
        exit 1
    fi

    printf '\n'
    if $(confirm '--[ Have you uploaded your public key to github? [y/n]') ; then
        printf '\n'
        return 1;
    else
        printf '\n\nPlease upload your public key (see below) to github (https://github.com/settings/keys) and then re-run this script\n\n'
        cat $FILE
        printf '\n'
        exit 1;
    fi
}

###############################################################################
# Beginning of the install script
###############################################################################
echo "${clear}${orange}"
if is_mac; then
    echo "███╗   ███╗ █████╗  ██████╗    ██╗███╗   ██╗███████╗████████╗ █████╗ ██╗     ██╗     ";
    echo "████╗ ████║██╔══██╗██╔════╝    ██║████╗  ██║██╔════╝╚══██╔══╝██╔══██╗██║     ██║     ";
    echo "██╔████╔██║███████║██║         ██║██╔██╗ ██║███████╗   ██║   ███████║██║     ██║     ";
    echo "██║╚██╔╝██║██╔══██║██║         ██║██║╚██╗██║╚════██║   ██║   ██╔══██║██║     ██║     ";
    echo "██║ ╚═╝ ██║██║  ██║╚██████╗    ██║██║ ╚████║███████║   ██║   ██║  ██║███████╗███████╗";
    echo "╚═╝     ╚═╝╚═╝  ╚═╝ ╚═════╝    ╚═╝╚═╝  ╚═══╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚══════╝";
else
    echo "███████╗███████╗██████╗ ██╗   ██╗███████╗██████╗     ██╗███╗   ██╗███████╗████████╗ █████╗ ██╗     ██╗     ";
    echo "██╔════╝██╔════╝██╔══██╗██║   ██║██╔════╝██╔══██╗    ██║████╗  ██║██╔════╝╚══██╔══╝██╔══██╗██║     ██║     ";
    echo "███████╗█████╗  ██████╔╝██║   ██║█████╗  ██████╔╝    ██║██╔██╗ ██║███████╗   ██║   ███████║██║     ██║     ";
    echo "╚════██║██╔══╝  ██╔══██╗╚██╗ ██╔╝██╔══╝  ██╔══██╗    ██║██║╚██╗██║╚════██║   ██║   ██╔══██║██║     ██║     ";
    echo "███████║███████╗██║  ██║ ╚████╔╝ ███████╗██║  ██║    ██║██║ ╚████║███████║   ██║   ██║  ██║███████╗███████╗";
    echo "╚══════╝╚══════╝╚═╝  ╚═╝  ╚═══╝  ╚══════╝╚═╝  ╚═╝    ╚═╝╚═╝  ╚═══╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚══════╝";
fi
echo "${reset}"

if is_command caffeinate; then
  # prevent system from sleeping on macs
  caffeinate -s -w $$ &
fi

# truncate log to zero
:> ${INSTALL_LOG}

# make sure git and ssh keys are properly installed/set up before doing anything
printf '\nBefore we start, we need to make sure your machine has all the pre-requisites\n'
check_for_git
check_for_ssh_keys

# get user input up front so the script doesn't need to pause
printf "\nAlright we're ready to go! Just a few pieces of information first...\n\n"
ask_for_sudo_password '1'
ask_for_machine_name '2'
ask_for_machine_email '3'
if is_mac; then
    ask_for_is_work '4'
    ask_for_is_mac_server '5'
fi

# Asks for user confirmation
printf '\n----------------------------------------------------------------------------\n\n'
confirm "This script will install all of your stuff. Are you ready to continue? [y/n]" || exit
printf '\n\n'

printf "OK, now sit back and relax, this is going to take a while ☕️\n"
printf "\n%s%s%s" "${bold}${orange_bg}${black}" " BEGINNING INSTALL OF ${machine_name} " "${reset}"
start=$(date +%s)

#####
## PREPARATION
#####
print_section 'PREPARING INSTALL'

## temporarily turn off things that will make installs annoying on a mac
if is_mac; then
  print_action 'Disabling Gatekeeper temporarily...'
  run 'echo $pw | sudo -S spctl --master-disable'

  print_action 'Disabling Quarantine temporarily...'
  run 'defaults write com.apple.LaunchServices LSQuarantine -bool NO'
fi

## Save Machine Name
mkdir -p ${CONFIG_VAR_DIR}
print_action "Saving machine name to file..."
run "echo \"${machine_name}\" > ${MACHINE_NAME_FILE}"

#####
## INSTALLING TERMINAL
#####
print_section 'INSTALLING TERMINAL'

## Terminal Repo
terminal_dir="${GIT_PATH}/github.com/smenzer/terminal"
print_action "Cloning terminal repo to ${terminal_dir}..."
if [ ! -d "${terminal_dir}" ]; then
    run "mkdir -p \"${terminal_dir}\""
    run "echo yes | git clone ${TERMINAL_REPO} ${terminal_dir}"
else
    print_skipped
fi

# terminal submodules
print_subaction "Initialize submodules..."
run "git -C ${terminal_dir} submodule update --init --recursive"

## BASH
print_action "Setting up BASH"

# symlink/create bash_profile
print_subaction "Symlinking .bash_profile..."
machine_bash_profile=${terminal_dir}/bash/bash_profile_${machine_name}
if [ ! -f ${machine_bash_profile} ]; then
  run "cp ${terminal_dir}/bash/bash_profile_template ${machine_bash_profile}"
fi
run "ln -sf ${machine_bash_profile} ~/.bash_profile"

# bash common
print_subaction "Symlinking .bash_common..."
run "ln -sf ${terminal_dir}/bash/bash_common ~/.bash_common"

## ZSH
print_action "Setting up ZSH"

# zshenv
zdotdir="${terminal_dir}/zdotdir"
print_subaction "Creating .zshenv..."
run "echo \"export ZDOTDIR=${zdotdir}\" > ~/.zshenv"

# symlink/create zshrc
print_subaction "Symlinking .zshrc..."
machine_zshrc=${zdotdir}/machines/${machine_name}.zshrc
if [ ! -f ${machine_zshrc} ]; then
  run "cp ${zdotdir}/machines/template.zshrc ${machine_zshrc}"
fi
run "ln -sf ${machine_zshrc} ${zdotdir}/.zshrc"

## Git
print_action "Setting up GIT"

# git config
print_subaction "Setting up gitconfig..."
machine_gitconfig=${terminal_dir}/git/machines/gitconfig_${machine_name}
if [ ! -f ${machine_gitconfig} ]; then
  run "cp ${terminal_dir}/git/gitconfig_template ${machine_gitconfig}"
fi
run "ln -sf ${machine_gitconfig} ~/.gitconfig"

print_subaction "Setting gitconfig to use ${machine_email}..."
run "git config --global user.email ${machine_email}"

# git files
print_subaction "Symlinking git dotfiles..."
run "ln -sf ${terminal_dir}/git/gitignore_global ~/.gitignore_global"
run "ln -sf ${terminal_dir}/git/git-completion.bash ~/.git-completion.bash"
run "ln -sf ${terminal_dir}/git/git-prompt.sh ~/.git-prompt.sh"

# git get
print_subaction "Installing git-get..."
if ! is_command git-get; then
    pushd ${terminal_dir}/git/git-utils/git-get >/dev/null || return
    run "export INSTALL_DIR=/usr/local/bin && ${terminal_dir}/git/git-utils/git-get/install >/dev/null"
    popd >/dev/null || return
else
    print_skipped
fi

## Dotfiles
print_action "Symlinking dotfiles"

# secrets file for passwords or other items that should not be
# under version control
print_subaction "Creating ~/.secrets..."
if [ ! -f ~/.secrets ]; then
    run 'touch ~/.secrets'
else
    print_skipped
fi

# tmux
print_subaction "tmux..."
run "ln -sf ${terminal_dir}/misc/tmux.conf ~/.tmux.conf"

# ack
print_subaction "ack..."
run "ln -sf ${terminal_dir}/misc/ackrc ~/.ackrc"

# vsqlrc
print_subaction "vsqlrc..."
run "ln -sf ${terminal_dir}/misc/vsqlrc ~/.vsqlrc"

# vim
print_subaction "vim..."
run "ln -sf ${terminal_dir}/vim ~/.vim"
run "ln -sf ${terminal_dir}/vim/vimrc ~/.vimrc"
print_subaction "Installing vim plugins..."
run 'vim +PluginInstall +qall'

## Iterm Shell
print_action "Installing iTerm2 shell integrations"
original_shell=${SHELL}

# bash
print_subaction "for BASH..."
export SHELL='/bin/bash'
run 'curl -Ls https://iterm2.com/misc/install_shell_integration.sh | bash >/dev/null'

# zsh
print_subaction "for ZSH..."
export SHELL='/bin/zsh'
run 'curl -Ls https://iterm2.com/misc/install_shell_integration.sh | zsh >/dev/null'
run 'rm ~/.zshrc' # the iterm script doens't look at ${ZDOTDIR} so it generates ~/.zshrc which we don't want

export SHELL=${original_shell}

## Set shell to zsh, if not already
print_action 'Setting ZSH as default shell...'
if [ $SHELL != "/bin/zsh" ]; then
    run 'echo $pw | chsh -s /bin/zsh'
else
    print_skipped
fi

if is_mac; then

    #####
    ## MAC APPS AND TOOLS
    #####
    print_section 'MAC APPS AND TOOLS'

    ## Install and update homebrew
    print_action "Installing Homebrew..."
    if ! is_command brew; then
        yes "" | /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)" >/dev/null 2>&1
        run 'brew doctor'
    else
        print_skipped
    fi

    ## store installed brew info so we don't have to repeated ask for it
    brew_taps=$(brew tap)
    brew_formulae=$(brew list --formula -1)
    brew_casks=$(brew list --cask -1)

    ## Brew Tap
    print_action "Tapping Brews..."
    for tap in "${taps[@]}"; do
        print_subaction "${tap}..."
        if [ $(echo $brew_taps | grep -x "$tap" ) ]; then
            print_skipped
        else
            run 'brew tap "$tap"'
        fi
    done

    ## CLI Tools
    print_action "Installing General CLI tools"
    for tool in "${mac_tools[@]}"; do
        print_subaction "$tool..."
        if ! is_command "$tool"; then
            if [ $(echo $brew_formulae | grep -x "$tool" ) ]; then
                print_skipped
            else
                run 'brew install "$tool" --no-quarantine'
            fi
        else
            print_skipped
        fi
    done

    # configure php
    print_action "configure php..."
    run 'brew link --overwrite --force php@8.1'
    # to change versions: brew unlink php && brew link --overwrite --force php@8.1

    if [ ${is_mac_server} = true ]; then
        # skip some CLI tools that we don't need on Mac servers
        print_action "Skipping non-essential CLI tools"
    else
        # CLI Tools that we don't need on Mac servers
        for tool in "${mac_tools_clients_only[@]}"; do
            print_subaction "$tool..."
            if ! is_command "$tool"; then
                if [ $(echo $brew_formulae | grep -x "$tool" ) ]; then
                    print_skipped
                else
                    run 'brew install "$tool" --no-quarantine'
                fi
            else
                print_skipped
            fi
        done
    fi

    if [ ${is_work} = true ]; then
        ## Work-specific CLI Tools
        print_action "Installing Work-specific CLI tools"
        for tool in "${tools_work_only[@]}"; do
            print_subaction "$tool..."
            if ! is_command "$tool"; then
                if [ $(echo $brew_formulae | grep -x "$tool" ) ]; then
                    print_skipped
                else
                    run 'brew install "$tool" --no-quarantine'
                fi
            else
                print_skipped
            fi
        done
    fi

    ## Python3
    print_action "Installing Python packages..."
    run 'echo $pw | sudo -S pip3 install --upgrade pip setuptools wheel'

    ## Install cask apps via brew...
    print_action "Installing brew cask apps..."
    for app in "${cask_apps[@]}"; do
        print_subaction "${app}..."
        if [ $(echo $brew_casks | grep -x "$app" ) ]; then
            print_skipped
        else
            run 'echo $pw | brew install --cask "$app" --force --no-quarantine'
        fi
    done

    if [ ${is_mac_server} = true ]; then
        # skip some cask apps that we don't need on Mac servers
        print_action "Skipping non-essential cask apps"
    else
        # cask apps that we don't need on Mac servers
        for app in "${cask_apps_clients_only[@]}"; do
            print_subaction "${app}..."
            if [ $(echo $brew_casks | grep -x "$app" ) ]; then
                print_skipped
            else
                run 'echo $pw | brew install --cask "$app" --force --no-quarantine'
            fi
        done
    fi

    if [ ${is_work} = true ]; then
        ## Install Work-specific cask apps via brew...
        print_action "Installing Work-specific brew cask apps..."
        for app in "${cask_apps_work_only[@]}"; do
            print_subaction "${app}..."
            if [ $(echo $brew_casks | grep -x "$app" ) ]; then
                print_skipped
            else
                run 'echo $pw | brew install --cask "$app" --force --no-quarantine'
            fi
        done
    fi

    ## App Store apps
    print_action "Installing App Store apps"
    for macapp in "${mac_app_store_apps[@]}"; do
        print_subaction "${macapp}..."
        run 'mas lucky "$macapp"'
    done

    if [ ${is_mac_server} = true ]; then
        # skip some app store apps that we don't need on Mac servers
        print_action "Skipping non-essential App Store apps"
    else
        # cask apps that we don't need on Mac servers
        for macapp in "${mac_app_store_apps_clients_only[@]}"; do
            print_subaction "${macapp}..."
            run 'mas lucky "$macapp"'
        done
    fi

    ## Open apps that need to be running
    print_action "Opening apps"
    declare -a apps_to_open=(
        "/Applications/Alfred 4.app"
        "/Applications/Caffeine.app"
        "/Applications/Dropbox.app"
        "/Applications/Divvy.app"
    )
    for app in "${apps_to_open[@]}"; do
        print_subaction "${app}..."
        run 'open "$app"'
    done

    #####
    ## FONTS
    #####
    print_section 'FONTS'

    ## Brew fonts
    print_action 'Installing brew fonts...'
    for font in "${fonts[@]}"; do
        print_subaction "${font}..."
        if [ $(echo $brew_casks | grep -x "$font" ) ]; then
            print_skipped
        else
            run 'brew install --cask "$font" --no-quarantine'
        fi
    done

    ## Custom fonts
    print_action "Installing custom fonts..."
    run "cp ${terminal_dir}/fonts/* ${HOME}/Library/Fonts/"

    #####
    ## MAC CONFIGURATION
    #####
    print_section 'MAC CONFIGURATION'

    ## Dock
    print_action "Setting up the dock"

    # dock folders
    print_subaction "Folders..."
    run 'dockutil --add "/Applications" --view auto --display folder --replacing "Applications" --position 1 --no-restart'
    run 'dockutil --add "$HOME/Downloads" --view list --display folder --replacing "Downloads" --position 2 --no-restart'

    # dock apps
    print_subaction "Apps..."
    declare -a dockapps=(
        # declare from bottom to top of dock
        "1Password"
        "Sublime Text"
        "Visual Studio Code"
        "Sourcetree"
        "iTerm"
        "WhatsApp"
        "Slack"
        "Google Chrome"
    )
    existing_dock_apps=$(dockutil --list)
    for dockapp in "${dockapps[@]}"; do
        if [[ $(echo "${existing_dock_apps}" | grep $dockapp) ]]; then
            run "dockutil --move \"$dockapp\" --position 1 --no-restart"
        else
            run "dockutil --add \"/Applications/$dockapp.app\" --position 1 --no-restart"
        fi
    done

    # dock remove apple stuff
    print_subaction "Remove Apple apps..."
    run 'dockutil --no-restart --remove Safari'
    run 'dockutil --no-restart --remove TV'
    run 'dockutil --no-restart --remove Podcasts'
    run 'dockutil --no-restart --remove Contacts'
    run 'dockutil --no-restart --remove Calendar'
    run 'dockutil --no-restart --remove Reminders'
    run 'dockutil --no-restart --remove Maps'
    run 'dockutil --no-restart --remove Photos'
    run 'dockutil --no-restart --remove FaceTime'
    run 'dockutil --no-restart --remove iBooks'
    run 'dockutil --no-restart --remove News'
    run 'dockutil --no-restart --remove Music'
    run 'dockutil --no-restart --remove Mail'
    run 'dockutil --no-restart --remove Launchpad'
    run 'dockutil --no-restart --remove "App Store"'
    run 'dockutil --no-restart --remove Messages'
    run 'dockutil --no-restart --remove Notes'

    # dock configure settings
    print_subaction "Configuration..."
    run 'm dock position LEFT'

    ## Finder
    print_action "Configuring Finder..."
    run 'm finder showpath NO'
    run 'm finder showextensions YES'
    run 'defaults write com.apple.finder ShowPathbar -bool true'
    run 'defaults write com.apple.finder ShowStatusBar -bool true'
    run 'defaults write -g NSDocumentSaveNewDocumentsToCloud -bool false'
    run 'defaults write com.apple.Finder FXPreferredViewStyle -string Nlsv' # list view by default
    run 'defaults write com.apple.finder QLEnableTextSelection -bool true' # allow text selection in quicklook
    run 'defaults write -g AppleInterfaceStyleSwitchesAutomatically -bool true' # automatic dark mode
    run 'defaults write com.apple.finder FXDefaultSearchScope -string SCcf' # search current folder by default
    run 'defaults write com.apple.finder NewWindowTarget -string PfDe' # new windows in home directory
    run 'echo $pw | sudo -S defaults write /Library/Preferences/com.apple.loginwindow LoginwindowText "Found this computer? Contact me at $machine_email."'

    # hot corners
    run 'defaults write com.apple.dock wvous-bl-corner -int 4' # bottom left: show desktop
    run 'defaults write com.apple.dock wvous-tl-corner -int 10' # top left: sleep displays
    run 'defaults write com.apple.dock wvous-br-corner -int 1' # bottom right: nothing
    run 'defaults write com.apple.dock wvous-tr-corner -int 1' # top right: nothing

    # show app switcher on all screens
    run 'defaults write com.apple.Dock appswitcher-all-displays -bool true'

    ## File associations
    print_action "Setting up file associations..."
    run 'duti -s com.microsoft.VSCode .md all'
    run 'duti -s com.microsoft.VSCode .php all'
    run 'duti -s com.microsoft.VSCode .js all'
    run 'duti -s com.microsoft.VSCode .sh all'
    run 'duti -s com.sublimetext.3 .ini all'
    run 'duti -s com.sublimetext.3 .py all'
    run 'duti -s com.sublimetext.3 .txt all'
    run 'duti -s com.sublimetext.3 .json all'

    ## Remove guest account
    print_action "Deactivating guest account..."
    run 'echo $pw | sudo -S /usr/bin/defaults write /Library/Preferences/com.apple.loginwindow GuestEnabled -bool NO'

    ## Enable locate database
    print_action "Enabling locate database..."
    run 'echo $pw | sudo -S launchctl load -w /System/Library/LaunchDaemons/com.apple.locate.plist'

    ## Add keychain item for fix network app
    print_action "Adding keychain item for fix-network..."
    if [[ $(security find-generic-password -l "fix-network" 2>&1) ]]; then
        print_skipped
    else
        run 'security add-generic-password -s "fix-network" -a $LOGNAME -w "$pw"'
    fi

    ## Sublime text
    ## source: https://packagecontrol.io/docs/syncing#dropbox-osx
    print_action "Setting Sublime Text syncing..."
    sublime_path="$HOME/Library/Application\ Support/Sublime\ Text/Packages"
    dropbox_path="$HOME/Dropbox/Apps\ and\ Dev/Sublime/User"
    run "rm -f ${sublime_path}/User"
    run "ln -s ${dropbox_path} ${sublime_path}"

    #####
    ## DEV ENVIRONMENT
    #####
    if [ ${is_mac_server} = false ]; then
        print_section 'DEV ENVIRONMENT'

        ## PHP (don't think we need to do this anymore since we install php manually now)
        # print_action 'Creating php.ini and making it writeable...'
        # if [ ! -f /etc/php.ini ]; then
        #     run 'echo $pw | sudo -S cp /etc/php.ini.default /etc/php.ini'
        # else
        #     print_skipped
        # fi
        # run 'echo $pw | sudo chmod 644 /etc/php.ini'

        ## Xcode CLI
        print_action 'Installing XCode CLI...'
        run 'xcode-select --install'

        ## Node.js / Gulp
        print_action 'Installing Node.js / Gulp'

        # node.js
        print_subaction 'Installing node.js v12...'
        run "source ${terminal_dir}/zdotdir/plugins/zsh-nvm/zsh-nvm.plugin.zsh && nvm install 12"
        run "echo $pw | sudo mkdir -p /usr/local/lib/node_modules"
        run "echo $pw | sudo -S chown -R $USER /usr/local/lib/node_modules"
        run 'bash ~/.nvm/nvm.sh'

        # gulp cli
        print_subaction 'Installing gulp...'
        if ! is_command gulp; then
            # TODO npm isn't found if it was just installed (since we haven't sourced and set the updated PATH)
            run 'npm install --global gulp-cli'
        else
            print_skipped
        fi

        ## Laravel / Homestead
        print_action 'Installing Laravel / Homestead'

        # envoy
        print_subaction 'Installing envoy...'
        if ! is_command envoy; then
            run 'composer global require laravel/envoy'
        else
            print_skipped
        fi

        # homestead box
        print_subaction 'Installing Homestead Vagrant box...'
        run 'vagrant box add laravel/homestead --provider virtualbox'

        # vagrant /etc/hosts updater
        print_subaction 'Install /etc/hosts updater plugin...'
        run 'vagrant plugin install vagrant-hostsupdater'
    fi

    #####
    ## OTHER REPOS
    #####
    print_section 'OTHER REPOS'
    export GIT_PATH="${GIT_PATH}"
    print_action 'Installing other repos'
    for repo in "${repos[@]}"; do
        print_subaction "${repo}..."
        run "git-get ${repo}"
    done

    if [ ${is_work} = true ]; then
        print_action 'Installing work-only repos'
        for repo in "${repos_work_only[@]}"; do
            print_subaction "${repo}..."
            run "git-get ${repo}"
        done
    fi

fi # end of mac-install

## Composer
print_action "Installing Composer..."
if ! is_command composer; then
    run "php -r \"copy('https://getcomposer.org/installer', 'composer-setup.php');\""
    EXPECTED_CHECKSUM="$(wget -q -O - https://composer.github.io/installer.sig)"
    ACTUAL_CHECKSUM="$(php -r "echo hash_file('sha384', 'composer-setup.php');")"
    if [ "$EXPECTED_CHECKSUM" != "$ACTUAL_CHECKSUM" ]; then
        print_error
        error_log "composer install" "ERROR installing composer: Invalid installer checksum"
    else
        run 'php composer-setup.php --quiet --install-dir=/usr/local/bin --filename=composer'
    fi
    run 'rm composer-setup.php'
else
    print_skipped
fi

#####
## Clean up
#####
print_section "CLEAN UP"

if is_mac; then
    print_action 'Cleaning up Mac'

    # clean up homebrew
    print_subaction "Brew cleanup..."
    run 'brew cleanup'

    # put back on the things that would have made installs annoying
    print_subaction "Re-enabling Gatekeeper..."
    run 'echo $pw | sudo -S spctl --master-enable'

    print_subaction "Re-enabling quarantine..."
    run 'defaults write com.apple.LaunchServices LSQuarantine -bool YES'
else
    print_action 'Cleaning up Server...'
    run 'TRUE' # just to get a nice checkbox until there's something to actually do here
fi

end=$(date +%s)
runtime=$((end-start))

printf "\n\nDone in %s! Have fun!\n\n" "$(print_seconds ${runtime})"

# restart zsh to get terminal settings applied
exec zsh