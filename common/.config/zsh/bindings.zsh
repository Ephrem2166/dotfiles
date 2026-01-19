# Use emacs key bindings (can be changed to vi with 'bindkey -v')
bindkey -e

# Ctrl+L to clear screen
bindkey '^L' clear-screen

# Up/Down arrow for history search (matching current line prefix)
bindkey '^[[A' history-beginning-search-backward
bindkey '^[[B' history-beginning-search-forward

# Home and End keys
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line

# Delete key
bindkey '^[[3~' delete-char

# Ctrl+Arrow keys for word navigation
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word

# Alt+Arrow keys for word navigation (alternative)
bindkey '^[[1;3C' forward-word
bindkey '^[[1;3D' backward-word

# Ctrl+Backspace to delete previous word
bindkey '^H' backward-kill-word

# Ctrl+Delete to delete next word
bindkey '^[[3;5~' kill-word

# C-M-u: Move to parent directory.
up-directory() {
  local count=${1:-1}
  while ((count > 0)); do
    cd ..
    ((count--))
  done
  zle reset-prompt
}
zle -N up-directory
bindkey '\e\C-u' up-directory
