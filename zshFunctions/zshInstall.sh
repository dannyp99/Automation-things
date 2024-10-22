#!/bin/bash
if [[ $1 = "-h" ]] || [[ $1 = "--help" ]];then
	echo "-h,--help 				View all of the arguments for this script"
	echo "--font-manager			Used if you need to install font manager"
	echo "--install-font			Open the downloaded font file to install to system"
	exit
fi

if [[ -n $(which zsh) ]] && { [[ -f "/usr/bin/zsh" ]] || [[ -f "/bin/zsh" ]]; };then
	echo "zsh is already installed"
else 
	sudo apt -y install zsh
fi

if [[ -d "$HOME/.oh-my-zsh" ]];then
	echo "oh-my-zsh is already installed"
else
	cat <<< "n" | bash -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
	if [[ ! -f "/usr/bin/killall" ]] && [[ -z $(which killall) ]]; then
		sudo apt -y install psmisc
	fi
fi

if [[ -d "$HOME/.oh-my-zsh/custom/themes/powerlevel10k" ]] && [[ -f "$HOME/.oh-my-zsh/custom/themes/lambda-mod.zsh-theme" ]];then
	echo "themes are already installed"
else
	sudo git clone https://github.com/romkatv/powerlevel10k.git $HOME/.oh-my-zsh/custom/themes/powerlevel10k
    wget -O "$HOME/.oh-my-zsh/custom/themes/lambda-mod.zsh-theme" https://raw.githubusercontent.com/halfo/lambda-mod-zsh-theme/master/lambda-mod.zsh-theme
fi

if [[ -f "/usr/share/fonts/Fira\ Mono\ Regular\ Nerd\ Font\ Complete.otf" ]] || [[ -f "/usr/local/share/fonts/Fira\ Mono\ Regular\ Nerd\ Font\ Complete.otf" ]] || [[ -f "$HOME/.fonts/Fira\ Mono\ Regular\ Nerd\ Font\ Complete.otf" ]];then
	echo "Fonts installed already"
else
	if [[ ! -f "/bin/wget" ]] && [[ -z $(which wget) ]];then
		sudo apt -y install wget
	fi
	if [[ ! -f "/usr/bin/curl" ]] || [[ -n $(which zsh) ]];then
		sudo apt -y install curl
	fi
fi

if [[ ! -d "$HOME/.fzf" ]];then
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    $HOME/.fzf/install
else
    echo "FZF is already installed"
fi

if [[ -d "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]] && [[ -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]] && [[ -d "$HOME/.oh-my-zsh/custom/plugins/fzf-zsh-plugin" ]];then
	echo "plugin already installed"
else 
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
	git clone https://github.com/zsh-users/zsh-autosuggestions.git $HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions
    git clone --depth 1 https://github.com/unixorn/fzf-zsh-plugin.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-zsh-plugin
	cp $HOME/.zshrc zshrc_backup
	echo "backup created in current directory as zshrc_backup"
	sed 's/ZSH_THEME.*/ZSH_THEME="lambda-mod"/g' zshrc_backup | tr "%" "\n" > $HOME/.zshrc
	sed -i 's/plugins=.*/plugins=(git zsh-autosuggestions zsh-syntax-highlighting fzf-zsh-plugin)/' $HOME/.zshrc
    echo "FZF command configs"
    echo "export FZF_DEFAULT_COMMAND='rg --files --follow --hidden -g \"!{**/node_modules/*,**/.git/*,**/target/*,**/build/*}\"'" >> "$HOME/.zshrc"
    echo "export FZF_DEFAULT_OPTS='--preview \"batcat --style=numbers --color=always {}\" --preview-window right:50%:hidden:wrap --bind ctrl-/:toggle-preview'" >> "$HOME/.zshrc"
    echo "export FZF_ALT_C_COMMAND='find -type d \( -path \"**/node_modules\" -prune -o -path \"**/.git\" -prune -o -path \"**/target\" -prune -o -path \"**/build\" \) -o -print'" >> "$HOME/.zshrc"
    echo "[ -f ~/.fzf.zsh ] && source ~/.fzf/fzf.zsh" >> "$HOME/.zshrc"
fi
echo "All Done Please refresh your your terminal or open zsh and type 'source ~/.zshrc'"
echo "If the fonts is not loaded config won't work. It should be in you $HOME/Downloads folder open it and select install!"
exit
