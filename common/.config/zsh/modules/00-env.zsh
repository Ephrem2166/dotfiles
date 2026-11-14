# 00-env.zsh — environment: XDG, PATH, EDITOR, LOCALE, MANPAGER, DE vars.

# --- XDG directory check (in case .zshenv was bypassed) ---
: "${XDG_CONFIG_HOME:=$HOME/.config}"
: "${XDG_DATA_HOME:=$HOME/.local/share}"
: "${XDG_CACHE_HOME:=$HOME/.cache}"
: "${XDG_STATE_HOME:=$HOME/.local/state}"
for _d in "$XDG_CONFIG_HOME" "$XDG_DATA_HOME" "$XDG_CACHE_HOME" "$XDG_STATE_HOME"; do
  [[ -d $_d ]] || mkdir -p -m 0750 "$_d"
done
unset _d

# --- PATH: built once, deduplicated, only existing directories ---
# (N-/) = null-glob, follow symlinks, directories only -> missing dirs are dropped.
typeset -U path PATH
path=(
  "$HOME/.local/bin"(N-/)
  "$HOME/.cargo/bin"(N-/)
  "$HOME/scripts"(N-/)
  "$XDG_CONFIG_HOME/scripts"(N-/)
  /usr/local/bin
  /usr/bin
  /bin
  /var/lib/flatpak/exports/bin(N-/)
  "$HOME/.local/share/flatpak/exports/bin"(N-/)
  $path
)


# --- Terminal ---
[[ -z $TERM ]] && export TERM=xterm-256color
export TERMINAL=alacritty

# --- Locale: fall back to C.UTF-8 if en_US.UTF-8 isn't generated ---
# if locale -a 2>/dev/null | grep -qiE '^en_US\.utf-?8$'; then
#   export LANG=en_US.UTF-8
# else
#   export LANG=C.UTF-8
# fi
#
# # openSUSE sets LANG from /etc/locale.conf at login; only fall back when unset.
if [[ -z $LANG || $LANG == (C|POSIX) ]]; then
  export LANG=C.UTF-8
fi


# --- Editor ---
if (( $+commands[nvim] )); then
  export EDITOR=nvim
else
  export EDITOR=vim
fi
export VISUAL="$EDITOR" SUDO_EDITOR="$EDITOR"

# --- Man pager + less colors
# --- Man pager + less colors ---
if (( $+commands[bat] )); then
  export MANPAGER="sh -c 'awk '\''{ gsub(/\x1B\[[0-9;]*m/, \"\", \$0); gsub(/.\x08/, \"\", \$0); print }'\'' | bat -p -lman'"
else
  export MANPAGER='less -R'
fi
export MANROFFOPT='-c'
export PAGER='less -R'
# -F quit if it fits on one screen, -X don't clear the screen on exit (git's own
# defaults are lost once LESS is set, so they are repeated here), -i smart-case search
export LESS='-R -F -X -i -M'

# LESS_TERMCAP_* as literal escapes (was 9x `tput` = 9 forks per shell).
# They only matter when less is the man pager (bat brings its own colours).
export LESS_TERMCAP_mb=$'\e[1;32m'        # begin blink
export LESS_TERMCAP_md=$'\e[1;36m'        # begin bold
export LESS_TERMCAP_me=$'\e[0m'           # end all modes
export LESS_TERMCAP_so=$'\e[1;33;44m'     # begin standout (status line)
export LESS_TERMCAP_se=$'\e[0m'           # end standout
export LESS_TERMCAP_us=$'\e[4;1;38;5;8m'  # begin underline
export LESS_TERMCAP_ue=$'\e[0m'           # end underline
export LESS_TERMCAP_mr=$'\e[7m'           # reverse
export LESS_TERMCAP_mh=$'\e[2m'           # dim


# Keep less history out of $HOME
[[ -d $XDG_STATE_HOME/less ]] || mkdir -p "$XDG_STATE_HOME/less"
export LESSHISTFILE="$XDG_STATE_HOME/less/history"

# --- Misc program env ---
export TIME_STYLE=+"%Y-%m-%d %a %H:%M"
export RIPGREP_CONFIG_PATH="$XDG_CONFIG_HOME/ripgrep/ripgreprc"

# --- fpath additions (must run before compinit in 40-completion.zsh) ---
[[ -d "$XDG_CONFIG_HOME/beets" ]] && fpath=("$XDG_CONFIG_HOME/beets" $fpath)
# Your own completion functions: drop `_name` files into this directory
fpath=("$XDG_DATA_HOME/zsh/site-functions"(N-/) $fpath)

# --- GPG / SSH agents ---
export GPG_TTY=$TTY      # pinentry-curses needs to know the terminal
if [[ -z $SSH_AUTH_SOCK ]]; then
  for _s in "$XDG_RUNTIME_DIR/ssh-agent.socket" "$XDG_RUNTIME_DIR/gcr/ssh" "$XDG_RUNTIME_DIR/keyring/ssh"; do
    [[ -S $_s ]] && { export SSH_AUTH_SOCK=$_s; break; }
  done
  unset _s
fi


# # --- dircolors ---
# export DIRCOLOR="$XDG_CONFIG_HOME/zsh/dircolors"
# if (( $+commands[dircolors] )) && [[ -f $DIRCOLOR ]]; then
#   eval "$(dircolors -b "$DIRCOLOR")"
# fi
