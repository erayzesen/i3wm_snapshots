#!/bin/sh
#Colors
c_cyan="\e[0;36m"
c_red="\e[0;31m"
c_green="\e[0;32m"
c_yellow="\e[0;33m"
c_def="\e[0m"

script_path=$(readlink -f "$0")
script_dir=$(dirname "$script_path")
is_name_entered=0
echo "${c_cyan} ## Welcome to i3 Snapshot Creator Tool! ## ${c_def}"
echo "This tool saving i3,polybar,nvim config files to your specific folder. "
echo "This project created by ${c_green}Eray Zesen ${c_def} under the licence MIT."
echo "https://github.com/erayzesen/i3_snapshots"
if [ -z ${1} ]
then
	echo "${c_red}Please enter configs folder name as a parameter.(like 'i3_config_saver.sh gruvbox' )${c_def} "
else
	echo "The name of the configs is ${c_yellow}'$1' ${c_def}"
	is_name_entered=1
fi
#Creating folder
if [ $is_name_entered -eq 0 ] 
then
	exit 1
fi

if [ -d "$script_dir/$1" ]
then
	echo "Overwrite a theme config files to named by ${c_yellow}'$1' ${c_def}... "
else
	echo " Creating a folder named by ${c_yellow}'$1' ${c_def} and writing config files on it..."
	mkdir $script_dir/$1
	cd $script_dir/$1

fi
#Creating folder and files
target_dir=$script_dir/$1
# for i3 folder
if ! [ -d "$target_dir/i3" ]
then
	mkdir $target_dir/i3
fi
cp ~/.config/i3/config "$target_dir"/i3

# for polybar folder
if ! [ -d "$target_dir/polybar" ]
then
	mkdir $target_dir/polybar
fi
cp ~/.config/polybar/config.ini "$target_dir"/polybar
# for nvim folder
if ! [ -d "$target_dir/nvim" ]
then
	mkdir $target_dir/nvim
fi
cp ~/.config/nvim/init.vim "$target_dir"/nvim
# for rofi folder
if ! [ -d "$target_dir/rofi" ]
then
	mkdir $target_dir/rofi
fi
cp ~/.config/rofi/config.rasi "$target_dir"/rofi
cp -r /usr/share/rofi/themes "$target_dir"/rofi/themes
