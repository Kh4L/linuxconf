#!/bin/bash

function vimSetup
{
        mkdir -p ~/.vim/colors
        mkdir -p ~/tmp
        cp files/molokai.vim ~/.vim/colors

        if [ ! -d ~/.vim/bundle/Vundle.vim ]; then
                mkdir -p ~/.vim/bundle;
                git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
        fi

        cp files/vimrc ~/.vimrc

        vim +PluginInstall +qall

        echo "Vim ready"
}

vimSetup
