### Configuration for terminal

**Includes git, bash, zsh, iterm2, vim (with plugins), screen, ack, and tmux settings**

#### Installation

_Before installing, ensure the machine has an ssh public key already created and that key is stored in your **GitHub** / **BitBucket** (or wherever your main terminal repo is stored) _

To install, run the following command:
```bash
bash <(curl -SsL https://raw.githubusercontent.com/smenzer/terminal-setup/master/setup.sh)
```
**repo**
: is the location of the main terminal repo to clone. defaults to git@github.com:smenzer/dotfiles.git, but you can override during setup

**machine**
: is the name that will be used to create a unique bash profile.  it will default to the machine hostname if not specified

**target**
: is the directory to install the source code to (it will be placed inside a directory called `terminal` in whatever you set as the target directory).  it will default to ~/src/github.com/smenzer/ if you don't specify a target


#### Uninstallation
To uninstall, run the following command:
```bash
bash <(curl -SsL https://raw.githubusercontent.com/smenzer/terminal-setup/master/uninstall.sh)
```

**target**
: is the directory the source code was originally installed to (it will be remove a directory called `terminal` in whatever you set as the target directory).  it will default to ~/src/github.com/smenzer/ if you don't specify a target
