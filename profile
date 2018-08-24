export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_CACHE_HOME="${HOME}/.local/tmp"
export XDG_DATA_HOME="${HOME}/.local/share"
export XDG_BIN_HOME="${XDG_DATA_HOME}/../bin"
export XDG_LIB_HOME="${XDG_DATA_HOME}/../lib"
export PYLINTHOME="${XDG_DATA_HOME}/pylint"
export LESSHISTFILE="${XDG_DATA_HOME}/less/history"
export LESSKEY="${XDG_DATA_HOME}/less/keys"
export CARGO_HOME="${XDG_DATA_HOME}/cargo"
export RUSTUP_HOME="${XDG_DATA_HOME}/cargo"
export GOPATH="${HOME}/repos/go"
for path in "$GOPATH" "$HOME/repos/astranis/tools/arcanist/arcanist" "$CARGO_HOME" "$XDG_BIN_HOME/../"; do
    if [ -d "$path" ]; then
        export PATH="$PATH:$path"
    fi
done
for editor in nvim vim vi nano; do
    if command -v "$editor" > /dev/null 2>&1; then
        export EDITOR="$editor"
        break
    fi
done
# if running bash
if [ -z "$SOURCING_PROFILE" ] && [ -n "$BASH_VERSION" ]; then
	# include .bashrc if it exists
	if [ -f "$HOME/.bashrc" ]; then
		. "$HOME/.bashrc"
	fi
fi
