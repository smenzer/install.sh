###Configuration for terminal

**Includes vim (with plugins), screen, ack, and tmux settings**

####Installation
to install, run the following command:
```bash
curl -SsL https://raw.github.com/smenzer/terminal/master/setup.sh | bash [-s machine [target]]
```
	
**machine**
: is the name that will be used to create a unique bash profile.  it will default to the machine hostname if not specified

**target** 
: is the directory to install the source code to.  it will default to ~/src/github.com/smenzer/terminal if you don't specify it

_before installing, ensure the machine has an ssh public key already created and that key is stored in your github profile_


####Uninstallation
to uninstall, run the following commans:
```bash
curl -SsL https://raw.github.com/smenzer/terminal/master/uninstall.sh | bash [-s target]
```

**target**
: is the directory to install the source code to.  it will default to ~/src/github.com/smenzer/terminal if you don't specify it
