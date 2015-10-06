# dotfiles
A collection of configuration files and installation scripts used to initialize new environments (new computer, VM, container, etc).
Compatible with Linux and OS X.

## Configuartion

- Shell
  - [Zsh](http://www.zsh.org/)
  - [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh) framework
  - [Antigen](https://github.com/zsh-users/antigen) package manager
  - [Pure](https://github.com/sindresorhus/pure) theme
- Editor
  - In terminal: [vim](http://www.vim.org/)
  - GUI: [Atom](https://atom.io/)
- Version Control
  - [git](https://git-scm.com/)
  - [git-flow](https://github.com/nvie/gitflow)

## Installation Files

- `installPackages.sh`: Installs a collection of common packages I use including wget, curl, zsh, autojump, vim, git-flow, etc.
- `installDotfiles.sh`: Installs the configuration files by backing up existing configuration files
(into /path/to/this/repo/backup/) and replacing them with symlinks to the files in this repo. It also
attempts to change the shell to Zsh.
- `installAll.sh`: Executes the other two scripts. Packages are installed first.


## Installation

```Shell
git clone --recursive https://github.com/ryanmeasel/dotfiles.git
cd dotfiles
./installAll.sh
```

## To do

- Include Atom configuration
- Update vimrc and theme
- Prune gitconfig and change merge/diff tool
