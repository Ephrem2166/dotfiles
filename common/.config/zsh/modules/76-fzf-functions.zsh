# 76-fzf-functions.zsh — user utilities built on fzf.
# Loaded after 75-fzf.zsh so fzf's env is set, and after 70-functions.zsh so
# nothing here shadows a generic function by accident.
# --- fzf default walker overrides ---
# fzf's built-in `**` completion calls these when defined.
if (( $+commands[fd] )); then
  _fzf_compgen_path() {
    fd --hidden --follow --exclude .git --exclude node_modules . "$1"
  }
  _fzf_compgen_dir() {
    fd --type d --hidden --follow --exclude .git --exclude node_modules . "$1"
  }
fi

# --- fman: browse man pages ---
fman() {
  man -k . | fzf -q "$1" --prompt='man> ' \
    --preview $'echo {} | tr -d \'()\' | awk \'{printf "%s ", $2} {print $1}\' | xargs -r man' \
    | tr -d '()' | awk '{printf "%s ", $2} {print $1}' | xargs -r man
}


# --- fman2: man page browser via zsh command list ---
# (was `_fman`: underscore names are hidden from completion and look internal)
fman2() {
  print -l -- ${(k)commands} | fzf --prompt='man> ' | xargs -r man
}

# --- fif: find pattern in files, preview matches ---
fif() {
  (( $# > 0 )) || { print -u2 'Usage: fif <pattern>'; return 1; }
  rg --files-with-matches --no-messages -- "$1" \
    | fzf --preview "rg --colors 'match:bg:yellow' --ignore-case --pretty --context 10 -- ${(q)1} {}" \
          --preview-window=right:60%:wrap \
          --prompt="Search for: $1> "
}

# --- fifa: find via ripgrep-all (archive-aware) ---
fifa() {
  (( $# > 0 )) || { print -u2 'Usage: fifa <pattern>'; return 1; }
  (( $+commands[rga] )) || { print -u2 'rga (ripgrep-all) is not installed'; return 1; }
  local file pat="$*"
  local prev="rga --ignore-case --pretty --context 10 -- ${(q)pat} {}"
  if [[ -n $TMUX ]]; then
    file=$(rg --max-count=1 --ignore-case --files-with-matches --no-messages -- "$pat" \
      | fzf-tmux -p +m --preview="$prev")
  else
    file=$(rg --max-count=1 --ignore-case --files-with-matches --no-messages -- "$pat" \
      | fzf --preview="$prev")
  fi
  [[ -n $file ]] && print -z "./$file"
}

# --- fepub / fpdf: browse and open in zathura ---
fepub() {
  local result
  result=$(find . -type f -name '*.epub' | fzf --bind "ctrl-r:reload(find . -type f -name '*.epub')")
  if [[ -n $result ]]; then
    nohup zathura "$result" &>/dev/null &!
  fi
}

fpdf() {
  local result
  result=$(find . -type f -name '*.pdf' \
    | fzf --bind "ctrl-r:reload(find . -type f -name '*.pdf')" \
          --preview "pdftotext {} - 2>/dev/null | head -100")
  if [[ -n $result ]]; then
    nohup zathura "$result" &>/dev/null &!
  fi
}

# --- vf: multi-select files, open in $EDITOR split ---
vf() {
  local tmp
  tmp=$(mktemp) || return 1
  fzf -i --walker=file,dir,follow,hidden --walker-skip=.git,node_modules \
      --header="Select a file to edit" --input-label="Filename" \
      --preview-label="Edit this file:" \
      --preview="bat --color=always --style=plain,changes,numbers {}" \
      --preview-window="border:rounded" --border=double --scroll-off=3 \
      --prompt="> " --pointer="->" --layout=reverse --multi=3 \
      > "$tmp"
  xargs -r -o -a "$tmp" "${EDITOR:-vim}" -o
  command rm -f -- "$tmp"
}

# --- list_packages: browse and remove distro packages ---
list_packages() {
  if (( $+commands[pacman] )); then
    pacman -Qq | fzf -m --preview 'pacman -Qil {}' \
      --border=rounded --margin=1% --layout=reverse \
      --bind 'enter:execute(echo "Selected: "{+}; sudo pacman -Rns {+})+abort'
  elif (( $+commands[rpm] )); then
    # rpm is much faster than `zypper se -i`; {+} = all multi-selected packages
    rpm -qa --qf '%{NAME}\n' | sort -u | fzf -m \
      --preview 'rpm -qi {}' \
      --border=rounded --margin=1% --layout=reverse \
      --header 'TAB: multi-select, ENTER: remove selected (sudo zypper rm)' \
      --bind 'enter:execute(echo "Selected: "{+}; sudo zypper rm {+})+abort'
  else
    print -u2 'No supported package manager found (pacman/rpm)'
    return 1
  fi
}

# --- zopen: browse ~/.config and open in $EDITOR ---
zopen() {
  local fname
  builtin cd "${XDG_CONFIG_HOME:-$HOME/.config}" || return 1
  fname=$(fzf) || { builtin cd - >/dev/null; return 1; }
  $EDITOR "$fname"
  builtin cd - >/dev/null
}

# --- fopen: grep + fzf + open in $EDITOR (rg when available: respects .gitignore) ---
fopen() {
  local file editor preview_cmd
  editor=${EDITOR:-vim}
  if (( $+commands[bat] )); then
    preview_cmd='bat --color always --style=plain --paging=never {}'
  else
    preview_cmd='cat {}'
  fi
  if (( $+commands[rg] )); then
    file=$(rg -il --hidden --glob '!.git' -- "${1:-.}" 2>/dev/null \
      | fzf --height 80% --layout=reverse --cycle \
            --preview-window right:60% --preview "$preview_cmd")
  else
    file=$(grep -irl -- "${1:-}" ./ 2>/dev/null \
      | fzf --height 80% --layout=reverse --cycle \
            --preview-window right:60% --preview "$preview_cmd")
  fi
  if [[ -n $file ]]; then
    "$editor" "$file"
  else
    print -u2 'No file selected.'
  fi
}

# NOTE: `frm` is intentionally NOT here — it lives in 70-functions.zsh with a
# confirmation prompt. Don't define it twice.

# --- fkill: pick processes and signal them (default SIGTERM) ---
# usage: fkill [SIGNAL]      e.g. fkill KILL
fkill() {
  local sig=${1:-TERM}
  local -a pids
  pids=(${(f)"$(ps -u "$USER" -o pid=,comm= \
    | fzf -m --header="Selected processes get SIG$sig" --prompt='kill> ' \
    | awk '{print $1}')"})
  (( $#pids )) || return 0
  kill -s "$sig" "${pids[@]}"
}

# --- fzfcd / fcd: fuzzy cd to a subdirectory (skips .git, node_modules) ---
fzfcd() {
  local dir root=${1:-.}
  if (( $+commands[fd] )); then
    dir=$(fd --type d --hidden --follow --exclude .git --exclude node_modules . "$root" \
      | fzf +m --prompt='cd> ' --preview "$_fzf_tree {}" --preview-window 'up:60%')
  else
    dir=$(find "$root" \( -name .git -o -name node_modules \) -prune -o -type d -print 2>/dev/null \
      | fzf +m --prompt='cd> ' --preview "$_fzf_tree {}" --preview-window 'up:60%')
  fi
  [[ -n $dir ]] && builtin cd -- "$dir"
}
fcd() { fzfcd "$@"; }

# --- fzfhist: search history, edit then run ---
fzfhist() {
  local cmd
  cmd=$(fc -l 1 | fzf --tac --prompt='hist> ' | sed -E 's/^[[:space:]]*[0-9]+[[:space:]]+//')
  [[ -n $cmd ]] && print -z -- "$cmd"
}

# --- fsc: systemd unit browser ---
fsc() {
  (( $+commands[systemctl] )) || { print -u2 'systemd not available'; return 1; }
  local unit
  unit=$(systemctl list-units --all --plain --no-legend --no-pager \
    | fzf --prompt='systemd> ' | awk '{print $1}')
  [[ -n $unit ]] && systemctl status "$unit"
}

# --- fgl: git log browser with per-commit preview ---
fgl() {
  (( $+commands[git] )) || return 1
  git log --oneline --graph --color=always \
    | fzf --ansi --no-sort --reverse --prompt='git log> ' \
          --preview 'git show --color=always $(echo {} | grep -o "[a-f0-9]\{7,\}" | head -1)' \
          --preview-window=right:60%:wrap \
          --bind 'enter:execute(git show --color=always $(echo {} | grep -o "[a-f0-9]\{7,\}" | head -1) | less -R)'
}

# --- fzf_grep: grep + fzf + open at matching line ---
fzf_grep() {
  local pattern=${1:-} file prev
  [[ -n $pattern ]] || { print -u2 'Usage: fzf_grep <pattern>'; return 1; }
  (( $+commands[rg] )) || { print -u2 'ripgrep (rg) is required'; return 1; }
  if (( $+commands[bat] )); then
    prev='bat --style=numbers --color=always --highlight-line {2} {1}'
  else
    prev='cat {1}'
  fi
  file=$(rg --line-number --color=never --no-heading --smart-case -- "$pattern" 2>/dev/null \
    | fzf --delimiter=: --nth=1..2 \
          --preview "$prev" \
          --preview-window='right:50%:wrap:+{2}-5' \
          --prompt="grep: $pattern> " \
          --bind="ctrl-o:execute(${EDITOR:-vim} +{2} {1})+abort")
  if [[ -n $file ]]; then
    local line=${file#*:}; line=${line%%:*}
    local f=${file%%:*}
    ${EDITOR:-vim} +"$line" "$f"
  fi
}

# --- fenv: browse and copy environment variables ---
fenv() {
  local var name
  var=$(env | fzf --height 40% --prompt='env> ' --preview 'echo {} | cut -d= -f2-')
  [[ -z $var ]] && return 0
  name=${var%%=*}
  if print -rn -- "$var" | _clip; then
    print "Copied: $name"
  else
    print -u2 'No clipboard tool (wl-copy or xclip) available'
    return 1
  fi
}

# --- fedit: multi-select files, open ALL in $EDITOR at once ---
# (was: `... | while read; do $editor`, which gave the editor a pipe as stdin)
fedit() {
  local editor=${EDITOR:-vim}
  local -a files
  files=(${(f)"$(fzf -m \
    --preview 'bat --style=numbers --color=always {} 2>/dev/null || cat {}' \
    --preview-window=right:50%:wrap --prompt='edit> ')"})
  (( $#files )) || return 0
  "$editor" "${files[@]}"
}
