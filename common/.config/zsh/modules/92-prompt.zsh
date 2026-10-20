# 80-prompt.zsh — prompt initialization. Near the end of the load order.
# Nothing else should touch PS1/PS2/RPS1 after this file.

# --- Starship ---
# STARSHIP_CONFIG must be set BEFORE `starship init` reads it.

export STARSHIP_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/starship/starship.toml"

if (( $+commands[starship] )); then
  eval "$(starship init zsh)"
else
  # Minimal fallback: user@host in cyan, cwd in yellow, % for user / # for root
  PS1='%F{cyan}%n@%m%f %F{yellow}%~%f %# '
fi
