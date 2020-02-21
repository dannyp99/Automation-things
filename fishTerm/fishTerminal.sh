#!/bin/bash
sudo apt update
sudo apt upgrade
if [ -d "$HOME/.config/omf" ]; then
  echo "omf is already installed"
  exit
fi
sudo apt install fish
read -r -d '' myscript <<'EOF'
import sys
import os
for line in sys.stdin:
    if "successfully installed" in line:
        os.system("killall fish")
EOF

fish -c "$(curl -L https://get.oh-my.fish)" | python3  -c "$myscript"
echo "omf install bobthefish" | fish
