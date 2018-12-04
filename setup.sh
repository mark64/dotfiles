#!/usr/bin/env bash
# This script sets up my user environment without modifying installed packages or requiring root access.
# It is designed to be run on nearly any UNIX computer and perform as much setup as possible, given the
# installed packages.
# The nice thing about this script is that I can have all my aliases and vimrc synced across machines.
SETUP_FILE_PATH=$(realpath $0)
cd "$(dirname "$SETUP_FILE_PATH")"

sed "s,export XDG_CONFIG_HOME=.*,export XDG_CONFIG_HOME=\"$(dirname "$SETUP_FILE_PATH")\"," profile > ~/.profile

command -v git 2>&1 > /dev/null && (git pull | tail -n +2)

command -v bash 2>&1 > /dev/null && ln -sf "$PWD/bash/bashrc" ~/.bashrc && mkdir -p ${XDG_DATA_HOME:-~/.local/share}/bash

command -v ssh 2>&1 > /dev/null && mkdir -p ~/.ssh \
    && (for FILE in $(find "$PWD/ssh" -name authorized_keys -o -name '*.pub' -o -name 'config'); do ln -sf "$FILE" ~/.ssh/; done)

command -v gpg 2>&1 > /dev/null \
    && mkdir -p ~/.gnupg \
    && chmod 700 ~/.gnupg \
    && (for FILE in $(find "$PWD/gnupg" -name '*.conf' -o -name '*.kbx'); do ln -sf "$FILE" ~/.gnupg/; done)

[ ! -f ~/.inputrc ] && ln -sf "$PWD/inputrc" ~/.inputrc

command -v tmux 2>&1 > /dev/null \
    && ln -sf "$PWD/tmux/tmux.conf" ~/.tmux.conf

VIM=''
HASNVIM=$(command -v nvim 2> /dev/null)
HASVIM=$(command -v vim 2> /dev/null)
if [ "$HASNVIM" ]; then
    VIM=nvim
elif [ "$HASVIM" ]; then
    VIM=vim
fi
[ "$VIM" ] && [ "$XDG_CONFIG_HOME" ] \
    && command -v git 2>&1 > /dev/null \
    && $VIM -i NONE -c PlugUpdate -c quitall > /dev/null

SETUP_CRON_LINE="0 */6 * * * '$SETUP_FILE_PATH'"
command -v crontab 2>&1 > /dev/null \
    && (
        [ "$(crontab -l | grep "$SETUP_FILE_PATH" | wc -l)" -ne 0 ] \
        || cat <(crontab -l) <(echo "$SETUP_CRON_LINE") | crontab -
    ) || (
        grep ~/.bashrc -e './setup.sh' || cat > ~/.bashrc <<< EOF
DIR="$PWD"
cd $XDG_CONFIG_HOME && ./setup.sh
cd $DIR
EOF
    )
