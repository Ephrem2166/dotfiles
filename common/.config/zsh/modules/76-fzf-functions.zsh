# 76-fzf-functions.zsh — user utilities built on fzf.
# Loaded after 75-fzf.zsh so fzf's env is set, and after 70-functions.zsh so
# nothing here shadows a generic function by accident.

# --- fzf default walker overrides ---
# fzf's built-in `**` completion calls these. Fix the `--exclude` typo
# (`-exclude` was invalid) and prefer fd if available, else fall back to find.
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

# --- fif: find pattern in files, preview matches ---
fif() {
  (( $# > 0 )) || { print -u2 'Usage: fif <pattern>'; return 1; }
  rg --files-with-matches --no-messages "$1" \
    | fzf --preview "rg --colors 'match:bg:yellow' --ignore-case --pretty --context 10 '$1' {}" \
          --preview-window=right:60%:wrap \
          --prompt="Search for: $1> "
}

# --- fifa: find via ripgrep-all (archive-aware) ---
fifa() {
  (( $# > 0 )) || { print -u2 'Usage: fifa <pattern>'; return 1; }
  (( $+commands[rga] )) || { print -u2 'rga (ripgrep-all) is not installed'; return 1; }
  local file
  if [[ -n $TMUX ]]; then
    file=$(rg --max-count=1 --ignore-case --files-with-matches --no-messages "$*" \
      | fzf-tmux -p +m --preview="rga --ignore-case --pretty --context 10 '$*' {}")
  else
    file=$(rg --max-count=1 --ignore-case --files-with-matches --no-messages "$*" \
      | fzf --preview="rga --ignore-case --pretty --context 10 '$*' {}")
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

# --- vf: multi-select files, open in vim split ---
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
  xargs -r -o -a "$tmp" vim -n -T alacritty -o
  rm -f "$tmp"
}

# --- list_packages: browse and remove distro packages ---
list_packages() {
  if (( $+commands[pacman] )); then
    pacman -Qq | fzf -m --preview 'pacman -Qil {}' \
      --border=rounded --margin=1% --layout=reverse \
      --bind 'enter:execute(echo "Selected: "{+}; sudo pacman -Rns {+})+abort'
  elif (( $+commands[zypper] )); then
    zypper --no-refresh se -i | awk '/^i/{print $3}' | fzf -m \
      --preview 'zypper --no-refresh info {1} 2>/dev/null' \
      --border=rounded --margin=1% --layout=reverse \
      --bind 'enter:execute(echo "Selected: "{1}; sudo zypper rm {1})+abort'
  else
    print -u2 'No supported package manager found (pacman/zypper)'
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

# --- fopen: grep + fzf + open in $EDITOR ---
fopen() {
  local file editor preview_cmd
  editor=${EDITOR:-vim}
  if (( $+commands[bat] )); then
    preview_cmd='bat --color always --style=plain --paging=never {}'
  else
    preview_cmd='cat {}'
  fi
  file=$(grep -irl "${1:-}" ./ 2>/dev/null \
    | fzf --height 80% --layout=reverse --cycle \
          --preview-window right:60% --preview "$preview_cmd")
  if [[ -n $file ]]; then
    "$editor" "$file"
  else
    print -u2 'No file selected.'
  fi
}

# NOTE: `frm` is intentionally NOT here — it lives in 70-functions.zsh with a
# confirmation prompt. Don't define it twice.

# --- fkill: pick a process and kill it ---
fkill() {
  local pids
  pids=$(ps -u "$USER" -o pid,comm --no-headers \
    | fzf -m --header='CTRL-K to kill' --prompt='kill> ' \
    | awk '{print $1}')
  [[ -z $pids ]] && return 0
  print -l -- $pids | xargs -r kill -9 2>/dev/null
}

# --- fman2: man page browser via zsh command list ---
# (Old _fman used `compgen -c` — bash-only. This is the zsh equivalent.)
_fman() {
  print -l -- ${(k)commands} | fzf --prompt='man> ' | xargs -r man
}

# --- fzfcd: fuzzy cd to a subdirectory ---
fzfcd() {
  local dir
  dir=$(find "${1:-.}" -type d 2>/dev/null | fzf +m --prompt='cd> ')
  [[ -n $dir ]] && builtin cd -- "$dir"
}

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
  unit=$(systemctl list-units --all --no-pager | sed 1d \
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
  local pattern=${1:-}
  local file
  [[ -n $pattern ]] || { print -u2 'Usage: fzf_grep <pattern>'; return 1; }
  (( $+commands[rg] )) || { print -u2 'ripgrep (rg) is required'; return 1; }
  file=$(rg --line-number --color=never --no-heading --smart-case "$pattern" 2>/dev/null \
    | fzf --delimiter=: --nth=1..2 \
          --preview 'bat --style=numbers --color=always {1} 2>/dev/null | grep -C 3 --color=always {2}' \
          --preview-window=right:50%:wrap \
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
  if [[ -n ${WAYLAND_DISPLAY:-} ]] && (( $+commands[wl-copy] )); then
    print -rn -- "$var" | wl-copy
  elif [[ -n ${DISPLAY:-} ]] && (( $+commands[xclip] )); then
    print -rn -- "$var" | xclip -selection clipboard
  else
    print -u2 'No clipboard tool (wl-copy or xclip) available'
    return 1
  fi
  print "Copied: $name"
}

# --- fedit: multi-select files, open in $EDITOR ---
fedit() {
  local files editor
  editor=${EDITOR:-vim}
  files=$(fzf -m \
    --preview 'bat --style=numbers --color=always {} 2>/dev/null || cat {}' \
    --preview-window=right:50%:wrap --prompt='edit> ')
  [[ -z $files ]] && return 0
  print -l -- $files | while IFS= read -r file; do
    [[ -n $file ]] && "$editor" "$file"
  done
}




# FZF with Beets
# bif: Fuzzy-find a directory and import it with beet
bif() {
  local dir
  # Use fd or find to list directories and pipe to fzf
  dir=$(fd --type d --hidden --exclude .git --exclude node_modules 2>/dev/null | fzf --prompt='Import to beet> ' --preview 'tree -C {} | head -100')
  # If a directory was selected, run beet import on it
  [[ -n "$dir" ]] && beet import "$dir"
}


# bls: Fuzzy-select an artist/album from your beets library
bls() {
  local query
  # Use beet ls to get a list of unique artists/albums
  query=$(beet ls -f '$albumartist - $album' 2>/dev/null | sort -u | fzf --prompt='Select album> ' --preview 'beet ls -f "$albumartist - $album"')
  # If a selection was made, pass it to the provided beet command
  [[ -n "$query" ]] && beet "$1" "$query"
}
