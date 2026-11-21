# 35-tool-completions.zsh — completions for ~100 command-line programs, generated on demand.
# Runs BEFORE compinit (40-completion.zsh), so everything here is plain completion files
# on $fpath; compinit registers them via their `#compdef` line.
#
# 1. NATIVE   Tools that print their own zsh completion (`gh completion -s zsh`, ...) are
#             run once; the output is stored as ~/.cache/zsh/completions/_<name>.
#             Output that does not start with `#compdef` is discarded, so an error
#             message can never become a "completion".
# 2. GENERIC  Tools that ship NO completion anywhere on $fpath get a 2-line stub that uses
#             zsh's `_gnu_generic` (parses `<tool> --help` for options). As soon as a real
#             completion appears (package upgrade, zsh-completions), the stub is removed.
#
# Cost: normally 7 stat() calls per shell start. The registry is only re-scanned when
# /usr/bin, /usr/local/bin, ~/.local/bin, ~/.cargo/bin, ~/go/bin or a site-functions
# directory changed (install/upgrade); only tools whose binary changed are regenerated.
# The first scan on a machine with many tools can take a second or two — once.
#
#   See what happened:  comp-status           Rescan now:  zsh-clean   (then open a new shell)
#   Add a tool:         one line in `native` below  ("name|command args...")
#   Postponed to 45-completion-extras.zsh: tools whose scripts need compinit/bashcompinit
#   (npm, pnpm, pip, pipx, terraform, aws, gcloud ...).

_comp_cache_dir="$XDG_CACHE_HOME/zsh/completions"
[[ -d $_comp_cache_dir ]] || mkdir -p "$_comp_cache_dir"

# ---------------------------------------------------------------------------
# _cache_completion <name> <command> [args...]
#   Runs `command args...`; on success (first line `#compdef ...`) stores it as _<name>.
#   Failures are remembered (.fail-<name>) until the binary changes, so a tool that lacks
#   the subcommand costs nothing on later scans. Sets _comp_regen=1 when a NEW file appears
#   (40-completion.zsh then rebuilds the completion dump once).
# ---------------------------------------------------------------------------
_cache_completion() {
  local name=$1 cmd=$2 first
  local out="$_comp_cache_dir/_$name"
  local fail="$_comp_cache_dir/.fail-$name" tmp="$_comp_cache_dir/.tmp-$name"
  local -a runner
  (( $+commands[$cmd] )) || return 1
  shift
  [[ -e $fail && $fail -nt $commands[$cmd] ]] && return 1
  (( $+commands[timeout] )) && runner=(timeout 10)     # a hanging tool must not hang the shell

  if [[ ! -s $out || $commands[$cmd] -nt $out ]]; then
    local fresh=0
    [[ -e $out ]] || fresh=1
    if $runner "$@" >| "$tmp" 2>/dev/null </dev/null; then
      read -r first < "$tmp"
      if [[ $first == '#compdef'* ]]; then
        command mv -f -- "$tmp" "$out"
        command rm -f -- "$fail"
        (( fresh )) && _comp_regen=1
        return 0
      fi
    fi
    command rm -f -- "$tmp"
    : >| "$fail"
    return 1
  fi
}

# ---------------------------------------------------------------------------
# _cache_generic <command...>: _gnu_generic stub for tools without any completion
# ---------------------------------------------------------------------------
_cache_generic() {
  local t out
  local -a found
  for t in "$@"; do
    (( $+commands[$t] )) || continue
    out="$_comp_cache_dir/_$t"
    found=(${^fpath}/_$t(N))
    found=(${found:#${_comp_cache_dir}/*})
    if (( $#found )); then
      # a real completion exists now: drop our stub
      [[ -e $out ]] && { command rm -f -- "$out"; _comp_regen=1; }
    elif [[ ! -e $out ]]; then
      print -r -- "#compdef $t"$'\n''_gnu_generic "$@"' >| "$out"
      _comp_regen=1
    fi
  done
}

# ---------------------------------------------------------------------------
# The registry
# ---------------------------------------------------------------------------
_scan_tool_completions() {
  emulate -L zsh
  local entry name cmdline

  # name | command that prints a zsh completion (first word = the binary that must exist)
  local -a native=(
    # --- git hosting & dev tooling ---
    'gh|gh completion -s zsh'
    'glab|glab completion -s zsh'
    'git-cliff|git-cliff --completions zsh'
    'delta|delta --generate-completion zsh'
    'gitleaks|gitleaks completion zsh'
    'chezmoi|chezmoi completion zsh'
    'just|just --completions zsh'
    'task|task --completion zsh'
    'mise|mise completion zsh'
    'watchexec|watchexec --completions zsh'
    'gum|gum completion zsh'
    'glow|glow completion zsh'

    # --- languages & package managers ---
    'uv|uv generate-shell-completion zsh'
    'uvx|uvx --generate-shell-completion zsh'
    'ruff|ruff generate-shell-completion zsh'
    'poetry|poetry completions zsh'
    'pdm|pdm completion zsh'
    'rustup|rustup completions zsh'
    'cargo|rustup completions zsh cargo'
    'deno|deno completions zsh'
    'golangci-lint|golangci-lint completion zsh'
    'goreleaser|goreleaser completion zsh'
    'hugo|hugo completion zsh'
    'cobra-cli|cobra-cli completion zsh'
    'zola|zola completion zsh'
    'mdbook|mdbook completions zsh'
    'typst|typst completions zsh'

    # --- containers & kubernetes ---
    'docker|docker completion zsh'
    'podman|podman completion zsh'
    'buildah|buildah completion zsh'
    'skopeo|skopeo completion zsh'
    'nerdctl|nerdctl completion zsh'
    'crictl|crictl completion zsh'
    'dive|dive completion zsh'
    'trivy|trivy completion zsh'
    'grype|grype completion zsh'
    'syft|syft completion zsh'
    'cosign|cosign completion zsh'
    'kubectl|kubectl completion zsh'
    'oc|oc completion zsh'
    'helm|helm completion zsh'
    'kind|kind completion zsh'
    'minikube|minikube completion zsh'
    'k9s|k9s completion zsh'
    'kustomize|kustomize completion zsh'
    'flux|flux completion zsh'
    'argocd|argocd completion zsh'
    'istioctl|istioctl completion zsh'
    'stern|stern --completion zsh'

    # --- cloud & services ---
    'doctl|doctl completion zsh'
    'flyctl|flyctl completion zsh'
    'supabase|supabase completion zsh'
    'hcloud|hcloud completion zsh'
    'tailscale|tailscale completion zsh'

    # --- everyday CLI tools ---
    'rg|rg --generate complete-zsh'
    'fd|fd --gen-completions zsh'
    'starship|starship completions zsh'
    'atuin|atuin gen-completions --shell zsh'
    'zellij|zellij setup --generate-completion zsh'
    'btm|btm --completion zsh'
    'procs|procs --gen-completion-out zsh'
    'topgrade|topgrade --gen-completion zsh'
    'rclone|rclone completion zsh -'
    'restic|restic generate --zsh-completion /dev/stdout'
    'rbw|rbw gen-completions zsh'
    'gopass|gopass completion zsh'
    'yq|yq shell-completion zsh'
  )

  for entry in "${native[@]}"; do
    name=${entry%%|*}
    cmdline=${entry#*|}
    _cache_completion "$name" ${(z)cmdline}
  done

  # Tools that usually ship no completion: `--help` based fallback (see header).
  _cache_generic \
    dust duf tokei sd hyperfine fastfetch gping bandwhich xh hexyl pastel viu lsd \
    bat eza btop ncdu tldr ouch cliphist \
    grim slurp wf-recorder wlr-randr wofi fuzzel mako makoctl swayidle swaylock swaybg \
    kanshi wlogout
}

# Re-scan only when something that could add/upgrade a tool or a completion changed.
_stamp="$_comp_cache_dir/.scan"
_need=0
[[ -e $_stamp ]] || _need=1
for _d in /usr/bin /usr/local/bin "$HOME/.local/bin" "$HOME/.cargo/bin" "$HOME/go/bin" \
          /usr/share/zsh/site-functions /usr/share/zsh/vendor-completions; do
  [[ -d $_d && $_d -nt $_stamp ]] && _need=1
done
if (( _need )); then
  _scan_tool_completions
  : >| "$_stamp"
fi
unset _stamp _need _d

fpath=("$_comp_cache_dir" $fpath)
