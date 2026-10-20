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
if (( $+commands[zoxide] )); then
  eval "$(zoxide init zsh --cmd z)"
fi

# ---------------------------------------------------------------------------
# direnv — per-directory environment (.envrc)
# ---------------------------------------------------------------------------
# Silently skipped if direnv is not installed; no error printed.
if (( $+commands[direnv] )); then
  eval "$(direnv hook zsh)"
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
export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"
if [[ -s "$NVM_DIR/nvm.sh" ]]; then
  _nvm_lazy() {
    unset -f nvm node npm npx _nvm_lazy 2>/dev/null
    . "$NVM_DIR/nvm.sh"
  }
  nvm()  { _nvm_lazy; nvm  "$@"; }
  node() { _nvm_lazy; node "$@"; }
  npm()  { _nvm_lazy; npm  "$@"; }
  npx()  { _nvm_lazy; npx  "$@"; }
fi

# ---------------------------------------------------------------------------
# Lazy pyenv
# ---------------------------------------------------------------------------
# Same idea as NVM: stub functions load pyenv on first `pyenv`/`python` call.
export PYENV_ROOT="${PYENV_ROOT:-$HOME/.pyenv}"
if [[ -d "$PYENV_ROOT" ]]; then
  _pyenv_lazy() {
    unset -f pyenv python python3 pip pip3 _pyenv_lazy 2>/dev/null
    [[ -d "$PYENV_ROOT/bin" ]] && path=("$PYENV_ROOT/bin" $path)
    eval "$(pyenv init - --no-rehash)"
  }
  pyenv()   { _pyenv_lazy; pyenv   "$@"; }
  python()  { _pyenv_lazy; python  "$@"; }
  python3() { _pyenv_lazy; python3 "$@"; }
fi
