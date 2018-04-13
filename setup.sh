#!/usr/bin/env sh
cd "$PWD/$(dirname $0)"

command -v git 2>&1 > /dev/null && (git pull | tail -n +2)

sed "s,XDG_CONFIG_HOME=\${HOME}/.config,XDG_CONFIG_HOME=$PWD," "$PWD/profile" >~/.profile
ln -sf "$PWD/pam/pam_environment" ~/.pam_environment
ln -sf "$PWD/inputrc" ~/.inputrc
command -v bash 2>&1 > /dev/null && ln -sf "$PWD/bash/bashrc" ~/.bashrc
command -v nvim 2>&1 > /dev/null || (command -v vim 2>&1 > /dev/null && ln -sf "$PWD/nvim/init.vim" ~/.vimrc)
command -v ssh 2>&1 > /dev/null && mkdir -p ~/.ssh \
    && (for FILE in $(find "$PWD/ssh" -name authorized_keys -o -name '*.pub' -o -name 'config'); \
        do ln -sf "$FILE" ~/.ssh/; done)
command -v gpg 2>&1 > /dev/null \
    && mkdir -p ~/.gnupg \
    && chmod 700 ~/.gnupg \
    && (for FILE in $(find "$PWD/gnupg" -name '*.conf'); \
        do ln -sf "$FILE" ~/.gnupg/; done)
command -v minicom 2>&1 > /dev/null && ln -sf "$PWD/minicom/config" ~/.minirc.dfl
command -v pass 2>&1 > /dev/null && pass git pull | tail -n +2 && pass git push 2>&1 | tail -n +2

VIM=''
HASNVIM=$(command -v nvim 2> /dev/null)
HASVIM=$(command -v vim 2> /dev/null)
if [ "$HASNVIM" ]; then
    VIM=nvim
elif [ "$HASVIM" ]; then
    VIM=vim
fi
[ "$VIM" ] && [ "$XDG_CONFIG_HOME" ] && ( command -v git 2>&1 > /dev/null && [ -d $XDG_CONFIG_HOME/nvim/bundle/Vundle.vim ] && cd $XDG_CONFIG_HOME/nvim/bundle/Vundle.vim && git pull | tail -n +2 || git clone https://github.com/VundleVim/Vundle.vim $XDG_CONFIG_HOME/nvim/bundle/Vundle.vim ) \
    && $VIM -i NONE -c PluginInstall -c PluginClean -c quitall
