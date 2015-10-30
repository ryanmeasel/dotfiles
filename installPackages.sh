#!/bin/bash
#
# Install pkgs for linux and OS X environments

# Colors to make output pretty
RED='\033[1;31m'
GREEN='\033[1;32m'
NC='\033[0m' # No Color

# linux and osx pkgs
pkgs="wget curl zsh vim git-flow tmux"
# linux only pkgs
linux_pkgs="ttf-dejavu"
# osx only pkgs
brew_pkgs="caskroom/cask/brew-cask reattach-to-user-namespace"
# osx programs distributed as binaries
brew_cask_pkgs="atom google-chrome gimp vlc"

# Linux installs
if [[ $(uname) == 'Linux' ]]; then

    print "${GREEN}** Installing Linux packages...${NC}\n"

    # Debian
    if [[ -f /etc/debian_version ]]; then
        sudo apt-get update
        sudo apt-get install -y --no-install-recommended $pkgs $linux_pkgs
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

    print "${GREEN}** Installing OS X packages...${NC}\n"

    # Install Brew (OSX package manager)
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

    # Install Brew pkgs and brew cask pacakges
    brew install $pkgs $brew_pkgs
    brew cask install $brew_cask_pkgs
fi

# Install fasd
print "${GREEN}** Installing fasd...${NC}\n"
wget -qO- https://github.com/clvv/fasd/archive/1.0.1.tar.gz | tar xz
cd fasd-1.0.1
make install
cd ..
rm -rf fasd-1.0.1

print "${GREEN}** Done. ✓${NC}\n"
