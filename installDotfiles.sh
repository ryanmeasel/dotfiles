#!/bin/bash
#
# Setup symlinks for the dotfiles

# Grab a list of each non-directory/license/readme/backup/install file in the dotfiles repo
dotfiles=$(ls | grep -v "README" | grep -v "LICENSE" | grep -v "antigen" | grep -v "backup"| grep -v "install")
dotfiles=$(echo $dotfiles | tr '\n' ' ') # remove newlines so we can append the antigen file

# Get directory we are executing from
repoDir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# Create symlinks for each of the dotfiles
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
    ln -sf $repoDir/$dotfile $HOME/.$dotfile
done

# Symlink Antigen (oh-my-zsh package manager)
echo "Generating symlink to Antigen..."
ln -sf $repoDir/antigen/antigen.zsh $HOME/.antigen.zsh

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
