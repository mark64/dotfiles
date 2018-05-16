# Setup fzf
# ---------
if [[ ! "$PATH" == */home/mark/repos/fzf/bin* ]]; then
  export PATH="$PATH:/home/mark/repos/fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/mark/repos/fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "/home/mark/repos/fzf/shell/key-bindings.zsh"

