# 35-tool-completions.zsh — completions that tools generate themselves
# (gh, uv, rustup, cargo, podman, kubectl, just ...), cached as real completion files.
#
# How it works: `<tool> completion zsh` is run ONCE, its output is stored as
# $XDG_CACHE_HOME/zsh/completions/_<name>, and that directory is put on fpath BEFORE
# compinit (40-completion.zsh). From then on startup costs two stat() calls per tool;
# the file is regenerated automatically when the tool's binary is upgraded.
#
#   Add a tool:    _cache_completion <name> <command> [args...]   (see list below)
#   Wipe them:     zsh-clean
# The generated script must start with `#compdef`, otherwise it is discarded
# (so an error message can never end up as a "completion").

_comp_cache_dir="$XDG_CACHE_HOME/zsh/completions"
[[ -d $_comp_cache_dir ]] || mkdir -p "$_comp_cache_dir"

_cache_completion() {
  local name=$1 cmd=$2 first
  local out="$_comp_cache_dir/_$name"
  (( $+commands[$cmd] )) || return 1
  shift

  # a previous attempt failed and the binary hasn't changed since: don't retry on every start
  [[ -e $out.fail && $out.fail -nt $commands[$cmd] ]] && return 1

  if [[ ! -s $out || $commands[$cmd] -nt $out ]]; then
    local fresh=0
    [[ -e $out ]] || fresh=1
    if "$@" >| "$out.tmp" 2>/dev/null; then
      read -r first < "$out.tmp"
      if [[ $first == '#compdef'* ]]; then
        command mv -f -- "$out.tmp" "$out"
        command rm -f -- "$out.fail"
        (( fresh )) && _comp_regen=1
        return 0
      fi
    fi
    command rm -f -- "$out.tmp"
    : >| "$out.fail"
    return 1
  fi
}

#                    name     command   arguments
_cache_completion    gh       gh        completion -s zsh
_cache_completion    uv       uv        generate-shell-completion zsh
_cache_completion    uvx      uvx       --generate-shell-completion zsh
_cache_completion    rustup   rustup    completions zsh
_cache_completion    cargo    rustup    completions zsh cargo
_cache_completion    podman   podman    completion zsh
_cache_completion    kubectl  kubectl   completion zsh
_cache_completion    just     just      --completions zsh

fpath=("$_comp_cache_dir" $fpath)
