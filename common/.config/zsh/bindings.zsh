# EMACS
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

# vi like movement commands on hjkl
bindkey "^b" backward-bashword
bindkey "^f" forward-bashword

bindkey "^h" backward-char
bindkey "^l" forward-char
bindkey "^j" down-line-or-history
bindkey "^k" up-line-or-history

# same as C-h/C-l except skips over /
bindkey "^p" vi-backward-blank-word
bindkey "^n" vi-forward-blank-word

bindkey "^[[1;5C" forward-bashword  # <C-right>
bindkey "^[[1;5D" backward-bashword # <C-left>

bindkey "^[j" history-search-forward
bindkey "^[k" history-search-backward

bindkey "^u" universal-argument

bindkey "^[u" undo
bindkey "^[r" redo

bindkey "^[d" kill-line
bindkey "^d" backward-kill-line

bindkey '^w' backward-kill-bashword
bindkey '^[w' backward-kill-dir

bindkey "^[^?" kill-whole-line # <M-backspace>

bindkey "^[y" yank

bindkey "^[e" edit-command-line
bindkey "^[l" clear-screen

bindkey -s "^[i" "^[[Z" # <M-i> = <S-TAB>

bindkey "^i" complete-word
bindkey "^[i" expand-word

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

# VIM
# Support different curosors for different vi-modes.
# _cursor_block='\e[2 q'
# _cursor_beam='\e[6 q'
# function zle-keymap-select {
#   # Taken from [[https://thevaluable.dev/zsh-install-configure-mouseless/#:~:text=between%20modes%20quicker.-,Changing%20Cursor,-A%20visual%20indicator][here]].
#   if [[ ${KEYMAP} == vicmd ]] ||
#     [[ $1 = 'block' ]]; then
#     echo -ne "$_cursor_block"
#   elif [[ ${KEYMAP} == main ]] ||
#     [[ ${KEYMAP} == viins ]] ||
#     [[ ${KEYMAP} = '' ]] ||
#     [[ $1 = 'beam' ]]; then
#     echo -ne "$_cursor_beam"
#   fi
# }
#
# zle-line-init() {
#   echo -ne "$_cursor_beam"
# }
# zle -N zle-keymap-select
# zle -N zle-line-init
#
# bindkey -v
# bindkey -M viins '^a' beginning-of-line
# bindkey -M viins '^e' end-of-line
#
# bindkey -M viins "^[[1;5C" forward-bashword  # <C-right>
# bindkey -M viins "^[[1;5D" backward-bashword # <C-left>
#
# bindkey -M viins '^w' backward-kill-bashword
# bindkey -M viins '^[w' backward-kill-dir
#
# bindkey -M viins "^[e" edit-command-line
# bindkey -M viins "^[l" clear-screen
