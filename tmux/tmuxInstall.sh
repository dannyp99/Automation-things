#!/bin/bash

if [[ ! -d ~/.tmux/plugin/ ]];then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
else
    echo "tpm should already be installed"
fi

