# ~/.config/zsh/.zprofile — login shells only.
# Sourced by zsh BEFORE .zshrc on login shells (tty login, `zsh -l`, SSH login).
#
# Nothing is required here because 00-env.zsh (loaded from .zshrc) already handles
# PATH, EDITOR, LOCALE, MANPAGER, and DE/Wayland variables for interactive shells.
#
# Add login-only setup here only if it should NOT run in nested interactive shells.
# Examples:
#   - Starting an ssh-agent
#   - Running `systemd-environment-d-generator`
#   - XDG_RUNTIME_DIR setup on systems without systemd-logind
# --- Desktop / Wayland environment ---
# --- Wayland / DE variables ---
# DESKTOP_SESSION is set by the display manager. From a bare tty, export it yourself
# first (e.g. `export DESKTOP_SESSION=niri; exec niri-session`).

# Only applies when the session actually set DESKTOP_SESSION.
if [[ -n $DESKTOP_SESSION ]]; then
  case $DESKTOP_SESSION in
    sway|river|niri|hyprland|*wayland*)

# Fallback lists (wayland first, then X11) so X11-only apps keep working.
      export QT_QPA_PLATFORM="wayland;xcb"
      export GDK_BACKEND="wayland,x11"
      export QT_QPA_PLATFORMTHEME=kde
      export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
      export _JAVA_AWT_WM_NONREPARENTING=1
      export MOZ_ENABLE_WAYLAND=1
      export XCURSOR_SIZE=24
      # Deliberately NOT set (they cause more harm than good):
      #   SDL_VIDEODRIVER=wayland  -> breaks many SDL2 games
      #   XDG_SESSION_TYPE         -> logind already sets it correctly
      #   QT_AUTO_SCREEN_SCALE_FACTOR -> deprecated with Qt6
      ;;
  esac
  case $DESKTOP_SESSION in
    sway)        export XDG_CURRENT_DESKTOP=sway; export GTK_USE_PORTAL=0 ;;
    river)       export XDG_CURRENT_DESKTOP=river; export GTK_USE_PORTAL=1; export XCURSOR_THEME=Adwaita ;;
    niri)        export XDG_CURRENT_DESKTOP=niri; export GTK_USE_PORTAL=1 ;;
    qtile|bspwm) export QT_QPA_PLATFORMTHEME=kde ;;
  esac
fi
