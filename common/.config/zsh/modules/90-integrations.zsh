# 90-integrations.zsh — tools that hook into ZLE or wrap commands:
# fzf, zoxide, direnv, and lazily-loaded nvm/pyenv.
# Loaded after keybindings so fzf/zoxide widgets don't override ours.

# ---------------------------------------------------------------------------
# fzf shell integration
# ---------------------------------------------------------------------------
# Modern fzf (≥ 0.48) ships `fzf --zsh`, which prints the correct init code.
# Older installs used ~/.fzf.zsh. Try both, prefer the modern path.
# if (( $+commands[fzf] )); then
#   if fzf --zsh >/dev/null 2>&1; then
#     eval "$(fzf --zsh)"
#   elif [[ -f "$HOME/.fzf.zsh" ]]; then
#     source "$HOME/.fzf.zsh"
#   fi
#
#   # Optional user config file (colors, FZF_DEFAULT_OPTS, extra bindings).
#   # Must be sourced AFTER the init above.
#   [[ -r "$ZDOTDIR/fzf.zsh" ]] && source "$ZDOTDIR/fzf.zsh"
# fi

# ---------------------------------------------------------------------------
# zoxide — fish-style `z` command (learned directories)
# ---------------------------------------------------------------------------
# Only registers the `z` command. Does NOT replace `cd` — that stays zsh's
# builtin. If you want zoxide to own `cd`, use `--cmd cd` instead of `--cmd z`
# (not recommended — breaks `cd -`, `cd ~user`, scripted `cd`).
# if (( $+commands[zoxide] )); then
  # eval "$(zoxide init zsh --cmd z)"
# fi
# Only registers `z` / `zi`. Does NOT replace `cd`.
if _cache_path zoxide zoxide init zsh --cmd z; then
  source "$REPLY"
fi


# ---------------------------------------------------------------------------
# direnv — per-directory environment (.envrc)
# ---------------------------------------------------------------------------
# Silently skipped if direnv is not installed; no error printed.
# if (( $+commands[direnv] )); then
  # eval "$(direnv hook zsh)"
# fi
if _cache_path direnv direnv hook zsh; then
  source "$REPLY"
fi

# ---------------------------------------------------------------------------
# Auto-rehash: newly installed commands (zypper in ...) show up in completion
# without `rehash`. One stat() of two directories per prompt — negligible.
# ---------------------------------------------------------------------------
zmodload -F zsh/stat b:zstat
autoload -Uz add-zsh-hook
typeset -g _rehash_stamp
_rehash_check() {
  local -a m
  zstat -A m +mtime /usr/bin /usr/local/bin 2>/dev/null || return 0
  if [[ ${m[*]} != "$_rehash_stamp" ]]; then
    [[ -n $_rehash_stamp ]] && rehash
    _rehash_stamp=${m[*]}
  fi
}
add-zsh-hook precmd _rehash_check

# ---------------------------------------------------------------------------
# atuin — searchable, optionally synced shell history (replaces Ctrl-R)
# ---------------------------------------------------------------------------
# Loaded after fzf (75) so atuin owns Ctrl-R; the Up arrow stays with
# history-substring-search (--disable-up-arrow). Without atuin installed, fzf's Ctrl-R
# is used. Disable with ZSH_ATUIN=0 in local/*.zsh. First time: `atuin import auto`.
if (( ${ZSH_ATUIN:-1} )) && _cache_path atuin atuin init zsh --disable-up-arrow; then
  source "$REPLY"
fi

# ---------------------------------------------------------------------------
# Lazy NVM
# ---------------------------------------------------------------------------
# Sourcing nvm.sh eagerly costs ~200–500 ms per shell. Instead, define stub
# functions that load NVM on first use of nvm/node/npm/npx, then delegate.
#
# Override the location if your NVM lives somewhere else:
#   export NVM_DIR="$XDG_CONFIG_HOME/nvm"
# Place that export BEFORE this file is sourced (e.g. in 00-env.zsh).
# export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"
# if [[ -s "$NVM_DIR/nvm.sh" ]]; then
#   _nvm_lazy() {
#     unset -f nvm node npm npx _nvm_lazy 2>/dev/null
#     . "$NVM_DIR/nvm.sh"
#   }
#   nvm()  { _nvm_lazy; nvm  "$@"; }
#   node() { _nvm_lazy; node "$@"; }
#   npm()  { _nvm_lazy; npm  "$@"; }
#   npx()  { _nvm_lazy; npx  "$@"; }
# fi
# ---------------------------------------------------------------------------
# NVM — node/npm/npx work immediately, `nvm` itself loads on first use
# ---------------------------------------------------------------------------
# Sourcing nvm.sh eagerly costs ~200–500 ms. Instead we put the most recently
# installed node version's bin dir on PATH (so node, npm, npx AND global tools
# like tsc/prettier are found without loading nvm), and stub only `nvm`.
# Override the location with `export NVM_DIR=...` in 00-env.zsh or local/*.zsh.
export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"
if [[ -s "$NVM_DIR/nvm.sh" ]]; then
  _nvm_lazy() {
    unset -f nvm node npm npx _nvm_lazy 2>/dev/null
    . "$NVM_DIR/nvm.sh"
  }
  nvm() { _nvm_lazy; nvm "$@"; }

  # newest-modified version dir under $NVM_DIR/versions/node (heuristic for "default")
  _nvm_bin=("$NVM_DIR"/versions/node/*(N-/om[1]))
  if (( $#_nvm_bin )); then
    path=("${_nvm_bin[1]}/bin" $path)
  else
    # nothing installed yet: fall back to lazy stubs for the other three too
    node() { _nvm_lazy; node "$@"; }
    npm()  { _nvm_lazy; npm  "$@"; }
    npx()  { _nvm_lazy; npx  "$@"; }
  fi
  unset _nvm_bin
fi

# ---------------------------------------------------------------------------
# Lazy pyenv
# ---------------------------------------------------------------------------
# Same idea as NVM: stub functions load pyenv on first `pyenv`/`python` call.
# export PYENV_ROOT="${PYENV_ROOT:-$HOME/.pyenv}"
# if [[ -d "$PYENV_ROOT" ]]; then
#   _pyenv_lazy() {
#     unset -f pyenv python python3 pip pip3 _pyenv_lazy 2>/dev/null
#     [[ -d "$PYENV_ROOT/bin" ]] && path=("$PYENV_ROOT/bin" $path)
#     eval "$(pyenv init - --no-rehash)"
#   }
#   pyenv()   { _pyenv_lazy; pyenv   "$@"; }
#   python()  { _pyenv_lazy; python  "$@"; }
#   python3() { _pyenv_lazy; python3 "$@"; }
# fi
#
# # ---------------------------------------------------------------------------
# pyenv — shims on PATH (fast), `pyenv` itself initialises on first use
# ---------------------------------------------------------------------------
# No more python/python3 stubs: they shadowed the system python and forced a full
# pyenv init on the first `python` call. Shims give the same result for free.
export PYENV_ROOT="${PYENV_ROOT:-$HOME/.pyenv}"
if [[ -d "$PYENV_ROOT" ]]; then
  path=("$PYENV_ROOT/shims"(N-/) "$PYENV_ROOT/bin"(N-/) $path)
  pyenv() {
    unset -f pyenv
    eval "$(command pyenv init - --no-rehash zsh)"
    pyenv "$@"
  }
fi
# (Consider `uv` for Python versions/venvs: no shims or init needed at all.)
# ---------------------------------------------------------------------------
# Terminal title: "user@host: ~/dir" at the prompt, "~/dir · command" while running
# (builtins only, no forks)
# ---------------------------------------------------------------------------
if [[ $TERM != (linux|dumb|) ]]; then
  _title_precmd()  { print -Pn '\e]2;%n@%m: %~\a' }
  _title_preexec() {
    print -Pn '\e]2;%~ · '
    print -rn -- "${1[1,50]//[^[:print:]]/}"
    print -n '\a'
  }
  add-zsh-hook precmd  _title_precmd
  add-zsh-hook preexec _title_preexec
fi

# ---------------------------------------------------------------------------
# openSUSE "command not found" -> suggests the package (cnf), if installed
# ---------------------------------------------------------------------------
if (( ! $+functions[command_not_found_handler] )) && [[ -r /etc/zsh_command_not_found ]]; then
  source /etc/zsh_command_not_found
fi
