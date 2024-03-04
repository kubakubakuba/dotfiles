#!/usr/bin/env bash
USR=jakub
FOLDER=/home/$USR/Documents/dotfiles/NixOS
TIME=$(date +%Y-%m-%d-%H-%M-%S)
sudo nixos-rebuild switch

exit_code=$?

if [ $exit_code -eq 0 ]; then

    sudo cp -r /etc/nixos/* $FOLDER
    cd $FOLDER
    git add .
    git commit -m "updated nixos dotfiles $TIME"
    git push

    echo "Synced config with git."
else
    echo "Error during building NixOS. $exit_code"
fi
