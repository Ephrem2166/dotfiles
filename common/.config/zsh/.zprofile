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
