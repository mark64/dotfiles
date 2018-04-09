# Setup fzf
# ---------
if [[ ! "$PATH" == *$XDG_CONFIG_HOME/nvim/bundle/fzf/bin* ]]; then
  export PATH="$PATH:$XDG_CONFIG_HOME/nvim/bundle/fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "$XDG_CONFIG_HOME/nvim/bundle/fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source "$XDG_CONFIG_HOME/nvim/bundle/fzf/shell/key-bindings.bash"

