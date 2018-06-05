# Setup fzf
# ---------
if [[ ! "$PATH" == */home/mark/.local/share/nvim/plugged/fzf/bin* ]]; then
  export PATH="$PATH:/home/mark/.local/share/nvim/plugged/fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/mark/.local/share/nvim/plugged/fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "/home/mark/.local/share/nvim/plugged/fzf/shell/key-bindings.zsh"

