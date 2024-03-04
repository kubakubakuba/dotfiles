#!/usr/bin/env bash
USR=jakub
TIME=$(date +%Y-%m-%d-%H-%M-%S)
sudo nixos-rebuild switch

exit_code=$?

if [ $exit_code -eq 0 ]; then

    sudo cp -r /etc/nixos/* /home/jakub/Documents/dotfiles/NixOS
    cd /home/jakub/Documents/dotfiles/NixOS
    git add .
    git commit -m "updated nixos dotfiles $TIME"
    git push

    echo "Synced config with git."
else
    echo "Error during building NixOS. $exit_code"
fi
