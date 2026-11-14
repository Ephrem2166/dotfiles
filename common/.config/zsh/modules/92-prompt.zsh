# 80-prompt.zsh — prompt initialization. Near the end of the load order.
# Nothing else should touch PS1/PS2/RPS1 after this file.

# --- Starship ---
# STARSHIP_CONFIG must be set BEFORE `starship init` reads it.
# --- Starship ---
# STARSHIP_CONFIG must be set BEFORE `starship init` output runs.
export STARSHIP_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/starship/starship.toml"

# `starship init zsh` only prints a stub that spawns starship AGAIN to print the
# real script. We cache the full script directly (--print-full-init): zero forks
# per shell. Cache refreshes itself when starship is upgraded.
if _cache_path starship starship init zsh --print-full-init; then
  source "$REPLY"
else
  # Minimal fallback: user@host in cyan, cwd in yellow, % for user / # for root
  PS1='%F{cyan}%n@%m%f %F{yellow}%~%f %# '
fi


# export STARSHIP_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/starship/starship.toml"
#
# if (( $+commands[starship] )); then
#   eval "$(starship init zsh)"
# else
#   # Minimal fallback: user@host in cyan, cwd in yellow, % for user / # for root
#   PS1='%F{cyan}%n@%m%f %F{yellow}%~%f %# '
# fi
