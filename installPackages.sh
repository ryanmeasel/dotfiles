#!/bin/bash
#
# Install pkgs for Linux and OS X environments

# Colors to make output pretty
RED='\033[1;31m'
GREEN='\033[1;32m'
NC='\033[0m' # No Color


## Packages
# linux and osx pkgs
pkgs="make wget curl zsh vim git-flow tmux pyenv pyenv-virtualenv tree dos2unix"

# linux only pkgs
linux_pkgs="ttf-dejavu"

# osx only pkgs
brew_pkgs="caskroom/cask/brew-cask reattach-to-user-namespace android-platform-tools"

# osx programs distributed as binaries
brew_cask_pkgs="atom google-chrome gimp vlc iterm2 slack"


## Installation
# Linux installs
if [[ $(uname) == 'Linux' ]]; then

    printf "${GREEN}** Installing Linux packages...${NC}\n"

    # Debian
    if [[ -f /etc/debian_version ]]; then
        sudo apt-get update
        sudo apt-get install -y $pkgs $linux_pkgs
    fi

    # Red-hat
    if [[ -f /etc/redhat-release ]]; then
        sudo yum install $pkgs $linux_pkgs
    fi

    # Install docker (if not already installed)
    if [[ ! $(which docker) ]]; then
        curl -sSL https://get.docker.com/ | sh
    fi

# OS X installs
elif [[ $(uname) == 'Darwin' ]]; then

    printf "${GREEN}** Installing OS X packages...${NC}\n"

    # Install Brew (OSX package manager)
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

    # Install Brew pkgs and brew cask pacakges
    brew install $pkgs $brew_pkgs
    brew cask install $brew_cask_pkgs

    # Install .NET Version Manager (DNVM) and .NET Execution Environment (DNX)
    # for omnisharp use with Atom
    curl -sSL https://raw.githubusercontent.com/aspnet/Home/dev/dnvminstall.sh | DNX_BRANCH=dev sh && source ~/.dnx/dnvm/dnvm.sh
    dnvm install latest
    dnvm upgrade -r mono
fi

# Install python versions
pyenv install 2.7.12
pyenv install 3.5.2

# Install fasd
printf "${GREEN}** Installing fasd...${NC}\n"
wget -qO- https://github.com/clvv/fasd/archive/1.0.1.tar.gz | tar xz
cd fasd-1.0.1
make install
cd ..
rm -rf fasd-1.0.1

# Install Tmux Plugin Manager
printf "${GREEN}** Installing TMUX Plugin Manager (TPM)...${NC}\n"
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

printf "${GREEN}** Done. ✓${NC}\n"
