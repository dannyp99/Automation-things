#!/bin/bash
sudo rm -rf ~/.config/omf
sudo rm -rf ~/.local/share/omf
sudo rm -rf ~/.config/fish
sudo apt purge fish
sudo apt autoremove
