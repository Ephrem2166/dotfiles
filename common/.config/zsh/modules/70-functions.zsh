# 70-functions.zsh — named functions only. No side effects at load time.
# Rules:
#   1. No side effects at file load. Everything runs only when called.
#   2. Every `local` declaration in the function body.
#   3. Quote all expansions.
#   4. Use `command <cmd>` when you don't want the shell's alias/function of the same name.
#   5. `print -u2` for errors (not `echo >&2`).

# ---------------------------------------------------------------------------
# Compression
# ---------------------------------------------------------------------------
compress() {
  if (( $# < 2 )); then
    print -u2 'Usage: compress <archive> <file...>'
    return 1
  fi
  local archive_name=$1
  shift
  local file ok=true
  for file in "$@"; do
    [[ -e $file ]] || { print -u2 "Not found: $file"; ok=false; }
  done
  $ok || return 1
  if tar -czvf "${archive_name}.tar.gz" "$@"; then
    print "Success: ${archive_name}.tar.gz"
  else
    print -u2 "Error: ${archive_name}.tar.gz was not created"
    return 1
  fi
}

decompress() {
  [[ -f $1 ]] || { print -u2 "'$1' not a valid file"; return 1; }
  case $1 in
    *.tar.bz2) tar xvjf "$1" ;;
    *.tar.gz)  tar xvzf "$1" ;;
    *.bz2)     bunzip2 "$1" ;;
    *.rar)     unrar x "$1" ;;
    *.gz)      gunzip "$1" ;;
    *.tar)     tar xvf "$1" ;;
    *.tbz2)    tar xvjf "$1" ;;
    *.tgz)     tar xvzf "$1" ;;
    *.zip)     unzip "$1" ;;
    *.Z)       uncompress "$1" ;;
    *.7z)      7z x "$1" ;;
    *.xz)      unxz "$1" ;;
    *)         print -u2 "'$1' unknown compression"; return 1 ;;
  esac
}

# ---------------------------------------------------------------------------
# Tmux session
# ---------------------------------------------------------------------------
t() {
  local name=${1:-main}
  tmux new-session -A -s "$name"
}

# ---------------------------------------------------------------------------
# Yazi file manager (with cd-on-exit)
# ---------------------------------------------------------------------------
y() {
  local tmp cwd
  tmp=$(mktemp -t yazi-cwd.XXXXXX) || return
  command yazi "$@" --cwd-file="$tmp"
  IFS= read -r -d '' cwd < "$tmp"
  [[ -n $cwd && $cwd != "$PWD" && -d $cwd ]] && builtin cd -- "$cwd"
  command rm -f -- "$tmp"
}

# ---------------------------------------------------------------------------
# Open PDF in mupdf
# ---------------------------------------------------------------------------
# o() {
#   [[ -z $1 ]] && { print -u2 'Please specify file to read'; return 1; }
#   mupdf -I "$1"
# }

# ---------------------------------------------------------------------------
# fzf cd — jump to a subdirectory
# ---------------------------------------------------------------------------
fcd() {
  local dir
  dir=$(find . -type d 2>/dev/null | fzf --preview 'tree -C {} | head -200' --preview-window 'up:60%')
  [[ -n $dir ]] && builtin cd -- "$dir"
}

# ---------------------------------------------------------------------------
# fzf rm — multi-select and confirm before delete
# ---------------------------------------------------------------------------
frm() {
  local selected
  selected=$(find . -mindepth 1 \( -type f -o -type d \) 2>/dev/null | fzf -m)
  [[ -z $selected ]] && { print 'No selection.'; return; }
  print 'Will delete:'
  print -l -- $selected
  printf 'Continue? [y/N] '
  read -q && print
  [[ $REPLY == y ]] || return 1
  print -l -- $selected | xargs -d '\n' rm -rf
}

# ---------------------------------------------------------------------------
# Open in the default app (background)
# ---------------------------------------------------------------------------
open_pdf() {
  xdg-open "$@" >/dev/null 2>&1 &
}

# ---------------------------------------------------------------------------
# Process search
# ---------------------------------------------------------------------------
pf() {
  [[ -z $1 ]] && { print -u2 'pf needs a process name'; return 1; }
  ps -aux | command rg "$1"
}

# ---------------------------------------------------------------------------
# System update — distro-aware
# ---------------------------------------------------------------------------
update_system() {
  if (( $+commands[zypper] )); then
    sudo zypper dup
  elif (( $+commands[pacman] )); then
    sudo pacman -Syu
  fi
  (( $+commands[flatpak] )) && flatpak update
}

# ---------------------------------------------------------------------------
# mkdir + cd
# ---------------------------------------------------------------------------
mk() {
  mkdir -p "$@" && builtin cd -- "$1"
}

# ---------------------------------------------------------------------------
# Daily file: 2026-01-15_notes.md
# ---------------------------------------------------------------------------
daily_file() {
  local today name
  today=$(date -I)
  name="${today}_$1.$2"
  touch -- "$name" && nvim -- "$name"
}

# ---------------------------------------------------------------------------
# Local + external IP
# ---------------------------------------------------------------------------
myip() {
  hostname -I | awk '{print $1}'
  print -n 'External: '
  curl -s ifconfig.me
  print
}

# ---------------------------------------------------------------------------
# cheat.sh lookup
# ---------------------------------------------------------------------------
ch() {
  [[ -z $1 ]] && { print -u2 'No command to look up'; return 1; }
  local path=$1
  [[ -n $2 ]] && path="$path/$2"
  curl "https://cht.sh/$path"
}

# ---------------------------------------------------------------------------
# Is a command installed?
# ---------------------------------------------------------------------------
is_installed() {
  if (( $+commands[$1] )); then
    print "$1 is installed!"
    return 0
  fi
  print -u2 "$1 is not installed!"
  return 1
}

# ---------------------------------------------------------------------------
# Color palette (256 colors)
# ---------------------------------------------------------------------------
color_text() {
  local code
  for code in {000..255}; do
    printf "%s: \033[38;5;%smThis is how your text would look like\033[0m\n" "$code" "$code"
  done
}

# ---------------------------------------------------------------------------
# SSH key creation (ed25519 by default; chmod public key 0644)
# ---------------------------------------------------------------------------
ssh-create() {
  [[ -z $1 ]] && { print -u2 'Usage: ssh-create <name>'; return 1; }
  local key="$HOME/.ssh/$1"
  ssh-keygen -f "$key" -t ed25519 -N '' -C "$1"
  chmod 700 "$key"
  [[ -f "$key.pub" ]] && chmod 644 "$key.pub"
}

# ---------------------------------------------------------------------------
# History statistics
# ---------------------------------------------------------------------------
historystat() {
  fc -l 1 | awk '{print $2}' | sort | uniq -c | sort -rn | head
}

# ---------------------------------------------------------------------------
# Mount / umount
# ---------------------------------------------------------------------------
mnt() {
  [[ -z $1 ]] && { print -u2 'Usage: mnt <device> [mountpoint]'; print -u2 'Hint: lsblk'; return 1; }
  local target=${2:-/mnt/external}
  sudo mount "$1" "$target" -o rw && print "Mounted $1 at $target"
}

umnt() {
  local dir=${1:-/mnt} mounted
  mounted=$(findmnt -rno TARGET "$dir" 2>/dev/null | sort -r)
  [[ -z $mounted ]] && { print -u2 "Nothing mounted under $dir"; return 1; }
  sudo umount $mounted && print "Unmounted: $mounted"
}

# ---------------------------------------------------------------------------
# Random password — uses /dev/urandom (never blocks)
# ---------------------------------------------------------------------------
pass() {
  local size=${1:-20}
  LC_ALL=C tr -dc '[:graph:]' < /dev/urandom | head -c "$size"
  print
}

# ---------------------------------------------------------------------------
# Disk usage, human sort
# ---------------------------------------------------------------------------
du1() { du -h --max-depth=1 "$@" | sort -k1,1hr -k2,2f; }
du2() { du -h --max-depth=1 "$@" | sort -k1,1h  -k2,2f; }

# ---------------------------------------------------------------------------
# fzf font list
# ---------------------------------------------------------------------------
fontlist() {
  fc-list | sed 's/[^:]*: //' | fzf
}

# ---------------------------------------------------------------------------
# Colorized which (falls back to builtin if bat is missing)
# ---------------------------------------------------------------------------
which() {
  if (( $+commands[bat] )); then
    builtin which -a "$@" | bat --language=sh --wrap=character
  else
    builtin which -a "$@"
  fi
}

# ---------------------------------------------------------------------------
# Base64 encode/decode to/from Wayland clipboard
# ---------------------------------------------------------------------------
b64e() {
  print -n -- "$1" | base64 | wl-copy
  wl-paste; print
  print -u2 'Copied to clipboard.'
}

b64d() {
  print -n -- "$1" | base64 --decode | wl-copy
  wl-paste; print
}

# ---------------------------------------------------------------------------
# History grep
# ---------------------------------------------------------------------------
hgrep() {
  fc -l 1 | command grep -i --color=auto "$@" | fzf
}

# ---------------------------------------------------------------------------
# Top 10 most-used commands
# ---------------------------------------------------------------------------
top10() {
  fc -l 1 | awk '{print $2}' | sort | uniq -c | sort -rn | head
}

# ---------------------------------------------------------------------------
# Up N directories
# ---------------------------------------------------------------------------
up() {
  local d='' limit=${1:-1} i
  for (( i = 1; i <= limit; i++ )); do
    d+='/..'
  done
  builtin cd -- "${d#/}" 2>/dev/null || builtin cd ..
}

# ---------------------------------------------------------------------------
# Command frequency (same as top10 but different name)
# ---------------------------------------------------------------------------
freq_commands() {
  fc -l 1 | awk '{print $2}' | sort | uniq -c | sort -rn | head -10
}

# ---------------------------------------------------------------------------
# Make a timestamped backup
# ---------------------------------------------------------------------------
make-bak() {
  [[ -n $1 ]] || { print -u2 'Usage: make-bak <file>'; return 1; }
  cp -a -- "$1" "${1}_$(date '+%Y-%m-%d').bak"
}

# ---------------------------------------------------------------------------
# Cleanup by extension (prints then deletes; safe-by-print)
# ---------------------------------------------------------------------------
cleanup() {
  [[ -z $1 ]] && { print -u2 'Usage: cleanup <ext>'; return 1; }
  find . -type f -name "*.$1" -print -delete
}

# ---------------------------------------------------------------------------
# Add a directory to PATH if not already present
# ---------------------------------------------------------------------------
add_to_path() {
  local dir=$1
  [[ -d $dir ]] || return 0
  [[ ":$PATH:" == *":$dir:"* ]] && return 0
  path=("$dir" $path)
}
