#!/bin/bash

#Colors
c_cyan="\e[0;36m"
c_red="\e[0;31m"
c_green="\e[0;32m"
c_yellow="\e[0;33m"
c_def="\e[0m"

script_path=$(readlink -f "$0")
script_dir=$(dirname "$script_path")
is_name_entered=0
echo -e  "${c_cyan} ## Welcome to i3wm Snapshot Creator Tool! ## ${c_def}"
echo "This tool saving i3wm,polybar,nvim config files, wallpapers and themes to your specific named folder. "
echo -e "This project created by ${c_green}Eray Zesen ${c_def} under the licence MIT."
echo "https://github.com/erayzesen/i3wm_snapshots"
if [ -z ${1} ]
then
	echo -e "${c_red}Please enter configs folder name as a parameter.(like 'create_i3wm_snapshot.sh gruvbox' )${c_def} "
else
	echo -e  "The name of the configs is ${c_yellow}'$1' ${c_def}"
	is_name_entered=1
fi
#Creating folder
if [ $is_name_entered -eq 0 ] 
then
	exit 1
fi

if [ -d "$script_dir/$1" ]
then
	read -p "There is the same named folder, It will be removed! Are you sure?(y/n) :" continueOption
	if ! [ "${continueOption}" = "y" ]
	then
		echo "${c_red}Exited!"
		exit 1
	fi
	echo -e "Overwrite a theme config files to named by ${c_yellow}'$1' ${c_def}... "
	rm -r -d $script_dir/$1
else
	echo -e "Creating a folder named by ${c_yellow}'$1' ${c_def} and writing config files on it..."

fi
#Creating main folder
mkdir $script_dir/$1
cd $script_dir/$1
echo "Copying config folders..."





#####COPY CONFIG FOLDERS ####

target_dir="$script_dir/$1"

if ! [ -d "$target_dir"/config ]
then
	mkdir $target_dir/config
fi

### for i3 config folder
if ! [ -d "$target_dir/config/i3" ]
then
	mkdir $target_dir/config/i3
fi
cp -r ~/.config/i3 "$target_dir"/config


### for polybar config folder

if ! [ -z "$( command -v polybar )" ]
then
	if ! [ -d "$target_dir/config/polybar" ]
	then
		mkdir $target_dir/config/polybar
	fi
	cp -r ~/.config/polybar "$target_dir"/config

fi



### for nvim config folder

if ! [ -z "$( command -v nvim )" ]
then
	if ! [ -d "$target_dir/config/nvim" ]
	then
		mkdir $target_dir/config/nvim
	fi
	cp -r ~/.config/nvim "$target_dir"/config
fi


### for rofi config folder

if ! [ -z "$( command -v rofi )" ]
then
	if ! [ -d "$target_dir/config/rofi" ]
	then
		mkdir $target_dir/config/rofi
	fi
	cp -r ~/.config/rofi "$target_dir"/config

fi





#####COPY THEME FOLDERS ####
echo "Copying Theme Files"

if ! [ -d "$target_dir"/theme ]
then
	mkdir $target_dir/theme
fi

if ! [ -z "$( command -v rofi )" ]
then
	mkdir "$target_dir"/theme/rofi
	cp -r /usr/share/rofi/themes "$target_dir"/theme/rofi

fi





###COPY WALLPAPER FOLDER ###
wallpaper_path="~/Pictures/Wallpapers"
wallpaperFolderName=$(basename $wallpaper_path) 
wallpaperTargetFolder=${wallpaper_path%/*}
wallpaperAbsolutePath=$(eval echo $wallpaper_path)
read -p "Your wallpaper path is $wallpaper_path, right? (y/n): " useDefaultWallpaperPath
if  [ "$useDefaultWallpaperPath" = "n" ]
then
	read -p "Well, what's your wallpaper path?: " wallpaper_path
fi

echo "Copying Wallpaper Folder from : ${wallpaper_path}..."

if ! [ -d  $wallpaperAbsolutePath ]
then
	echo -e "${c_red} '$wallpaper_path' path doesn't exist!${c_def} "
else
	cp -r "$(eval echo $wallpaper_path)" "$target_dir"
fi





###CREATE APPLY SHOT ###
echo "Creating applyshot.sh file..."
applyShotPath="$target_dir/apply_shot.sh"
#header
echo "#!/bin/bash" >> $applyShotPath
#for dependencies
possible_dependencies=("polybar" "rofi" "neovim" "picom" "feh" "flameshot")
dependencies=()
for pack in "${possible_dependencies[@]}" 
do
	if ! [ -z "$( command -v "$pack" )" ]
	then
		dependencies+=("$pack")	
	fi
done
#echo "${dependencies[@]}"
required_packs=""
read -p "Are there required packs except $(echo ${dependencies[@]}) ? (y/n):" has_alternative_packs
if [ "$has_alternative_packs" = "y" ]
then
	read -p  "Write required pack apt repo names with a space like: emacs cava ... :" required_packs
fi
dependencies+=(${required_packs[@]})
echo "Defined required packs are $(echo ${dependencies[@]}) "
for pack in "${dependencies[@]}" 
do
	echo "sudo apt install $pack" >> $applyShotPath
done 
#for config folders
echo "echo 'Copying i3 config files...'" >> $applyShotPath
echo "sudo cp -f -r $(pwd)/config/i3 ~/.config/" >> $applyShotPath
echo "echo 'Copying Polybar config files...'" >> $applyShotPath
echo "sudo cp -f -r config/polybar ~/.config/" >> $applyShotPath
echo "echo 'Copying Neovim config files...'" >> $applyShotPath
echo "sudo cp -f -r config/nvim ~/.config/" >> $applyShotPath
echo "echo 'Copying Rofi config files...'" >> $applyShotPath
echo "sudo cp -f -r config/rofi ~/.config/" >> $applyShotPath
#for theme folders
echo "echo 'Copying Rofi theme files...'" >> $applyShotPath
echo "sudo cp -f -r theme/rofi/themes /usr/share/rofi/" >> $applyShotPath
#for wallpapers
echo "echo 'Copying wallpapers...'" >> $applyShotPath
echo "sudo cp -f -r $wallpaperFolderName \$(eval echo $wallpaperTargetFolder)" >> $applyShotPath
#for restart i3wm
echo "echo 'Restarting i3wm...'" >> $applyShotPath
echo "i3-msg restart" >> $applyShotPath
echo -e "You can apply this snapshot with run this file ${c_yellow} $applyShotPath ${c_def}"
echo -e "${c_green}Finished! ${c_def}"

