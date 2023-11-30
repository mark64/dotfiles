#!/usr/bin/env sh
# This script installs packages and performs system-level modifications
# Only supports debian for now
set -e

if [ "$(id -u)" -ne 0 ]; then
    echo "Must be run as root"
    exit 1
fi

apt-get update
apt-get -y full-upgrade
apt-get -y install neovim git build-essential cmake clang clang-tidy clang-format gnupg scdaemon gnupg-agent \
    tmux curl openssh-client openssh-server python3-dev python-dev autojump bash-completion sudo \
    unattended-upgrades openvpn cron autojump

curl https://sh.rustup.rs -sSf | sh
