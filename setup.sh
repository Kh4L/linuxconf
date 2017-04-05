#! /bin/bash

set -ue

BLUE='\e[34m'
RED='\e[31m'

RESET='\e[39m'

function print #String to print
{
  echo -e "$BLUE$1$RESET"
}

function vimSetup
{
	echo lol

	mkdir -p ~/.vim/colors
	cp files/molokai.vim ~/.vim/colors
	vim -c 'PluginUpdate'
}

function i3Setup
{
	echo lol
}

checkPackage() #Package name
{
	if [ `sudo apt-cache search "^$1"'$' | wc -l` = 0 ]; then
		return 1
	fi

	return 0
}


sudo apt-get update

packageList=''
print "Installing packages"

for package in `cat packages.txt`; do
	if checkPackage "$package"; then
		packageList="$packageList $package"
	else
		echo "$RED""Warning: Missing package: $package $RESET"
	fi
done
sudo apt-get install -y -m $packageList

print "Installing vim"
