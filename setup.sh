#!/usr/bin/env sh
if [ ! -f "$PWD/$0" ]; then
    printf "error: this script must be run from the config repo subdirectory or else this script won't work\n"
    exit 1
fi

command -v git 2>&1 > /dev/null && git pull && git submodule update --init

sed "s,XDG_CONFIG_HOME=\${HOME}/.config,XDG_CONFIG_HOME=$PWD," "$PWD/profile" >~/.profile
ln -sf "$PWD/pam/pam_environment" ~/.pam_environment
ln -sf "$PWD/inputrc" ~/.inputrc
command -v bash 2>&1 > /dev/null && ln -sf "$PWD/bash/bashrc" ~/.bashrc
command -v nvim 2>&1 > /dev/null || (command -v vim 2>&1 > /dev/null && ln -sf "$PWD/nvim/init.vim" ~/.vimrc)
command -v ssh 2>&1 > /dev/null && mkdir -p ~/.ssh \
    && (for FILE in $(find "$PWD/ssh" -name authorized_keys -o -name '*.pub' -o -name 'config'); \
        do ln -sf "$FILE" ~/.ssh/; done)
command -v gpg 2>&1 > /dev/null \
    && [ -d ~/.gnupg ] \
    && (for FILE in $(find "$PWD/gnupg" -name '*.conf'); \
        do ln -sf "$FILE" ~/.gnupg/; done)
command -v minicom 2>&1 > /dev/null && ln -sf "$PWD/minicom/config" ~/.minirc.dfl

VIM=''
(command -v vim 2>&1 > /dev/null && VIM=vim) \
    || (command -v nvim 2>&1 > /dev/null && VIM=nvim)
command -v $VIM 2>&1 > /dev/null && $VIM -i NONE -c PluginInstall -c quitall
#command -v vim 2>&1 > /dev/null && vim -i NONE -c PluginUpdate -c quitall 2>&1 > /dev/null &
command -v $VIM 2>&1 > /dev/null && $VIM -i NONE -c PluginClean -c quitall
