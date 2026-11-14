# 05-lib.zsh — tiny helpers used by later modules. No side effects except the
# cached LS_COLORS at the bottom.
#
# Both helpers return their result in $REPLY (NOT via $(...)) so there is no
# subshell fork, and so the caller can `source` at top level. That matters:
# sourcing from inside a function would turn any `typeset`/`local` in the sourced
# script into function-local variables.

# ---------------------------------------------------------------------------
# _find_plugin <plugin-dir-name> <file>
#   Looks in your cloned plugin dir first, then distro locations.
#   Usage:  _find_plugin zsh-autosuggestions zsh-autosuggestions.zsh && source $REPLY
# ---------------------------------------------------------------------------
typeset -ga _plugin_dirs=(
  "$XDG_DATA_HOME/zsh/plugins"
  /usr/share/zsh/plugins
  /usr/share
)
_find_plugin() {
  local d
  for d in "${_plugin_dirs[@]}"; do
    if [[ -r $d/$1/$2 ]]; then REPLY=$d/$1/$2; return 0; fi
    if [[ -r $d/$2 ]];    then REPLY=$d/$2;    return 0; fi
  done
  return 1
}

# ---------------------------------------------------------------------------
# _cache_path <name> <command> [args...]
#   Runs `command args...` once, stores stdout in $XDG_CACHE_HOME/zsh/init-<name>.zsh,
#   byte-compiles it, and sets $REPLY to that path. Regenerates when the binary is
#   newer than the cache, or when $_cache_dep (optional extra file) is newer.
#   Usage:  _cache_path zoxide zoxide init zsh --cmd z && source $REPLY
#   Clear everything:  rm ~/.cache/zsh/init-*
# ---------------------------------------------------------------------------
[[ -d $XDG_CACHE_HOME/zsh ]] || mkdir -p "$XDG_CACHE_HOME/zsh"
_cache_path() {
  local name=$1; shift
  (( $+commands[$1] )) || return 1
  local bin=$commands[$1] cache="$XDG_CACHE_HOME/zsh/init-$name.zsh"
  if [[ ! -s $cache || $bin -nt $cache || ( -n $_cache_dep && $_cache_dep -nt $cache ) ]]; then
    if "$@" >| "$cache.tmp" 2>/dev/null && [[ -s $cache.tmp ]]; then
      mv -f -- "$cache.tmp" "$cache"
      zcompile "$cache" 2>/dev/null
    else
      rm -f -- "$cache.tmp"
      return 1
    fi
  fi
  REPLY=$cache
}

# ---------------------------------------------------------------------------
# LS_COLORS from your dircolors file (cached; was a fork + eval on every start)
# ---------------------------------------------------------------------------
export DIRCOLOR="$XDG_CONFIG_HOME/zsh/dircolors"
if [[ -f $DIRCOLOR ]]; then
  _cache_dep=$DIRCOLOR _cache_path dircolors dircolors -b "$DIRCOLOR" && source "$REPLY"
else
  _cache_path dircolors-default dircolors -b && source "$REPLY"   # built-in defaults
fi
