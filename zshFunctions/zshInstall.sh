#!/bin/bash
if [[ $1 = "-h" ]];then
	echo "-h 	help"
	exit
fi

if [[ -f "/usr/bin/zsh" ]] || [[ -f "/bin/zsh" ]];then 
	echo "zsh is already installed"
else 
	sudo apt install zsh
fi

if [[  -d "$HOME/.oh-my-zsh" ]];then
	echo "oh-my-zsh is already installed"
else
	bash -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
fi

if [[ -f "$ZSH_CUSTOM/themes/powerlevel10k" ]];then
	echo "powerlevel10k is already installed"
else
	sudo git clone https://github.com/romkatv/powerlevel10k.git $HOME/.oh-my-zsh/themes/powerlevel10k
fi

if [[ -f "/usr/share/fonts/Fira\ Mono\ Regular\ Nerd\ Font\ Complete.otf" ]] || [[ -f "/usr/local/share/fonts/Fira\ Mono\ Regular\ Nerd\ Font\ Complete.otf" ]] || [[ -f "$HOME/.fonts/Fira\ Mono\ Regular\ Nerd\ Font\ Complete.otf" ]];then
	echo "Fonts installed"
else
	if [[ ! -f "/bin/wget" ]];then
		sudo apt install wget
	fi
	if [[ ! -f "$HOME/Downloads/Fira\ Mono\ Regular\ Nerd\ Font\ Complete.otf" ]];then
		wget -O $HOME/Downloads/Fira\ Mono\ Regular\ Nerd\ Font\ Complete.otf https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/FiraMono/Regular/complete/Fira%20Mono%20Regular%20Nerd%20Font%20Complete.otf?raw=true
	fi
	sudo apt install font-manager
	font-manager $HOME/Downloads/Fura\ Mono\ Regular\ Nerd\ Font\ Complete.otf
fi

if [[ -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]];then
	echo "plugin installed"
else 
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.oh-my-zsh/plugins/zsh-syntax-highlighting
	git clone https://github.com/zsh-users/zsh-autosuggestions.git $HOME/.oh-my-zsh/plugins/zsh-autosuggestions
	cp $HOME/.zshrc zshrc_backup
	echo "backup created in current directory as zshrc_backup"
	sed 's/ZSH_THEME.*/ZSH_THEME="powerlevel10k\/powerlevel10k"|POWERLEVEL9K_MODE="nerdfont-complete"/g' zshrc_backup | tr '|' '\n' > $HOME/.zshrc
	sed -i 's/plugins=.*/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/' $HOME/.zshrc
fi
echo "All Done Please refresh your your terminal or open zsh and type 'source ~/.zshrc'"
echo "If the fonts is not loaded config won't work. It should be in you $HOME/Downloads folder open it and select install!"
