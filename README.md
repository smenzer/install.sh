###Configuration for terminal

**Includes vim (with plugins), screen, ack, and tmux settings**

####Installation
to install, run the following command:
```bash
bash <(curl -SsL https://raw.github.com/smenzer/terminal/master/setup.sh)
```

**machine**
: is the name that will be used to create a unique bash profile.  it will default to the machine hostname if not specified

**target**
: is the directory to install the source code to (it will be placed inside a directory called `terminal` in whatever you set as the target directory).  it will default to ~/src/github.com/smenzer/ if you don't specify a target

_before installing, ensure the machine has an ssh public key already created and that key is stored in your github and bitbucket (or wherever your bash profiles are stored) profiles_


####Uninstallation
to uninstall, run the following command:
```bash
bash <(curl -SsL https://raw.github.com/smenzer/terminal/master/uninstall.sh)
```

**target**
: is the directory the source code was originally installed to (it will be remove a directory called `terminal` in whatever you set as the target directory).  it will default to ~/src/github.com/smenzer/ if you don't specify a target
