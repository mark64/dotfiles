#!/usr/bin/env bash
SETUP_FILE_PATH=$(realpath $0)
cd "$(dirname "$SETUP_FILE_PATH")"

./.setup/generate_pam_env.py

command -v git 2>&1 > /dev/null && (git pull | tail -n +2)

command -v bash 2>&1 > /dev/null && ln -sf "$PWD/bash/bashrc" ~/.bashrc && mkdir -p ${XDG_DATA_HOME:-~/.local/share}/bash
command -v ssh 2>&1 > /dev/null && mkdir -p ~/.ssh \
    && (for FILE in $(find "$PWD/ssh" -name authorized_keys -o -name '*.pub' -o -name 'config'); do ln -sf "$FILE" ~/.ssh/; done)
command -v gpg 2>&1 > /dev/null \
    && mkdir -p ~/.gnupg \
    && chmod 700 ~/.gnupg \
    && (for FILE in $(find "$PWD/gnupg" -name '*.conf'); do ln -sf "$FILE" ~/.gnupg/; done)
command -v minicom 2>&1 > /dev/null && ln -sf "$PWD/minicom/config" ~/.minirc.dfl

SETUP_CRON_LINE="0 */6 * * * '$SETUP_FILE_PATH'"
command -v crontab 2>&1 > /dev/null \
    && ( [ "$(crontab -l | grep "$SETUP_FILE_PATH" | wc -l)" -ne 0 ] \
    || cat <(crontab -l) <(echo "$SETUP_CRON_LINE") | crontab -)
