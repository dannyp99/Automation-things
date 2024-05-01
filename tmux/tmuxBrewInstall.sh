#!/bin/bash

if [[ ! -d ~/.tmux/plugin/ ]];then
    brew install tpm
else
    echo "tpm should already be installed"
fi

