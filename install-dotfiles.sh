#!/bin/bash
#
# Setup symlinks for the dotfiles

# Colors to make output snazzy
RED='\033[1;31m'
GREEN='\033[1;32m'
NC='\033[0m' # No Color

# Get the dir we are executing from
repoDir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# Grab a list of each non-directory/license/readme/backup/install file in the dotfiles repo
dotfiles=$(ls -p $repoDir/conf/ | grep -v /)
dotfiles=$(echo $dotfiles | tr '\n' ' ') # remove newlines so we can append the antigen file

# Function to create a backup dir. Only invoked if a backup needs to be stored.
createBackupDir () {
    # Create the backup directory if it doesn't exist
    if [[ ! -d $repoDir/backup ]]; then
        mkdir -p $repoDir/backup
        printf "${GREEN}++ Created $repoDir/backup${NC}\n"
    fi
}

# Create symlinks for each of the dotfiles
for dotfile in $dotfiles; do

    # Store any previously existing dotfiles in a backup directory
    if [[ -f $HOME/.$dotfile ]]; then

        # Move files / copy symlink targets to the backup dir
        if [[ ! -L $HOME/.$dotfile ]]; then             # regular file

            createBackupDir

            mv $HOME/.$dotfile $repoDir/backup/$dotfile
            printf "$HOME/.$dotfile already exists...\n"
            printf ":: Moved $HOME/.$dotfile to $repoDir/backup\n"

        else                                            # symlink

            # Get the target of the symlink
            targetFile=$(ls -l $HOME/.$dotfile | awk '{print $11}')

            # Only make a backup if we aren't symlinking to the same file
            if [[ $(diff conf/$dotfile $targetFile) ]]; then

                createBackupDir

                cp $targetFile $repoDir/backup/$dotfile
                printf "$HOME/.$dotfile is a symbolic link to $targetFile\n"
                printf ":: Copied $targetFile to $repoDir/backup\n"
            fi
        fi
    fi

    # Create the symlink
    ln -sf $repoDir/conf/$dotfile $HOME/.$dotfile
    printf "${GREEN}++ Generated symlink to $dotfile${NC}\n"
done

# Symlink VS Code settings
if [[ $(uname) == 'Linux' ]]; then
    ln -sf $repoDir/conf/vscode/settings.json $HOME/.config/Code/User/settings.json
elif [[ $(uname) == 'Darwin' ]]; then
    ln -sf $repoDir/conf/vscode/settings.json $HOME/Library/Application\ Support/Code/User/
fi

printf "${GREEN}++ Generated symlink to vscode/settings.json{NC}\n"

# Gather platform dependent configs
localDotfiles=$(ls $repoDir/conf/ | grep $(uname))

# Symlink platform dependent configs
for dotfile in $localDotfiles; do

    targetFile=$(echo $dotfile | awk  -F'-' '{print $1}')

    ln -sf $repoDir/conf/$dotfile $HOME/.$targetFile
    printf "${GREEN}++ Generated symlink to $dotfile${NC}\n"
done

# Solarized theme for Vim
mkdir -p ~/.vim/colors
wget -P ~/.vim/colors https://raw.githubusercontent.com/altercation/vim-colors-solarized/master/colors/solarized.vim > /dev/null
printf "${GREEN}++ Installed Solarized theme for VIM.\n"

# Change shell to zsh
if [[ $(command -v zsh) ]]; then

    printf "${GREEN}++ Changing shell to ZSH...${NC}\n"

    if [[ $SHELL != $(command -v zsh) ]]; then

        # Add to the shells list if it's not already on it
        if [[ ! $(< /etc/shells grep $(command -v zsh)) ]]; then
            sudo bash -c "echo $(command -v zsh) >> /etc/shells"
        fi

        chsh -s $(command -v zsh)
        printf "${GREEN}++ Shell changed to ZSH.${NC}\n"
    else
        printf "${GREEN}++ ZSH is already running.${NC}\n"
    fi
else
    printf "${RED}** ZSH has not been installed. Please install ZSH and rerun this script.${NC}\n"
    exit 1
fi

# Instruct to configure iTerm2
if [[ $(uname) == 'Darwin' ]]; then
    printf "\n\n${GREEN}++ To configure iTerm 2, 'Preferences -> General -> Load preferences from a custom folder or URL'.${NC}\n"
fi
