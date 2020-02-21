#!/bin/bash
if [ !-d "$HOME/.config/omf" ]; then
  echo "omf is not installed"
  exit
fi


if [ !-d "$HOME/.config/fish" ]; then
  echo "fish is not installed"
  exit
fi

rm -rf ~/.config/omf
rm -rf ~/.local/share/omf
rm -rf ~/.config/fish
sudo apt purge fish
sudo apt autoremove
