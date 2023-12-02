#!/usr/bin/env bash
# This script sets up my user environment without modifying installed packages or requiring root access.
# It is designed to be run on nearly any UNIX computer and perform as much setup as possible, given the
# installed packages.
# The nice thing about this script is that I can have all my aliases and vimrc synced across machines.
SETUP_FILE_PATH=$(realpath $0)
cd "$(dirname "$SETUP_FILE_PATH")"

command -v git 2>&1 > /dev/null && (git pull | tail -n +2)  # XXX if there's updates, re-exec

sed "s,export XDG_CONFIG_HOME=.*,export XDG_CONFIG_HOME=\"$(dirname "$SETUP_FILE_PATH")\"," profile > ~/.profile
# Make sure we have the latest profile settings sourced.
source ~/.profile

command -v bash 2>&1 > /dev/null && ln -sf "$PWD/bash/bashrc" ~/.bashrc && mkdir -p ${XDG_DATA_HOME:-~/.local/share}/bash
command -v bash 2>&1 > /dev/null && ln -sf "$PWD/bash/bash_profile.bash" ~/.bash_profile
# Load any new bashrc settings.
source ~/.bashrc

command -v ssh 2>&1 > /dev/null && mkdir -p ~/.ssh \
    && (for FILE in $(find "$PWD/ssh" -name authorized_keys -o -name '*.pub' -o -name 'config'); do ln -sf "$FILE" ~/.ssh/; done)

# XXX replace with ssh key signing, get rid of GPG!
command -v gpg 2>&1 > /dev/null \
    && [ ! -d "$HOME/.gnupg" ] \
    && chmod 700 "$PWD/gnupg" \
    && ln -sf "$PWD/gnupg" ~/.gnupg

[ ! -f ~/.inputrc ] && ln -sf "$PWD/inputrc" ~/.inputrc

# XXX if needed:
# curl https://sh.rustup.rs -sSf | sh
command -v rustup 2>&1 > /dev/null && rustup update
command -v cargo 2>&1 > /dev/null && cargo install \
    ripgrep \
    fd-find \
    paru \

HASNVIM=$(command -v nvim 2> /dev/null)
# XXX I want to view the change logs
# [ "$HASNVIM" ] && [ "$XDG_CONFIG_HOME" ] \
#     && command -v git 2>&1 > /dev/null \
#     && nvim --headless -c 'autocmd User Lazy update quitall' -c 'quitall' > /dev/null \
#     && nvim --headless -c 'autocmd User MasonUpdateAll quitall' -c 'quitall' > /dev/null

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


# XXX system packages:
# - openvpn
# - curl
# - wget
# - zip
# - tar
# - lzma
# - git
# - gzip
# - patched font: ttf-sourcecodepro-nerd
# - zsync
# - fuse2
# - openssh

# XXX user-local packages:
# - neovim
# - python3
# - python3-neovim (maybe self-contain in nvim?)
# - python3-pip
# - python3-venv
# - npm
# - tmux
# - bazelisk
# - autojump
# - google-chrome
# - graphviz/dot maybe?
# - buildessential/gcc/clang/cmake/make
# - sad XXX do I need?
# - htop
# - ranger
# - gh client
# - op client
# - 1pass desktop

# XXX 1pass as SSH agent?
