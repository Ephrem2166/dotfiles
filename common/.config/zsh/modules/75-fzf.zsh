# 75-fzf.zsh — fzf environment + init.
# Loaded after 50-keybindings.zsh so fzf's CTRL-T/R/ALT-C bindings are the
# default state — your custom bindings win without you having to worry about
# rebinding.

if (( ! $+commands[fzf] )); then
  return 0
fi

# --- Default finder command ---
# rg respects .gitignore, skips .git itself, and is faster than fd/find on
# large trees. If ripgrep is not installed, fall back to fd, then find.
if (( $+commands[rg] )); then
  export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git"'
elif (( $+commands[fd] )); then
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git --exclude node_modules'
else
  export FZF_DEFAULT_COMMAND='find . -type f -not -path "*/\.git/*" -not -path "*/node_modules/*"'
fi

# --- Path / directory completion (fzf >= 0.53 `**` completion) ---
export FZF_COMPLETION_PATH_OPTS='--walker file,dir,follow,hidden'
# export FZF_COMPLETION_DIR_OPTS='--walker dir,follow'

# --- Clipboard command, detected once ---
# Wayland → wl-copy; X11 → xclip; neither → no clipboard binding.
if [[ -n ${WAYLAND_DISPLAY:-} ]] && (( $+commands[wl-copy] )); then
  _fzf_clip_copy='wl-copy'
elif [[ -n ${DISPLAY:-} ]] && (( $+commands[xclip] )); then
  _fzf_clip_copy='xclip -selection clipboard'
else
  _fzf_clip_copy=''
fi

# --- General options ---
# NOTE: requires fzf >= 0.53 for --walker-*, --style, --border=rounded.
# Comment out the specific lines that error if you're on an older fzf.
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

# --- CTRL-T: file picker with bat preview ---
if (( $+commands[bat] )); then
  export FZF_CTRL_T_OPTS="\
--walker-skip .git,node_modules,target \
--preview 'bat -n --color=always {}' \
--bind 'ctrl-/:change-preview-window(down|hidden|)' \
--border=rounded \
--preview-window=right:60%:wrap \
"
else
  export FZF_CTRL_T_OPTS="\
--walker-skip .git,node_modules,target \
--preview 'head -100 {}' \
--bind 'ctrl-/:change-preview-window(down|hidden|)' \
--border=rounded \
--preview-window=right:60:wrap \
"
fi

# --- CTRL-R: history picker with clipboard bind ---
# We build the bind string conditionally so it works with or without clipboard.
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
--preview 'tree -C {}' \
"

# --- Init ---
# `fzf --zsh` is available on fzf >= 0.48. Older installs used ~/.fzf.zsh.
if fzf --zsh >/dev/null 2>&1; then
  eval "$(fzf --zsh)"
elif [[ -f "$HOME/.fzf.zsh" ]]; then
  source "$HOME/.fzf.zsh"
fi
