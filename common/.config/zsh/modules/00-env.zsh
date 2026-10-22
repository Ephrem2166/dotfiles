# 00-env.zsh — environment: XDG, PATH, EDITOR, LOCALE, MANPAGER, DE vars.

# --- XDG directory check (in case .zshenv was bypassed) ---
: "${XDG_CONFIG_HOME:=$HOME/.config}"
: "${XDG_DATA_HOME:=$HOME/.local/share}"
: "${XDG_CACHE_HOME:=$HOME/.cache}"
: "${XDG_STATE_HOME:=$HOME/.local/state}"
mkdir -p -m 0750 \
  "$XDG_CONFIG_HOME" "$XDG_DATA_HOME" "$XDG_CACHE_HOME" "$XDG_STATE_HOME"

# --- PATH: build once, deduplicated, in explicit priority order ---
typeset -U path PATH
path=(
  "$HOME/.local/bin"
  "$HOME/.cargo/bin"
  "$HOME/scripts"
  "$XDG_CONFIG_HOME/scripts"
  /usr/local/bin
  /usr/bin
  /bin
  /var/lib/flatpak/exports/bin
  $path
)

# --- Terminal ---
[[ -z $TERM ]] && export TERM=xterm-256color
export TERMINAL=alacritty

# --- Locale: fall back to C.UTF-8 if en_US.UTF-8 isn't generated ---
if locale -a 2>/dev/null | grep -qiE '^en_US\.utf-?8$'; then
  export LANG=en_US.UTF-8
else
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
# ... LESS_TERMCAP_* stay as-is (they work with any pager)
export LESS_TERMCAP_mb=$(tput bold; tput setaf 2)
export LESS_TERMCAP_md=$(tput bold; tput setaf 6)
export LESS_TERMCAP_me=$(tput sgr0)
export LESS_TERMCAP_so=$(tput bold; tput setaf 3; tput setab 4)
export LESS_TERMCAP_se=$(tput rmso; tput sgr0)
export LESS_TERMCAP_us=$(tput smul; tput bold; tput setaf 8)
export LESS_TERMCAP_ue=$(tput rmul; tput sgr0)
export LESS_TERMCAP_mr=$(tput rev)
export LESS_TERMCAP_mh=$(tput dim)

export PAGER='less -R'

# --- Misc program env ---
export TIME_STYLE=+"%Y-%m-%d %a %H:%M"
export RIPGREP_CONFIG_PATH="$XDG_CONFIG_HOME/ripgrep/ripgreprc"

# --- fpath additions (must run before compinit in 40-completion.zsh) ---
[[ -d "$XDG_CONFIG_HOME/beets" ]] && fpath=("$XDG_CONFIG_HOME/beets" $fpath)


# --- dircolors ---
export DIRCOLOR="$XDG_CONFIG_HOME/zsh/dircolors"
if (( $+commands[dircolors] )) && [[ -f $DIRCOLOR ]]; then
  eval "$(dircolors -b "$DIRCOLOR")"
fi

# --- Desktop / Wayland environment ---
# Only applies when the session actually set DESKTOP_SESSION.
if [[ -n $DESKTOP_SESSION ]]; then
  case $DESKTOP_SESSION in
    sway|river|niri|hyprland|*wayland*)
      export QT_QPA_PLATFORM=wayland
      export QT_QPA_PLATFORMTHEME=kde
      export XDG_SESSION_TYPE=wayland
      export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
      export QT_AUTO_SCREEN_SCALE_FACTOR=1
      export SDL_VIDEODRIVER=wayland
      export _JAVA_AWT_WM_NONREPARENTING=1
      export MOZ_ENABLE_WAYLAND=1
      export XCURSOR_SIZE=24
      export GDK_BACKEND=wayland
      ;;
  esac
  case $DESKTOP_SESSION in
    sway)        export XDG_CURRENT_DESKTOP=sway; export GTK_USE_PORTAL=0 ;;
    river)       export XDG_CURRENT_DESKTOP=river; export GTK_USE_PORTAL=1; export XCURSOR_THEME=Adwaita ;;
    niri)        export XDG_CURRENT_DESKTOP=niri; export GTK_USE_PORTAL=1 ;;
    qtile|bspwm) export QT_QPA_PLATFORMTHEME=kde ;;
  esac
fi
