#!/bin/bash
#
# Setup symlinks for the dotfiles

# Colors to make output pretty
RED='\033[1;31m'
GREEN='\033[1;32m'
NC='\033[0m' # No Color

# Grab a list of each non-directory/license/readme/backup/install file in the dotfiles repo
dotfiles=$(ls | grep -v "README" | grep -v "LICENSE" | grep -v "antigen" | grep -v "backup"| grep -v "install")
dotfiles=$(echo $dotfiles | tr '\n' ' ') # remove newlines so we can append the antigen file

# Get the dir we are executing from
repoDir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# Function to create a backup dir. Only invoked if a backup needs to be stored.
createBackupDir () {
    # Create the backup directory if it doesn't exist
    if [[ ! -d $repoDir/backup ]]; then
        mkdir -p $repoDir/backup
        printf "${GREEN}++ Created $repoDir/backup${NC}\n"
    fi
}

# Create symlinks for each of the dotfiles
printf "Generating symlinks...\n"
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
            if [[ $(diff $dotfile $targetFile) ]]; then
                
                createBackupDir

                cp $targetFile $repoDir/backup/$dotfile
                printf "$HOME/.$dotfile is a symbolic link to $targetFile\n" 
                printf ":: Copied $targetFile to $repoDir/backup\n"
            fi 
        fi
    fi

    # Create the symlink
    printf "${GREEN}++ Generated symlink to $dotfile${NC}\n"
    ln -sf $repoDir/$dotfile $HOME/.$dotfile
done

# Symlink Antigen (oh-my-zsh package manager)
printf "${GREEN}++ Generated symlink to Antigen${NC}\n"
ln -sf $repoDir/antigen/antigen.zsh $HOME/.antigen.zsh

# Change shell to zsh
if [[ $(< /etc/shells grep zsh) ]]; then

    printf "Changing shell to ZSH...\n"

    if [[ ! $(echo $SHELL) == $(which zsh) ]]; then
        chsh -s $(which zsh)
        printf "${GREEN}:: Shell changed to ZSH${NC}\n"
    else
        printf "ZSH is already running.\n"
    fi

    source $HOME/.zshrc

else
    printf "${RED}** ZSH has not been installed${NC}\n"
fi
