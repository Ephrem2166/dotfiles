# 50-keybindings.zsh — keybindings + custom ZLE widgets only.
# Loaded AFTER plugins so our bindings win over plugin defaults.

# Only run in interactive shells
[[ -o interactive ]] || return

# ---------------------------------------------------------------------------
# Custom ZLE widgets
# ---------------------------------------------------------------------------

# --- up-directory — cd up N dirs, reset prompt ---
up-directory() {
  local count=${1:-1}
  while (( count > 0 )); do
    builtin cd ..
    (( count-- ))
  done
  zle reset-prompt
}
zle -N up-directory

# --- backward-kill-dir — kill word, treating / as a separator ---
# C-w behaves like the shell default (word), but M-w / ^[w kills
# up to the previous slash, so you can delete a path segment at a time.
backward-kill-dir() {
  local WORDCHARS="${WORDCHARS//\//}"
  zle backward-kill-word
}
zle -N backward-kill-dir

# --- edit-command-line — open $EDITOR on the current buffer ---
autoload -Uz edit-command-line
zle -N edit-command-line

# ---------------------------------------------------------------------------
# History navigation
# ---------------------------------------------------------------------------
# If zsh-history-substring-search is loaded (30-plugins.zsh), bind Up/Down
# to its widgets. Otherwise, fall back to the prefix-matching builtins.
if (( $+widgets[history-substring-search-up] )); then
  bindkey '^[[A' history-substring-search-up
  bindkey '^[[B' history-substring-search-down
else
  bindkey '^[[A' history-beginning-search-backward
  bindkey '^[[B' history-beginning-search-forward
fi

# ---------------------------------------------------------------------------
# Cursor and editing
# ---------------------------------------------------------------------------
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^[[3~' delete-char
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word
bindkey '^[[1;3C' forward-word
bindkey '^[[1;3D' backward-word
bindkey '^[[3;5~' kill-word
bindkey '^[^?'   kill-whole-line          # Alt+Backspace
bindkey '^H' backward-kill-word
# ---------------------------------------------------------------------------
# Emacs-y extras
# ---------------------------------------------------------------------------
bindkey '^L'     clear-screen
bindkey '^[l'    clear-screen
bindkey '^j'     down-line-or-history
bindkey '^k'     up-line-or-history
bindkey '^[j'    history-search-forward
bindkey '^[k'    history-search-backward
bindkey '^p'     vi-backward-blank-word
bindkey '^n'     vi-forward-blank-word
bindkey '^[u'    undo
bindkey '^[r'    redo
bindkey '^[d'    kill-line
bindkey '^[w'    backward-kill-dir
bindkey '^[y'    yank
bindkey '^[e'    edit-command-line
bindkey '\e\C-u' up-directory
bindkey '^[[Z'   reverse-menu-complete    # Shift+Tab

# ---------------------------------------------------------------------------
# Menuselect keymap — only active while a completion menu is open
# ---------------------------------------------------------------------------
bindkey -M menuselect '^p' backward-char
bindkey -M menuselect '^n' forward-char
bindkey -M menuselect '^h' backward-char
bindkey -M menuselect '^j' down-line-or-history
bindkey -M menuselect '^k' up-line-or-history
bindkey -M menuselect '^l' forward-char
bindkey -M menuselect '^o' accept-and-infer-next-history

# ---------------------------------------------------------------------------
# DO NOT BIND THESE — listed here so future-you knows why
# ---------------------------------------------------------------------------
#   ^i     Tab. Breaks AUTO_MENU + `menu select` + fzf-tab.
#   ^d     Ctrl-D. Only way to exit shell — you'll lock yourself in.
#   ^x     Prefix for ^x^e, ^x^r, ^x^f, ^x^b, ^x^u, ^x^? — all emacs staples.
#   ^u     kill-line-backward. If you want universal-argument, use M-i or similar.
#   ^[i    Alt-i (self-insert fallback).
