#!/bin/bash
sudo apt install polybar
sudo apt install rofi
sudo apt install picom
sudo apt install feh
sudo apt install flameshot
echo 'Copying i3 config files...'
sudo cp -f -r /media/eray/SHARED_DISK/Github/i3wm_snapshots/gruvbox_snap/config/i3 ~/.config/
echo 'Copying Polybar config files...'
sudo cp -f -r config/polybar ~/.config/
echo 'Copying Neovim config files...'
sudo cp -f -r config/nvim ~/.config/
echo 'Copying Rofi config files...'
sudo cp -f -r config/rofi ~/.config/
echo 'Copying Rofi theme files...'
sudo cp -f -r theme/rofi/themes /usr/share/rofi/
echo 'Copying wallpapers...'
sudo cp -f -r Wallpapers $(eval echo ~/Pictures)
echo 'Restarting i3wm...'
i3-msg restart
