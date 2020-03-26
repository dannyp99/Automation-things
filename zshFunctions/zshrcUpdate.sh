#!/bin/zsh
if [[ $1 = "--update-zshrc" ]];then
	cat zshrcFunc.txt >> ~/.zshr
fi
if [[ -f "./kiryu.mp4" ]];then
		cp ./kiryu.mp4 $HOME/Downloads
fi
