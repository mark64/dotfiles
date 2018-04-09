#!/usr/bin/env sh
if [ ! -f "$PWD/$0" ]; then
    printf "error: this script must be run from the config repo subdirectory or else this script won't work\n"
    exit 1
fi

ln -sf "$PWD/pam/pam_environment" ~/.pam_environment
ln -sf "$PWD/profile" ~/.profile
command -v bash 2>&1 > /dev/null && ln -sf "$PWD/bash/bashrc" ~/.bashrc
command -v nvim 2>&1 > /dev/null || command -v vim 2>&1 > /dev/null && ln -sf "$PWD/nvim/init.vim" ~/.vimrc
command -v ssh 2>&1 > /dev/null && mkdir -p ~/.ssh && ln -sf "$PWD/ssh/config" ~/.ssh/config && cp $(find ssh -name '*.pub') ~/.ssh
command -v gpg 2>&1 > /dev/null && ln -sf "$PWD/gnupg" ~/.gnupg
command -v minicom 2>&1 > /dev/null && ln -sf "$PWD/minicom/config" ~/.minirc.dfl

printf "success\nremember to source ~/.profile\n"
