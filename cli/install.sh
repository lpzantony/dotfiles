#!/bin/bash

function do_install {
	read -p "Install the $1 config? (Y/n) " do_install_file
	if [[ -z $do_install_file || $do_install_file =~ ^y(es)?$ ]]; then
		# Create target folder
		mkdir -p $(dirname $3)
		cp -rf $2 $3
	fi
}

# bashrc
if [[ $(uname -a | grep deb\[0-9\]+u) != "" ]]; then # Debian
	do_install bash .bashrc.debian ~/.bashrc
elif [[ $(uname -a | grep \.el\[0-9\]+\.) != "" ]]; then # CentOS / RedHat
	do_install bash .bashrc.centos ~/.bashrc
fi

# fish config
read -p "Install the fish config? (Y/n) " do_install_fish
if [[ -z $do_install_fish || $do_install_fish =~ ^y(es)?$ ]]; then
	[[ $(which fish) == "" ]] && echo "Fish is not installed. Installing anyway."

	# In case fish is not installed, create its config dir
	mkdir -p ~/.config/fish
	cp -f .config/fish/config.fish ~/.config/fish/
	cp -f .config/fish/dist.sh ~/.config/fish/
fi

# vim config
read -p "Install the vim config? (Y/n) " do_install_vimrc
if [[ -z $do_install_vimrc || $do_install_vimrc =~ ^y(es)?$ ]]; then
	cp -f .vimrc ~/
	cp -rf .vim ~/
fi

# tmux
do_install tmux .tmux.conf ~/.tmux.conf

# clang-format
do_install clang-format .clang-format ~/.clang-format

echo "All done!"

