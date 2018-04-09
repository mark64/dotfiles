export XDG_CONFIG_HOME=${HOME}/.config
export XDG_CACHE_HOME=${HOME}/.local/tmp
export XDG_DATA_HOME=${HOME}/.local/share
export XDG_BIN_HOME=${XDG_DATA_HOME}/../bin
export XDG_LIB_HOME=${XDG_DATA_HOME}/../lib

export PASSWORD_STORE_DIR=${HOME}/.private/password-store

# if running bash
if [ -z "$SOURCING_PROFILE" ] && [ -n "$BASH_VERSION" ]; then
	# include .bashrc if it exists
	if [ -f "$HOME/.bashrc" ]; then
		. "$HOME/.bashrc"
	fi
fi
