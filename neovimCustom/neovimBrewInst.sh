#!/bin/bash
brew install neovim
brew install wget
sudo su
mkdir -p ~/.config/nvim/colors
wget https://raw.githubusercontent.com/tomasr/molokai/master/colors/molokai.vim
mv molokai.vim ~/.config/nvim/colors
git clone https://github.com/preservim/nerdtree.git ~/.config/nvim/pack/vendor/start/nerdtree
cd ~/.config/nvim
touch init.vim
echo "syntax on" >> init.vim
echo "colorscheme molokai" >> init.vim 
echo "autocmd StdinReadPre * let s:std_in=1" >> init.vim
echo "autocmd VimEnter * if argc() == 0 && !exists(\"s:std_in\") | NERDTree | endif" >> init.vim 
echo "autocmd StdinReadPre * let s:std_in=1" >> init.vim 
echo "autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists(\"s:std_in\") | exe 'NERDTree' argv()[0] | wincmd p | ene | exe 'cd '.argv()[0] | endif" >> init.vim 
echo "autocmd bufenter * if (winnr(\"$\") == 1 && exists(\"b:NERDTree\") && b:NERDTree.isTabTree()) | q | endif" >> init.vim 
