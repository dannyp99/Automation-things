#!/bin/bash
brew install fish
fish -c "$(curl -L https://get.oh-my.fish)" | python3 termInst.py
echo "omf install bobthefish" | fish
