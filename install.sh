#!/bin/zsh
# usage: zsh <(curl -SsL https://raw.githubusercontent.com/smenzer/terminal-setup/master/mac-install.sh)
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

# colors
reset="$(tput sgr 0)"
red="$(tput setaf 1)"
green="$(tput setaf 2)"
orange="$(tput setaf 208)"
blue="$(tput setaf 45)"
aqua_bg=$(tput setab 45)
green_bg=$(tput setab 2)
orange_bg=$(tput setab 208)
black=$(tput setaf 16)
bold="$(tput bold)"
ul=$(tput smul)
rul=$(tput rmul)
clear="$(tput clear)"

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

# confirm function
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
  printf '1) I will ask once for all your sudo password.\n   Most packages do no need it, but a few will.\n   Asking it now prevents the script from being paused.\n\nSudo password:\n'
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
    printf "2) What should we call this machine?\n   This will be used for dotfile configuration file names.\n\nHit Enter to use the default: ${green}${default}${reset}\n"
    # printf '\n\nMachine name\n'
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

    printf '3) What email address should be associated with this machine, mostly for git commits?'
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

# whether the machine is a Mac or not
# needed to segregate mac-specific actions
is_mac() {
    if [[ `uname` == 'Darwin' ]]; then
        return 0 # a mac
    else
        return 1 # not a mac
    fi
}

###############################################################################
# Beginning of the install script
###############################################################################
echo "${clear}${orange}"
if [[ is_mac ]]; then
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

# Asks for user confirmation
confirm "This script will install all of your stuff. Continue? [y/n]" || exit
printf '\n\n'

if is_command caffeinate; then
  # prevent system from sleeping on macs
  caffeinate -s -w $$ &
fi

# truncate log to zero
:> ${INSTALL_LOG}

# get user input up front so the script doesn't need to pause
ask_for_sudo_password
ask_for_machine_name
ask_for_machine_email

printf "OK, now sit back and relax, this is going to take a while ☕️\n"
printf "\n%s%s%s" "${bold}${orange_bg}${black}" " BEGINNING INSTALL OF ${machine_name} " "${reset}"
start=$(date +%s)

#####
## PREPARATION
#####
print_section 'PREPARING INSTALL'

## temporarily turn off things that will make installs annoying on a mac
if [[ is_mac ]]; then
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
    run "git clone ${TERMINAL_REPO} ${terminal_dir}"
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
    pushd ${terminal_dir}/git/git-utils/git-get >/dev/null
    run "export INSTALL_DIR=/usr/local/bin && ${terminal_dir}/git/git-utils/git-get/install >/dev/null"
    popd >/dev/null
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

## Composer
print_action "Installing Composer..."
if ! is_command composer; then
    run "php -r \"copy('https://getcomposer.org/installer', 'composer-setup.php');\""
    EXPECTED_CHECKSUM="$(wget -q -O - https://composer.github.io/installer.sig)"
    ACTUAL_CHECKSUM="$(php -r "echo hash_file('sha384', 'composer-setup.php');")"
    if [ "$EXPECTED_CHECKSUM" != "$ACTUAL_CHECKSUM" ]; then
        print_error()
        error_log "composer install" "ERROR installing composer: Invalid installer checksum"
    else
        run 'php composer-setup.php --quiet --install-dir=/usr/local/bin --filename=composer'
    fi
    run 'rm composer-setup.php'
else
    print_skipped
fi

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
    run 'chsh -s /bin/zsh'
else
    print_skipped
fi

if [[ is_mac ]]; then

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

    ## Install Homebrew cask
    print_action "Installing Homebrew Cask"
    run 'brew tap homebrew/cask'

    ## Install Homebrew cask upgrade
    print_action "Installing Homebrew Cask Upgrade..."
    run 'brew tap buo/cask-upgrade'

    ## CLI Tools
    print_action "Installing CLI tools"
    declare -a tools=(
        "exiftool" # read and edit exif information
        "ack" # search, like grep but better
        "coreutils" # requird for lots of stuff
        "jq" # json processor
        "wget" # retrieve remote files
        "autojump" # move to directories with "j term"
        "gh" # github cli
        "python3" # python

        "thefuck" # correct errors in previous commands
        "dockutil" # Tool for managing dock items
        "speedtest-cli" # run speed tests from the commandline
        "shellcheck" # linter for bash shell scripts
        "mas" # mac app store CLI
        "m-cli" # mac CLI
        "switchaudio-osx" # change macOS audio source from the command-line
        "duti" # select default apps for documents and URL schemes
        "svn" # required for some fonts, and probably other things
    )
    for tool in "${tools[@]}"; do
        print_subaction "Installing $tool..."
        if ! is_command "$tool"; then
            run 'brew install "$tool"'
        else
            print_skipped
        fi
    done

    ## Python3
    print_action "Installing Python packages..."
    run 'echo $pw | sudo -S pip3 install --upgrade pip setuptools wheel'

    ## Install apps via brew...
    print_action "Installing brew apps..."
    declare -a apps=(
        "iterm2" # terminal
        "alfred" # command / app launcher
        "visual-studio-code" # ide
        "sourcetree" # source control ui
        "postman" # http request ui for api dev
        "slack" # messaging platform
        "google-chrome" # primary browser
        "dropbox" # cloud files
        "1password" # password manager
        "divvy" # window management
        "sublime-text" # text editor
        "spotify" # music
        "spotmenu" # spotify menu bar
        "adobe-creative-cloud" # adobe apps
        "caffeine" # prevent sleep
        "vlc" # play all videos
        "gpg-suite" # encryption
        "dbeaver-community" # ui for db
        "osxfuse" # mount remote drives
        "nordvpn" # vpn
        "whatsapp" # whatsapp for desktop
        "virtualbox" # virtual machines
        "vagrant" # dev environment for laravel
        "cheatsheet" # hold ⌘ in an app to see all shortcuts
        "appcleaner" # delete all extra files from an app
        "angry-ip-scanner" # network scanner
        "runjs" # javascript playground
    )
    for app in "${apps[@]}"; do
        print_subaction "Installing ${app}..."
        # if [ $(brew list --cask | grep "$app" ) ]; then
        #     print_skipped
        # else
        #     run 'brew cask install "$app" --force'
        # fi
    done

    ## Install apps that need password
    print_action "Installing apps with password..."
    declare -a apps=(
        "microsoft-teams"
    )
    for app in "${apps[@]}"; do
        print_subaction "Installing ${app}..."
        if [ $(brew list --cask | grep "$app" ) ]; then
            print_skipped
        else
            run 'echo $pw | brew cask install "$app"'
        fi
    done

    ## App Store apps
    print_action "Installing App Store apps"
    declare -a macapps=(
        "meeter"
        # "paprika"
    )
    for macapp in "${macapps[@]}"; do
        print_subaction "Installing ${macapp}..."
        run 'mas lucky "$macapp"'
    done

    ## Open apps that need to be running
    print_action "Opening apps"
    declare -a apps_to_open=(
        "/Applications/Alfred 4.app"
        "/Applications/Dropbox.app"
    )
    for app in "${apps_to_open[@]}"; do
        print_subaction "Opening ${app}..."
        run 'open "$app"'
    done

    #####
    ## FONTS
    #####
    print_section 'FONTS'

    ## Brew fonts
    print_action 'Installing brew fonts...'
    run 'brew tap homebrew/cask-fonts'
    declare -a fonts=(
        "font-meslo-lg-nerd-font"
        "font-meslo-for-powerline"
        "font-open-sans"
        "font-droid-sans-mono-for-powerline"
        "font-droid-sans-mono-nerd-font"
        "font-josefin-sans-std-light"
        "font-montserrat"
    )
    for font in "${fonts[@]}"; do
        print_subaction "Installing ${font}..."
        # run 'brew cask install "$font"'
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
        "Activity Monitor"
        "1Password 7"
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

    # dock configure settings
    print_subaction "Configuration..."
    run 'm dock position RIGHT'

    ## Finder
    print_action "Configuring Finder..."
    run 'm finder showpath NO'
    run 'm finder showextensions YES'
    run 'defaults write com.apple.finder ShowPathbar -bool true'
    run 'defaults write com.apple.finder ShowStatusBar -bool true'
    run 'defaults write -g NSDocumentSaveNewDocumentsToCloud -bool false'
    run 'defaults write com.apple.finder QLEnableTextSelection -bool TRUE' # allow text selection in quicklook
    run 'echo $pw | sudo -S defaults write /Library/Preferences/com.apple.loginwindow LoginwindowText "Found this computer? Contact me at $machine_email."'

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

    sublime_path="$HOME/Library/Application Support/Sublime Text 3/Packages/User/"
    dropbox_path="$HOME/Dropbox/Apps and Dev/Sublime/User/"
    if [ -d ${dropbox_path} ]; then
        run "rm -r \"${sublime_path}\""
        run "ln -sf \"${dropbox_path}\" \"${sublime_path}\""
    else
        print_error
        error_log "symlink sublime text settings" "${dropbox_path} does not exist! Manually execute the symlink to ${sublime_path}"
    fi

    #####
    ## DEV ENVIRONMENT
    #####
    print_section 'DEV ENVIRONMENT'

    ## PHP
    print_action 'Creating php.ini and making it writeable...'
    if [ ! -f /etc/php.ini ]; then
        run 'echo $pw | sudo -S cp /etc/php.ini.default /etc/php.ini'
    else
        print_skipped
    fi
    run 'echo $pw | sudo chmod 644 /etc/php.ini'

    ## Xcode CLI
    print_action 'Installing XCode CLI...'
    run 'xcode-select --install'

    ## NVM / Node.js / Gulp
    print_action 'Installing NVM / Node.js / Gulp'

    # # nvm
    # print_subaction 'Installing nvm v0.37.2...'
    # if ! is_command nvm; then
    #     run 'curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash'
    # else
    #     print_skipped
    # fi

    # node.js
    print_subaction 'Installing node.js v12...'
    run "source ${terminal_dir}/zdotdir/plugins/zsh-nvm/zsh-nvm.plugin.zsh && nvm install 12"
    run "echo $pw | sudo mkdir -p /usr/local/lib/node_modules"
    run "echo $pw | sudo -S chown -R $USER /usr/local/lib/node_modules"

    # gulp cli
    print_subaction 'Installing gulp...'
    if ! is_command gulp; then
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

    #####
    ## OTHER REPOS
    #####
    print_section 'OTHER REPOS'

    declare -a repos=(
        'git@github.com:smenzer/tools-and-scripts.git'
    )
    for repo in "${repos[@]}"; do
        print_action "Installing ${repo}..."
        run "git-get ${repo}"
    done

fi # end of mac-install

#####
## Clean up
#####
print_section "CLEAN UP"

if [[ is_mac ]]; then
    print_action 'Cleaning up Mac'

    # clean up homebrew
    print_subaction "Brew cleanup..."
    run 'brew cleanup'

    # put back on the things that would have made installs annoying
    print_subaction "Re-enabling Gatekeeper..."
    run 'echo $pw | sudo -S spctl --master-enable'

    print_subaction "Re-enabling quarantine..."
    run 'defaults write com.apple.LaunchServices LSQuarantine -bool YES'

    complete_message='Mac installation complete'
else
    print_action 'Cleaning up Server...'
    run 'TRUE' # just to get a nice checkbox until there's something to actually do here

    complete_message='Server installation complete'
fi

end=$(date +%s)
runtime=$((end-start))

printf "\n\n\nDone in %s! Have fun!\n\n\n\n" "$(print_seconds ${runtime})"
# say -v Moira "${complete_message}"

# restart zsh to get terminal settings applied
exec zsh