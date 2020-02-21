#!/bin/bash
if [ -d "$HOME/.config/omf" ]; then
	rm -rf ~/.config/omf
	rm -rf ~/.local/share/omf
	echo "omf removed"
else
	echo "omf not installed"
fi

if [ -d "$HOME/.config/fish" ]; then
	rm -rf ~/.config/fish
	brew remove fish
	echo "fish removed"
else
    echo "fish not installed"
fi
exit
