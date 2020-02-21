#!/bin/bash
if [ -d "$HOME/.config/omf" ]; then
	echo "Everything installed!"
	exit
fi
if [ ! -d "$HOME/.config/fish" ]; then
  brew install fish
else
  echo "fish is already installed!"
fi
if [ ! -d "$HOME/.config/omf" ]; then
read -r -d '' myscript <<'EOF'
import sys
import os
for line in sys.stdin:
	if "successfully installed" in line:
		os.system("killall fish")
EOF
	fish -c "$(curl -L https://get.oh-my.fish)" | python3  -c "$myscript"
	echo "omf install bobthefish" | fish
else
	echo "omf is already installed!"
fi
exit
