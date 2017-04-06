#! /bin/bash

set -ue

BLUE='\e[34m'
RED='\e[31m'
GREEN='\e[32m'

RESET='\e[39m'

function print #Color, String to print
{
  echo -e "$1$2$RESET"
}

checkPackage() #Package name
{
	if [ `sudo apt-cache search "^$1"'$' | wc -l` = 0 ]; then
		return 1
	fi

	return 0
}

function isInstalled #package
{
	if [ `dpkg-query -W -f='${Status}' $1 2>/dev/null | grep -c "ok installed"` = 1 ]; then
		return 0
	fi

	return 1
}

function vimSetup
{
	mkdir -p ~/.vim/colors
	cp files/molokai.vim ~/.vim/colors

	mkdir -p ~/.vim/bundle
	git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

	cp files/vimrc ~/.vimrc

	vim +PluginInstall +qall	

	print $GREEN "Vim ready"
}

function i3Setup
{
	if isInstalled i3; then
		return 1
	fi

	if [ `cat /proc/version | grep -i Ubuntu | wc -l` != 0 ]; then
		/usr/lib/apt/apt-helper download-file http://debian.sur5r.net/i3/pool/main/s/sur5r-keyring/sur5r-keyring_2017.01.02_all.deb keyring.deb SHA256:4c3c6685b1181d83efe3a479c5ae38a2a44e23add55e16a328b8c8560bf05e5f
		sudo apt install ./keyring.deb
		echo "deb http://debian.sur5r.net/i3/ $(grep '^DISTRIB_CODENAME=' /etc/lsb-release | cut -f2 -d=) universe" >> /etc/apt/sources.list.d/sur5r-i3.list
	else
		/usr/lib/apt/apt-helper download-file http://dl.bintray.com/i3/i3-autobuild/pool/main/i/i3-autobuild-keyring/i3-autobuild-keyring_2016.10.01_all.deb keyring.deb SHA256:460e8c7f67a6ae7c3996cc8a5915548fe2fee9637b1653353ec62b954978d844
		sudo apt install ./keyring.deb
		echo 'deb http://dl.bintray.com/i3/i3-autobuild sid main' > /etc/apt/sources.list.d/i3-autobuild.list
	fi
	sudo apt update
	sudo apt install i3	
	print $GREEN "i3 ready"
}

####### Setup begin #######
sudo apt-get update

packageList=''
print $BLUE "Installing packages"

for package in `cat packages.txt`; do
	if checkPackage "$package"; then
		packageList="$packageList $package"
	else
		print $RED "Warning: Missing package: $package"
	fi
done
sudo apt-get install -y -m $packageList

print $BLUE "Installing vim"
vimSetup

print $BLUE "Installing Oh My Zsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
sudo chsh -s `which zsh`


print $BLUE "Installing i3"
i3Setup

print $GREEN "Setup done! Reboot to be ready :)"
