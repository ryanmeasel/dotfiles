# dotfiles
A collection of configuration files and installation scripts used to initialize new environments (new computer, VM, container, etc).
Compatible with Linux and OS X.

## Configuartion

- [Zsh](http://www.zsh.org/)
- [Antibody](https://getantibody.github.io/) package manager
- [Pure](https://github.com/sindresorhus/pure) theme

## Scripts

- `install-packages.sh`: Installs a collection of common packages.
- `install-dotfiles.sh`: Installs the configuration files by backing up existing configuration files
(into /path/to/this/repo/backup/) and replacing them with symlinks to the files in this repo. It also
attempts to change the shell to Zsh.
- `install-all.sh`: Executes the other two scripts. Packages are installed first.


## Installation

### OS X

```Shell
xcode-select --install
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew install git
git clone https://github.com/ryanmeasel/dotfiles.git
cd dotfiles
./installAll.sh
```

### Debian

```Shell
apt-get install git
git clone https://github.com/ryanmeasel/dotfiles.git
cd dotfiles
./installAll.sh
```