export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_CACHE_HOME="${HOME}/.local/tmp"
export XDG_DATA_HOME="${HOME}/.local/share"
export XDG_BIN_HOME="${XDG_DATA_HOME}/../bin"
export XDG_LIB_HOME="${XDG_DATA_HOME}/../lib"
export LESSHISTFILE="${XDG_DATA_HOME}/less/history"
export LESSKEY="${XDG_DATA_HOME}/less/keys"
export CARGO_HOME="${XDG_DATA_HOME}/cargo"
export RUSTUP_HOME="${XDG_DATA_HOME}/cargo"
export GOPATH="${HOME}/repos/go"
for path in "$GOPATH/bin" "$CARGO_HOME/bin" "$XDG_BIN_HOME"; do
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
