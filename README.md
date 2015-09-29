# dotfiles
This repository is a collection of configuration files and installation scripts to initialize new environments (new computer, VM, container, etc). 

## Configuartion

- Shell
  - [ZSH](http://www.zsh.org/)
  - [oh-my-zsh framework](https://github.com/robbyrussell/oh-my-zsh) 
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
- `installDotfiles.sh`: Installs the configuration files by backuping existing configuration files (into /path/to/this/repo/backup/)
and replacing them with symlinks to the files in this repo.
- `installAll.sh`: Invokes the other two scripts. Packages are istalled first. 


## Installation

```Shell
git clone https://github.com/ryanmeasel/dotfiles.git
cd dotfiles
./installAll.sh
```

## To do

- Include Atom configuration
