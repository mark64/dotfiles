export XDG_CONFIG_HOME=${HOME}/.config
export XDG_CACHE_HOME=${HOME}/.cache
export XDG_DATA_HOME=${HOME}/.local/share
export XDG_BIN_HOME=${XDG_DATA_HOME}/../bin
export XDG_LIB_HOME=${XDG_DATA_HOME}/../lib

export ICEAUTHORITY=${XDG_RUNTIME_DIR}/ICEauthority
#XAUTHORITY=${XDG_RUNTIME_DIR}/Xauthority
export GNUPGHOME=${XDG_CONFIG_HOME}/gnupg
export PASSWORD_STORE_DIR=${XDG_DATA_HOME}/password-store


# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi
