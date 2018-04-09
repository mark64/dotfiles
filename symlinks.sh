#!/usr/bin/env sh
if [ ! -f "$PWD/$0" ]; then
    printf "error: this script must be run from the config repo subdirectory or else this script won't work\n"
    exit 1
fi

ln -sf "$PWD/pam/pam_environment" ~/.pam_environment
ln -sf "$PWD/profile" ~/.profile
command -v bash 2>&1 > /dev/null && ln -sf "$PWD/bash/bashrc" ~/.bashrc
command -v nvim 2>&1 > /dev/null || command -v vim 2>&1 > /dev/null && ln -sf "$PWD/nvim/init.vim" ~/.vimrc
command -v ssh 2>&1 > /dev/null && mkdir -p ~/.ssh \
    && (for FILE in $(find "$PWD/ssh" -name '*.pub' -o -name 'config'); \
        do ln -sf "$FILE" ~/.ssh/; done)
command -v gpg 2>&1 > /dev/null \
    && [ -d ~/.gnupg ] \
    && (for FILE in $(find "$PWD/gnupg" -name '*.conf'); \
        do ln -sf "$FILE" ~/.gnupg/; done)
command -v minicom 2>&1 > /dev/null && ln -sf "$PWD/minicom/config" ~/.minirc.dfl
