# 75-fzf.zsh — fzf environment + init.
# Loaded after 50-keybindings.zsh so fzf's CTRL-T/R/ALT-C bindings are the
# default state — your custom bindings win without you having to worry about
# rebinding.
if (( ! $+commands[fzf] )); then
  return 0
fi

# --- Tree/dir preview command, detected once (also used by 76-fzf-functions) ---
# Previews run under `sh`, so aliases don't apply; pick the tool explicitly.
if (( $+commands[eza] )); then
  _fzf_tree='eza -T -L2 --color=always --icons=never'
elif (( $+commands[tree] )); then
  _fzf_tree='tree -C -L 2'
else
  _fzf_tree='ls -1 --color=always'
fi

# --- Default finder command ---
if (( $+commands[rg] )); then
  export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git"'
elif (( $+commands[fd] )); then
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git --exclude node_modules'
else
  export FZF_DEFAULT_COMMAND='find . -type f -not -path "*/\.git/*" -not -path "*/node_modules/*"'
fi

# --- Path / directory completion (`**<Tab>`, fzf >= 0.53) ---
# (A second, later assignment of `--walker dir` used to override this, so
#  `vim **<Tab>` only listed directories. Directories-only is now just for `cd`.)
export FZF_COMPLETION_PATH_OPTS='--walker file,dir,follow,hidden'
export FZF_COMPLETION_DIR_OPTS='--walker dir,follow,hidden'

# --- Clipboard command, detected once ---
if [[ -n ${WAYLAND_DISPLAY:-} ]] && (( $+commands[wl-copy] )); then
  _fzf_clip_copy='wl-copy'
elif [[ -n ${DISPLAY:-} ]] && (( $+commands[xclip] )); then
  _fzf_clip_copy='xclip -selection clipboard'
else
  _fzf_clip_copy=''
fi

# --- General options ---
# NOTE: requires fzf >= 0.58 for --style=full; drop that line on older fzf.
# (ctrl-b/f/u/d are rebound to preview scrolling, so they no longer edit the query line.)
export FZF_DEFAULT_OPTS="\
--exact \
--smart-case \
--algo=v2 \
--height=60% \
--layout=reverse \
--margin=0,5 \
--padding=1,2 \
--border=rounded \
--border-label=' FZF' \
--border-label-pos=top \
--cycle \
--info=inline \
--prompt='> ' \
--pointer='→' \
--marker='+' \
--header='Use CTRL-C or ESC to cancel' \
--header-first \
--color='fg+:#81a1c1,fg:#d8dee9,bg:#2E3440,border:#4C566A,spinner:0,info:#a3be8c,pointer:#bf616a,marker:#81A1C1,prompt:#eceff4' \
--bind='ctrl-b:preview-page-up' \
--bind='ctrl-f:preview-page-down' \
--bind='ctrl-u:preview-half-page-up' \
--bind='ctrl-d:preview-half-page-down' \
--style=full \
"

# --- CTRL-T: file picker with preview ---
if (( $+commands[bat] )); then
  _fzf_ct_preview='bat -n --color=always {}'
else
  _fzf_ct_preview='head -100 {}'
fi
export FZF_CTRL_T_OPTS="\
--walker-skip .git,node_modules,target \
--preview '$_fzf_ct_preview' \
--bind 'ctrl-/:change-preview-window(down|hidden|)' \
--preview-window=right:60%:wrap \
"
unset _fzf_ct_preview

# --- CTRL-R: history picker with clipboard bind ---
if [[ -n $_fzf_clip_copy ]]; then
  export FZF_CTRL_R_OPTS="\
--height 80% \
--margin 0,10 \
--preview-window='bottom:3:wrap:border-top,<50(bottom:3:wrap:border-top)' \
--with-nth '2..' \
--preview 'echo {2..}' \
--bind 'ctrl-y:execute-silent(echo -n {2..} | $_fzf_clip_copy)+abort' \
--bind 'change:first' \
--color header:italic \
--header 'Press CTRL-Y to copy command into clipboard'"
else
  export FZF_CTRL_R_OPTS="\
--height 80% \
--margin 0,10 \
--preview-window='bottom:3:wrap:border-top,<50(bottom:3:wrap:border-top)' \
--with-nth '2..' \
--preview 'echo {2..}' \
--bind 'change:first' \
--color header:italic"
fi
unset _fzf_clip_copy

# --- ALT-C: cd picker with tree preview ---
export FZF_ALT_C_OPTS="\
--walker-skip .git,node_modules,target \
--preview '$_fzf_tree {}' \
"

# --- Init (cached: one `fzf --zsh` run per fzf upgrade instead of two per shell) ---
if _cache_path fzf fzf --zsh; then
  source "$REPLY"
elif [[ -f "$HOME/.fzf.zsh" ]]; then       # old fzf (< 0.48)
  source "$HOME/.fzf.zsh"
fi

# --- Per-command previews for `**<Tab>` completion ---
_fzf_comprun() {
  local command=$1
  shift
  case "$command" in
    beet|cd|z|zi|pushd)
      fzf --preview "$_fzf_tree {}" "$@" ;;
    *)
      fzf "$@" ;;
  esac
}
