# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
LOCAL_BASE=$HOME/.local
export XDG_DATA_HOME=${LOCAL_BASE}/share
export XDG_BIN_HOME=${LOCAL_BASE}/bin
export XDG_LIB_HOME=${LOCAL_BASE}/lib
export XDG_DATA_DIRS=/usr/local/share:/usr/share
export XDG_CONFIG_DIRS=/etc/xdg

# XDG Forced support
#export XAUTHORITY=${XDG_RUNTIME_DIR}/Xauthority
export PASSWORD_STORE_DIR=$XDG_DATA_HOME/password-store
export GNUPGHOME=${XDG_DATA_HOME}/gnupg
export PYLINTHOME=${XDG_DATA_HOME}/pylint
export ICEAUTHORITY="${XDG_RUNTIME_DIR}/ICEauthority"
export LESSHISTFILE="${XDG_DATA_HOME}/less/history"
export LESSKEY="${XDG_DATA_HOME}/less/keys"

#alias firefox="firefox -profile ${XDG_CONFIG_HOME}/firefox"
#export BROWSER="firefox -profile $XDG_CONFIG_HOME/firefox"
alias tmux="tmux -f $XDG_CONFIG_HOME/tmux/tmux.conf"

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi
