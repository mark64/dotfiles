#!/usr/bin/env sh
if [ ! -f "$PWD/$0" ]; then
    printf "error: this script must be run from the config repo subdirectory or else the symlinks won't work\n"
    exit 1
fi

ln -sf "$PWD/profile" ~/.profile
command -v bash &> /dev/null && ln -sf "$PWD/bash/bashrc" ~/.bashrc
command -v nvim &> /dev/null || command -v vim &> /dev/null && ln -sf "$PWD/nvim/init.vim" ~/.vimrc
command -v ssh &> /dev/null && mkdir -p ~/.ssh && ln -sf "$PWD/ssh/config" ~/.ssh/config && cp "$PWD/ssh/*.pub" ~/.ssh/*.pub
command -v gpg &> /dev/null && ln -sf "$PWD/gnupg" ~/.gnupg
command -v minicom &> /dev/null && ln -sf "$PWD/minicom/config" ~/.minirc.dfl

printf "success\nremember to source ~/.profile\n"
