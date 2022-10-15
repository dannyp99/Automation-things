#!/bin/bash
git pull origin master
if [[ -f $(which cargo) ]];then
	cargo build --release --no-default-features --features=x11
else
	echo "Rust not installed, install rust here: https://www.rust-lang.org/tools/install"
fi

if [[ ! $(infocmp alacritty) ]];then
	echo "Installing Teminfo"
	sudo tic -xe alacritty,alacritty-direct extra/alacritty.info
fi

echo "copying binary to PATH folder"
sudo cp target/release/alacritty /usr/local/bin # or anywhere else in $PATH
echo "Adding Alacritty to desktop entries"
sudo cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
sudo desktop-file-install extra/linux/Alacritty.desktop
sudo update-desktop-database

if [[ ! -f /usr/local/share/man/man1/alacritty.1.gz && ! -f /usr/local/share/man/man1/alacritty-msg.1.gz ]];then
	echo "Adding man pages"
	gzip -c extra/alacritty.man | sudo tee /usr/local/share/man/man1/alacritty.1.gz > /dev/null
	gzip -c extra/alacritty-msg.man | sudo tee /usr/local/share/man/man1/alacritty-msg.1.gz > /dev/null
fi

if [[ ! -d ${ZDOTDIR:-~}/.zsh_functions ]];then
	echo "Adding zsh completion"
	mkdir -p ${ZDOTDIR:-~}/.zsh_functions
	echo 'fpath+=${ZDOTDIR:-~}/.zsh_functions' >> ${ZDOTDIR:-~}/.zshrc
fi
if [[ ! -f ${ZDOTDIR:-~}/.zsh_functions/_alacritty ]];then
	cp extra/completions/_alacritty ${ZDOTDIR:-~}/.zsh_functions/_alacritty
fi


