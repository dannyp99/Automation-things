#!/bin/sh
if [[ $1 = "--remove-all" ]];then
	brew uninstall wget
fi
if [[ $1 = "-h" ]];then
	echo "-h 	help"
	echo "--remove-all	remove all programs added through the install"
fi
if [[ $SHELL = "/bin/zsh" ]];then
	echo "Can't unsinstall zsh, zsh is still the default shell"
	echo "Please use chsh command to change your shell"
else
	brew uninstall zsh
fi

if [[ -d "$HOME/.oh-my-zsh" ]];then
	rm -rf $HOME/.oh-my-zsh
else 
	echo "oh-my-zsh is already deleted"
fi
