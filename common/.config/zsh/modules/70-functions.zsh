# 70-functions.zsh — named functions only. No side effects at load time.
# Rules:
#   1. No side effects at file load. Everything runs only when called.
#   2. Every `local` declaration in the function body.
#   3. Quote all expansions.
#   4. Use `command <cmd>` when you don't want the shell's alias/function of the same name.
#   5. `print -u2` for errors (not `echo >&2`).

# ---------------------------------------------------------------------------
# Helper: copy stdin to the clipboard (Wayland, then X11). Returns 1 if none.
# ---------------------------------------------------------------------------
_clip() {
  if [[ -n ${WAYLAND_DISPLAY:-} ]] && (( $+commands[wl-copy] )); then
    wl-copy
  elif [[ -n ${DISPLAY:-} ]] && (( $+commands[xclip] )); then
    xclip -selection clipboard
  else
    return 1
  fi
}

# Helper: print the clipboard contents (no trailing newline). Returns 1 if no tool.
_clip_paste() {
  if [[ -n ${WAYLAND_DISPLAY:-} ]] && (( $+commands[wl-paste] )); then
    wl-paste --no-newline
  elif [[ -n ${DISPLAY:-} ]] && (( $+commands[xclip] )); then
    xclip -selection clipboard -o
  else
    return 1
  fi
}

# cpath [path]: copy the absolute path of a file/dir (default: current directory)
cpath() {
  local target=${1:+${1:A}}
  target=${target:-$PWD}
  if print -rn -- "$target" | _clip; then
    print "Copied: $target"
  else
    print -u2 'No clipboard tool (install wl-clipboard or xclip)'; return 1
  fi
}

# cfile <file>: copy the CONTENTS of a text file
cfile() {
  [[ -r $1 ]] || { print -u2 'Usage: cfile <readable-file>'; return 1; }
  if _clip < "$1"; then
    print "Copied contents of $1"
  else
    print -u2 'No clipboard tool (install wl-clipboard or xclip)'; return 1
  fi
}


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
# fcd() {
#   local dir
#   dir=$(find . -type d 2>/dev/null | fzf --preview 'tree -C {} | head -200' --preview-window 'up:60%')
#   [[ -n $dir ]] && builtin cd -- "$dir"
# }

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
    sudo zypper ref && sudo zypper dup || return
    print '\n--- services using old files ---'
    sudo zypper ps -s
    zypper needs-rebooting 2>/dev/null
  elif (( $+commands[pacman] )); then
    sudo pacman -Syu
  fi
  (( $+commands[flatpak] )) && flatpak update
}


# ---------------------------------------------------------------------------
# mkdir + cd
# ---------------------------------------------------------------------------
mk() {
  [[ -n $1 ]] || { print -u2 'Usage: mk <dir> [more dirs]'; return 1; }
  command mkdir -p -- "$@" && builtin cd -- "$1"
}


# ---------------------------------------------------------------------------
# Daily file: 2026-01-15_notes.md
# ---------------------------------------------------------------------------
daily_file() {
  local name="$(date -I)_${1:-notes}.${2:-md}"
  touch -- "$name" && "${EDITOR:-vim}" -- "$name"
}


# ---------------------------------------------------------------------------
# Local + external IP
# ---------------------------------------------------------------------------
myip() {
  command ip -4 -o addr show scope global | awk '{print $2": "$4}'
  print -n 'External: '
  curl -fsS --max-time 5 ifconfig.me || print -u2 '(lookup failed)'
  print
}


# ---------------------------------------------------------------------------
# cheat.sh lookup
# ---------------------------------------------------------------------------
ch() {
  [[ -z $1 ]] && { print -u2 'No command to look up'; return 1; }
  local topic=$1
  [[ -n $2 ]] && topic="$path/$2"
  curl "https://cht.sh/$topic"
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
  [[ -e $key ]] && { print -u2 "$key already exists"; return 1; }
  command mkdir -p -m 700 -- "$HOME/.ssh"
  ssh-keygen -f "$key" -t ed25519 -C "$1" || return
  chmod 600 "$key"
  [[ -f "$key.pub" ]] && chmod 644 "$key.pub"
}

# ---------------------------------------------------------------------------
# History statistics  (usage: historystat [N])
# ---------------------------------------------------------------------------
historystat() {
  fc -l 1 | awk '{print $2}' | sort | uniq -c | sort -rn | head -n "${1:-10}"
}
top10() { historystat 10; }

# ---------------------------------------------------------------------------
# Mount / umount
# ---------------------------------------------------------------------------
mnt() {
  [[ -z $1 ]] && { print -u2 'Usage: mnt <device> [mountpoint]'; print -u2 'Hint: lsblk'; return 1; }
  local target=${2:-/mnt/external}
  sudo mount "$1" "$target" -o rw && print "Mounted $1 at $target"
}

# umnt [dir]: unmount everything at or below dir (default /mnt), deepest first
umnt() {
  local dir=${1:-/mnt}
  local -a mounted
  mounted=(${(f)"$(findmnt -rno TARGET 2>/dev/null | awk -v d="$dir" '$0 == d || index($0, d "/") == 1' | sort -r)"})
  (( $#mounted )) || { print -u2 "Nothing mounted under $dir"; return 1; }
  sudo umount "${mounted[@]}" && print -l -- 'Unmounted:' "${mounted[@]}"
}


# ---------------------------------------------------------------------------
# Random password — uses /dev/urandom (never blocks)
# ---------------------------------------------------------------------------
genpass() {
  local size=${1:-20}
  LC_ALL=C tr -dc '[:graph:]' < /dev/urandom | head -c "$size"
  print
}

# ---------------------------------------------------------------------------
# Disk usage, human sort
# ---------------------------------------------------------------------------
du1() { command du -h --max-depth=1 "$@" | sort -k1,1hr -k2,2f; }
du2() { command du -h --max-depth=1 "$@" | sort -k1,1h  -k2,2f; }


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
  local out
  out=$(print -rn -- "$1" | base64 -w0)
  print -r -- "$out"
  print -rn -- "$out" | _clip && print -u2 'Copied to clipboard.'
}

b64d() {
  local out
  out=$(print -rn -- "$1" | base64 --decode)
  print -r -- "$out"
  print -rn -- "$out" | _clip && print -u2 'Copied to clipboard.'
}


# ---------------------------------------------------------------------------
# History grep
# ---------------------------------------------------------------------------
hgrep() {
  fc -l 1 | command grep -i --color=auto "$@" | fzf
}

# # ---------------------------------------------------------------------------
# # Top 10 most-used commands
# # ---------------------------------------------------------------------------
# top10() {
#   fc -l 1 | awk '{print $2}' | sort | uniq -c | sort -rn | head
# }

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
# cleanup() {
  # [[ -z $1 ]] && { print -u2 'Usage: cleanup <ext>'; return 1; }
  # find . -type f -name "*.$1" -print -delete
# }
cleanup() {
  [[ -z $1 ]] && { print -u2 'Usage: cleanup <ext>'; return 1; }
  [[ $1 == *[/*?]* ]] && { print -u2 'Give a plain extension (e.g. "log"), no wildcards'; return 1; }
  local -a files
  files=(${(f)"$(find . -type f -name "*.$1")"})
  (( $#files )) || { print "No *.$1 files below $PWD"; return 0; }
  print -l -- "${files[@]}"
  read -q "?Delete these $#files file(s)? [y/N] " || { print; return 1; }
  print
  command rm -f -- "${files[@]}"
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


# ---------------------------------------------------------------------------
# Small extras
# ---------------------------------------------------------------------------
# serve [port]: static file server for the current directory
serve() {
  python3 -m http.server "${1:-8000}"
}

# gclone <url> [dir]: git clone and cd into it
gclone() {
  [[ -n $1 ]] || { print -u2 'Usage: gclone <url> [dir]'; return 1; }
  git clone "$@" || return
  builtin cd -- "${2:-${${1:t}%.git}}"
}

# trash <files...>: move to the desktop trash instead of deleting
trash() {
  (( $# )) || { print -u2 'Usage: trash <file...>'; return 1; }
  if (( $+commands[gio] )); then
    gio trash -- "$@"
  elif (( $+commands[trash-put] )); then
    trash-put -- "$@"
  else
    print -u2 'Need gio (glib2-tools) or trash-cli'; return 1
  fi
}

# weather [city]: one-screen forecast
weather() {
  curl -fsS --max-time 8 "https://wttr.in/${1:-}?m" || print -u2 'weather: lookup failed'
}


# zshbench: how long does an interactive shell take to start?
zshbench() {
  if (( $+commands[hyperfine] )); then
    hyperfine --warmup 2 'zsh -i -c exit'
    print 'Note: deferred plugins (autosuggestions, highlighting) load after the first prompt,'
    print 'so this measures time-to-prompt. Use ZSH_DEFER=0 zsh -i -c exit for the full cost.'
  else
    time (for n in {1..10}; do zsh -i -c exit; done)
    print 'total for 10 starts (divide by 10)'
  fi
}

# zsh-plugins <install|update|list>: manage the plugins in ~/.local/share/zsh/plugins
#   install  clone what's missing (shallow)      update  fast-forward everything
#   list     show what is installed and its commit
# (`update` = shallow fetch + hard reset to the remote HEAD: same result as `git pull`,
#  but it can't fail on a force-pushed or diverged shallow clone. Plugins are never edited here.)
zsh-plugins() {
  emulate -L zsh
  local action=${1:-help} root="$XDG_DATA_HOME/zsh/plugins" repo name dest before after
  local changed=0
  [[ $action == (install|update|list) ]] || { print 'Usage: zsh-plugins <install|update|list>'; return 1; }
  (( $+commands[git] )) || { print -u2 'zsh-plugins: git is required'; return 1; }
  command mkdir -p -- "$root"

  for repo in "${_plugin_repos[@]}"; do
    name=${repo:t}
    dest=$root/$name
    # only the highlighter you actually use (ZSH_HIGHLIGHTER, see 95-highlight.zsh)
    [[ $name == (fast|zsh)-syntax-highlighting && $name != ${ZSH_HIGHLIGHTER:-fast-syntax-highlighting} ]] && continue

    case $action in
      install)
        if [[ -d $dest/.git ]]; then
          print "  ✓ $name (already installed)"
        else
          print "  ↓ $name"
          git clone --depth 1 --quiet "https://github.com/$repo.git" "$dest" || print -u2 "  ✗ $name: clone failed"
        fi ;;
      update)
        if [[ -d $dest/.git ]]; then
          before=$(git -C "$dest" rev-parse --short HEAD)
          if git -C "$dest" fetch --depth 1 --quiet origin HEAD && git -C "$dest" reset --hard --quiet FETCH_HEAD; then
            after=$(git -C "$dest" rev-parse --short HEAD)
            if [[ $before == $after ]]; then
              print "  ✓ $name (up to date)"
            else
              print "  ↑ $name  $before → $after"
              changed=1
            fi
          else
            print -u2 "  ✗ $name: update failed (network?)"
          fi
        else
          print "  - $name (not installed — run: zsh-plugins install)"
        fi ;;
      list)
        if [[ -d $dest/.git ]]; then
          print "  ✓ $name  $(git -C "$dest" log -1 --format='%h  %cs')"
        else
          print "  - $name (missing)"
        fi ;;
    esac
  done

  [[ $action == install ]] && print 'Done. Open a new shell to load them.'
  (( changed )) && print 'Updated. Open a new shell (and run zsh-clean if completions changed).'
  return 0
}

# zsh-clean: delete generated caches (init scripts, generated completions, compdump,
# beet command list) and compiled .zwc files
zsh-clean() {
  local -a f
  f=("$XDG_CACHE_HOME"/zsh/(init-*|zcompdump*|beet-commands)(N)
     # "$XDG_CACHE_HOME"/zsh/completions/_*(N)
     "$XDG_CACHE_HOME"/zsh/completions/(_*|.scan|.fail-*)(N)
     "$ZDOTDIR"/{.zshrc,modules/*,local/*}.zwc(N))
  (( $#f )) && command rm -f -- "${f[@]}"
  print "Removed $#f generated files. Open a new shell to rebuild them."
}


# ---------------------------------------------------------------------------
# Completion for the functions above
# ---------------------------------------------------------------------------
if (( $+functions[compdef] )); then
  compdef _files decompress compress make-bak
  compdef _directories mk fzfcd fcd
  compdef _command_names is_installed
  _zsh_plugins() { _arguments '1:action:(install update list)'; }
  compdef _zsh_plugins zsh-plugins
  compdef _files cfile
  compdef _files cpath
fi
