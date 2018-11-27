#!/bin/bash
#
# Install packages and dotfiles


if ! ./install-packages.sh; then
    exit 1
fi

./install-dotfiles.sh
