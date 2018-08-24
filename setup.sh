#!/usr/bin/env bash
SETUP_FILE_PATH=$(realpath "$STARTING_PWD/$0")
cd "$(dirname \"$SETUP_FILE_PATH\")"

command -v git 2>&1 > /dev/null && (git pull | tail -n +2)

sed "s,XDG_CONFIG_HOME=\${HOME}/.config,XDG_CONFIG_HOME=$PWD," "$PWD/profile" >~/.profile
ln -sf "$PWD/pam/pam_environment" ~/.pam_environment
ln -sf "$PWD/inputrc" ~/.inputrc
command -v bash 2>&1 > /dev/null && ln -sf "$PWD/bash/bashrc" ~/.bashrc && mkdir -p ${XDG_DATA_HOME:-~/.local/share}/bash
command -v vim 2>&1 > /dev/null && ln -sf "$PWD/nvim/init.vim" ~/.vimrc
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
[ "$VIM" ] && [ "$XDG_CONFIG_HOME" ] && command -v git 2>&1 > /dev/null \
    && $VIM -i NONE -c PlugUpdate -c quitall

command -v ranger 2>&1 > /dev/null && ranger --copy-config=scope 2>/dev/null

SETUP_FILE_PATH=$(realpath "$STARTING_PWD/$0")
SETUP_CRON_LINE="0 */6 * * * '$SETUP_FILE_PATH'"
command -v crontab 2>&1 > /dev/null \
    && ( [ "$(crontab -l | grep "$SETUP_FILE_PATH" | wc -l)" -ne 0 ] \
        || cat <(crontab -l) <(echo "$SETUP_CRON_LINE") | crontab -)
