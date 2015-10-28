#!/bin/bash
#
# Install pkgs for linux and OS X environments

# linux and osx pkgs
pkgs="wget curl zsh vim git-flow tmux"
# osx only programs
brew_pkgs="caskroom/cask/brew-cask"
# osx programs distributed as binaries
brew_cask_pkgs="atom google-chrome gimp vlc"

# Linux installs
if [[ $(uname) == 'Linux' ]]; then

    echo "Installing Linux packages..."

    # Debian
    if [[ -f /etc/debian_version ]]; then
        sudo apt-get update
        sudo apt-get install -y $pkgs
    fi

    # Red-hat
    if [[ -f /etc/redhat-release ]]; then
        sudo yum install $pkgs
    fi

    # Install docker (if not already installed)
    if [[ ! $(which docker) ]]; then
        curl -sSL https://get.docker.com/ | sh
    fi

# OS X installs
elif [[ $(uname) == 'Darwin' ]]; then

    echo "Installing OS X packages..."

    # Install Brew (OSX package manager)
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

    # Install Brew pkgs and brew cask pacakges
    brew install $brew_programs
    # brew cask install $brew_cask_pkgs
fi

# Install fasd
echo "Installing fasd..."
wget -qO- https://github.com/clvv/fasd/archive/1.0.1.tar.gz | tar xz
cd fasd-1.0.1
make install
cd ..
rm -rf fasd-1.0.1

echo "Done."
