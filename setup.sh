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

# XXX replace with ssh key signing, get rid of GPG!
command -v gpg 2>&1 > /dev/null \
    && [ ! -d "$HOME/.gnupg" ] \
    && chmod 700 "$PWD/gnupg" \
    && ln -sf "$PWD/gnupg" ~/.gnupg

[ ! -f ~/.inputrc ] && ln -sf "$PWD/inputrc" ~/.inputrc

command -v rustup 2>&1 > /dev/null \
    && rustup update

HASNVIM=$(command -v nvim 2> /dev/null)
# XXX replace with lazy.nvim update and mason/LSP update
[ "$HASNVIM" ] && [ "$XDG_CONFIG_HOME" ] \
    && command -v git 2>&1 > /dev/null \
    && nvim -i NONE -c PlugUpdate -c quitall > /dev/null

SETUP_CRON_LINE="0 */6 * * * '$SETUP_FILE_PATH'"
command -v crontab 2>&1 > /dev/null \
    && (
        [ "$(crontab -l | grep "$SETUP_FILE_PATH" | wc -l)" -ne 0 ] \
        || cat <(crontab -l) <(echo "$SETUP_CRON_LINE") | crontab -
    ) || (
        grep ~/.bashrc -e './setup.sh' || cat >> ~/.bashrc <<EOF
DIR="$PWD"
cd $XDG_CONFIG_HOME && ./setup.sh
cd $DIR
EOF
    )


# XXX cargo install rg, sad, fd, htop, ranger
# XXX patched font: ttf-sourcecodepro-nerd
# XXX gh client
# XXX packages: neovim, python-neovim
