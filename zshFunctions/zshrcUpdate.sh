#!/bin/zsh
if [[ $1 = "--update-zshrc" ]];then
	cat zshrcFunc.txt >> ~/.zshr
fi

if [[ -f "./kiryu.mp4" ]] && [[ ! -f "$HOME/Downloads/kiryu.mp4" ]];then
		cp ./kiryu.mp4 $HOME/Downloads
fi

if [[ -f "./push.mp4" ]] && [[ ! -f "$HOME/Downloads/push.mp4"]];then
	cp ./push.mp4 $HOME/Downloads
fi
