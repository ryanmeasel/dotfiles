#!/bin/sh
#
# Install packages for linux and OS X environments

# linux and osx packages
packages="wget curl zsh autojump vim git-flow"
# osx only programs
brew_packages="caskroom/cask/brew-cask"
# osx programs distributed as binaries
brew_cask_packages="atom google-chrome gimp vlc"

# Linux installs
if [[ $(uname) == 'Linux' ]]; then

    echo "Installing Linux packages..."

    # Red-hat
    if [[ -f /etc/debian_version ]]; then
        sudo apt-get install $programs
    fi

    # Debian
    if [[ -f /etc/redhat-release ]]; then
        sudo yum install $programs
    fi

    # Install docker
    curl -sSL https://get.docker.com/ | sh

# OS X installs
elif [[ $(uname) == 'Darwin' ]]; then

    echo "Installing OS X packages..."

    # Install Brew (OSX package manager)
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

    # Install Brew packages and brew cask pacakges
    brew install $brew_programs
    # brew cask install $brew_cask_packages
fi
