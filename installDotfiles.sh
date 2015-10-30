#!/bin/bash
#
# Setup symlinks for the dotfiles

# Colors to make output pretty
RED='\033[1;31m'
GREEN='\033[1;32m'
NC='\033[0m' # No Color

# Get the dir we are executing from
repoDir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# Grab a list of each non-directory/license/readme/backup/install file in the dotfiles repo
dotfiles=$(ls $repoDir/conf/)
dotfiles=$(echo $dotfiles | tr '\n' ' ') # remove newlines so we can append the antigen file

# Ensure the Antigen submodule was downloaded
if [[ ! -e $repoDir/antigen/antigen.zsh ]]; then
    printf "${RED}** Antigen submodule has not been downloaded. Install with:\n\n\t git submodule update --init --recursive\n${NC}"
    exit 1
fi

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
    ln -sf $repoDir/conf/$dotfile $HOME/.$dotfile
    printf "${GREEN}++ Generated symlink to $dotfile${NC}\n"
done

# Gather platform dependent configs
localDotfiles=$(ls $repoDir/conf/ | grep $(uname))

# Symlink platform dependent configs
for dotfile in $localDotfiles; do

    targetFile=$(echo $dotfile | awk  -F'-' '{print $1}')

    ln -sf $repoDir/conf/$dotfile $HOME/.$targetFile
    printf "${GREEN}++ Generated symlink to $dotfile${NC}\n"
done

# Symlink Antigen (oh-my-zsh package manager)
ln -sf $repoDir/antigen/antigen.zsh $HOME/.antigen.zsh
printf "${GREEN}++ Generated symlink to Antigen${NC}\n"

# Change shell to zsh
if [[ $(command -v zsh) ]]; then

    printf "Changing shell to ZSH...\n"

    if [[ $SHELL != $(command -v zsh) ]]; then

        # Add to the shells list if it's not already on it
        if [[ ! $(< /etc/shells grep $(command -v zsh)) ]]; then
            sudo bash -c "echo $(command -v zsh) >> /etc/shells"
        fi

        chsh -s $(command -v zsh)
        printf "${GREEN}:: Shell changed to ZSH${NC}\n"
    else
        printf "ZSH is already running.\n"
    fi

    # Execute the new shell
    $(command -v zsh)
else
    printf "${RED}** ZSH has not been installed${NC}\n"
fi
