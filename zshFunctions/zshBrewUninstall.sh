#!/bin/bash
if [[ "$1" = "-h" ]];then
	echo "-h 					help"
	echo "--remove-all			remove all programs added through the install this includes wget"
	echo "						default running will remove oh-my-zsh as well as zsh"
	echo "--clean-up			run brew cleanup to remove any unnecessary dependencies that were installed"
	exit
fi

if [[ "$1" = "--remove-all" ]];then
	brew remove wget
fi

if [[ "$SHELL" = "/bin/zsh" ]];then
	echo "Can't unsinstall zsh, zsh is still the default shell"
	echo "Please use chsh command to change your shell"
else
	brew remove zsh
	rm $HOME/.zshrc
	rm $HOME/.zsh_history
fi

if [[ -d "$HOME/.oh-my-zsh" ]];then
	sudo rm -rf $HOME/.oh-my-zsh
else 
	echo "oh-my-zsh is already deleted"
fi

if [[ $1 = "--clean-up" ]] || [[ $2 = "--clean-up" ]];then
	brew cleanup
fi
