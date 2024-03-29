#!/bin/bash
sudo apt update
echo "Installing dependencies..."
sudo apt install -y cmake pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev python3
git fetch --tags
git pull origin master
latestTag=$(git describe --tags `git rev-list --tags --max-count=1`)
git checkout $latestTag
if [[ -f $(which cargo) ]];then
	echo "Building Alacritty version: $latestTag"
	if [[ $# -eq 1 ]];then
		echo "Building with feature: $1"
		cargo build --release --no-default-features --features="$1"
	else
		echo "Building Release feature unspecified"
		cargo build --release
	fi
else
	echo "Rust not installed, install rust here: https://www.rust-lang.org/tools/install"
fi

if [[ ! $(infocmp alacritty) ]];then
	echo "Installing Teminfo"
	sudo tic -xe alacritty,alacritty-direct extra/alacritty.info
fi

echo "Copying binary to PATH folder"
sudo cp target/release/alacritty /usr/local/bin # or anywhere else in $PATH
echo "Adding Alacritty to desktop entries"
sudo cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
sudo desktop-file-install extra/linux/Alacritty.desktop
sudo update-desktop-database

if [[ ! -f /usr/local/share/man/man1/alacritty.1.gz && ! -f /usr/local/share/man/man1/alacritty-msg.1.gz ]];then
	echo "Adding man pages"
	if [[ ! -d /usr/local/share/man/man1 ]];then
		sudo mkdir -p /usr/local/share/man/man1
	fi
	gzip -c extra/alacritty.man | sudo tee /usr/local/share/man/man1/alacritty.1.gz > /dev/null
	gzip -c extra/alacritty-msg.man | sudo tee /usr/local/share/man/man1/alacritty-msg.1.gz > /dev/null
fi

case $SHELL in

	/usr/bin/bash)
		echo "Adding shell completion for bash"
		if [[ ! -d $HOME/.bash_completion ]];then
			mkdir -p ~/.bash_completion
		fi
		cp extra/completions/alacritty.bash ~/.bash_completion/alacritty
		echo "source ~/.bash_completion/alacritty" >> ~/.bashrc
		;;
	/usr/bin/zsh)
		echo "Adding shell completion for zsh"	
		if [[ ! -d ${ZDOTDIR:-~}/.zsh_functions ]];then
			mkdir -p ${ZDOTDIR:-~}/.zsh_functions
			echo 'fpath+=${ZDOTDIR:-~}/.zsh_functions' >> ${ZDOTDIR:-~}/.zshrc
		fi
			cp extra/completions/_alacritty ${ZDOTDIR:-~}/.zsh_functions/_alacritty
		;;
	/usr/bin/fish)
		echo "Adding shell completion for fish"
		if [[ ! -d $HOME/.config/fish/completions ]];then 
			mkdir -p $HOME/.config/fish/completions
		fi
		cp extra/completions/alacritty.fish $HOME/.config/fish/completions/alacritty.fish
		;;
	*)
		;;
esac

git checkout master
