#!/bin/sh
#
# Setup symlinks for the dotfiles

# Create a symlink for each non-directory/license/readme/install file in the dotfiles repo
repoDir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )   # dir of the dotfiles repo
dotfiles=$(find . \( ! -regex '.*/\..*' \) -type f -maxdepth 1 | grep -v "README" | grep -v "LICENSE" | grep -v "install")

for dotfile in $dotfiles; do

    # Store any previously existing dotfiles in a backup directory
    if [[ -e $HOME/.$dotfile ]]; then

        # Create the backup directory if it doesn't exist
        if [[ ! -d $repoDir/backup ]]; then
            mkdir -p $repoDir/backup
        fi

        echo "WARNING: $HOME/.$dotfile already existed. It has been moved to $repoDir/backup."
        mv $HOME/.$dotfile $repoDir/backup/$dotfile
    fi

    echo "Generating symlink to $dotfile..."
    ln -s $dotfilesDir/$dotfile $HOME/.$dotfile
done

# Symlink antigen (oh-my-zsh package manager)
ln -s $dotfilesDir/antigen/antien.zsh $HOME/.antigen.zsh

# Change shell to zsh
if [ $(< /etc/shells grep zsh) ]; then

    echo "Changing to ZSH..."

    if [[ ! $(echo $SHELL) == $(which zsh) ]]; then
        chsh -s $(which zsh)
        echo "Shell changed to ZSH."
    else
        echo "ZSH is already running."
    fi

    source $HOME/.zshrc

else
    echo "WARNING: ZSH has not been installed."
fi
