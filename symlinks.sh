#!/usr/bin/env sh
HASBASH=$(which bash)
HASNVIM=$(which nvim)
HASVIM=$(which vim)
HASSSH=$(which ssh)
HASGPG=$(which gpg)
HASMINICOM=$(which minicom)

if [ ! -f "$PWD/$0" ]; then
    printf "error: this script must be run from the config repo subdirectory or else the symlinks won't work\n"
    exit 1
fi

ln -sf "$PWD/profile" ~/.profile

if [ "$HASBASH" ]; then
    ln -sf "$PWD/bash/bashrc" ~/.bashrc
fi

if [ "$HASVIM" ] && [ ! "$HASNVIM" ]; then
    ln -sf "$PWD/nvim/init.vim" ~/.vimrc
fi

if [ "$HASSSH" ]; then
    mkdir -p ~/.ssh
    ln -sf "$PWD/ssh/config" ~/.ssh/config
fi

if [ "$HASGPG" ]; then
    ln -sf "$PWD/gnupg" ~/.gnupg
fi

if [ "$HASMINICOM" ]; then
    ln -sf "$PWD/minicom/config" ~/.minirc.dfl
fi

printf "success\nremember to source ~/.profile\n"
