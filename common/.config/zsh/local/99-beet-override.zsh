# 99-beet-override.zsh — everything beets-related, in one place.
#
#   1. completion : `beet import <TAB>` completes directories; everything else
#                   (subcommands, fields, other options) stays with the official _beet
#   2. bif        : fuzzy-pick directories and import them
#   3. bls        : fuzzy-pick albums and run any beet subcommand on exactly those
#   4. bsoundtrack: set category/series on an album and move its files
#
# INSTALL: keep this file in ~/.config/zsh/local/ — .zshrc sources local/*.zsh after all
# modules (so after compinit) and before the syntax highlighter. If you prefer it in
# modules/, add `99-beet-override` to the module list in .zshrc instead (after 92-prompt).
# The fpath entry for ~/.config/beets (where your official `_beet` lives) is added in
# 00-env.zsh because fpath must be set before compinit.
#
# Things the previous version got wrong (all fixed below):
#   - `compdef fn beet import` registers fn for TWO COMMANDS ("beet" and "import"), so
#     it replaced all beet completion. We now register ONE wrapper for `beet`.
#   - The hand-written import option list had flags beets doesn't have (--donotcopy,
#     --prompt, --noprompt; real: --nocopy, --resume/--noresume) and lacked -m/-w/-W/-l/
#     --set/-S. We no longer maintain a list: options come from the official _beet.
#   - bsoundtrack used `category:X` (a QUERY) where `beet modify` needs `category=X`
#     (an ASSIGNMENT), so it never changed anything.
#   - bls built the query from "Artist - Album" text and its preview expanded $album in
#     the shell instead of in beet.

# ===========================================================================
# 1. Completion
# ===========================================================================
(( $+functions[compdef] )) || return 0   # completion system not loaded (non-interactive)

# Make sure the official _beet is available (normally already done by compinit).
if (( ! $+functions[_beet] )) && [[ -r ${XDG_CONFIG_HOME:-$HOME/.config}/beets/_beet ]]; then
  fpath=("${XDG_CONFIG_HOME:-$HOME/.config}/beets" $fpath)
  autoload -Uz _beet
fi

# Delegate to the official completion, or to plain file completion if it's missing.
_beet_delegate() {
  if (( $+functions[_beet] )); then
    _beet "$@"
  else
    _files
  fi
}

_beet_wrapper() {
  local ret=1

  # 1) Find the subcommand: first word after `beet` that isn't an option.
  #    Global options that take a separate argument: -l -d -c -p -P
  local i=2 w
  while (( i < CURRENT )) && [[ $words[i] == -* ]]; do
    case $words[i] in
      -l|-d|-c|-p|-P) (( i += 2 )) ;;
      *)              (( i++ ))    ;;
    esac
  done

  if (( i < CURRENT )) && [[ $words[i] == (import|imp|im) ]]; then
    local cur=$words[CURRENT] prev=$words[CURRENT-1]
    local library_mode=0 singleton_mode=0

    for w in "${(@)words[i+1,CURRENT-1]}"; do
      case $w in
        -L|--library)     library_mode=1 ;;
        -s|--singletons)  singleton_mode=1 ;;
      esac
    done

    if [[ $cur == -* ]]; then
      # completing an option (or --opt=value): the official script knows them all
      _beet_delegate "$@"; ret=$?
    elif [[ $prev == (-l|--logfile|-S|--search-id|--set|--duplicate-action|--quiet-fallback) ]]; then
      # value of an option that takes an argument
      _beet_delegate "$@"; ret=$?
    elif (( library_mode )); then
      # `import -L` re-tags library items: positional words are QUERIES, not paths
      _beet_delegate "$@"; ret=$?
    elif (( singleton_mode )); then
      # singletons can be single audio files as well as directories
      _files; ret=$?
    else
      _directories; ret=$?
    fi
  else
    # every other subcommand (and the subcommand position itself)
    _beet_delegate "$@"; ret=$?
  fi

  # If the official script re-registered itself on first load, take the slot back.
  [[ $_comps[beet] == _beet_wrapper ]] || compdef _beet_wrapper beet
  return $ret
}

compdef _beet_wrapper beet

# fzf-tab: show the directory contents next to each candidate
zstyle ':fzf-tab:complete:beet:*' fzf-preview \
  '[[ -d $realpath ]] && '"${_fzf_tree:-ls -1 --color=always}"' $realpath'

# ===========================================================================
# 2. bif — fuzzy-pick directories (TAB multi-selects) and import them
#    usage: bif [root-dir] [beet import options...]
#    e.g.   bif ~/Downloads -q
# ===========================================================================
bif() {
  (( $+commands[beet] && $+commands[fzf] )) || { print -u2 'bif needs beet and fzf'; return 1; }
  local root=.
  if [[ -n $1 && $1 != -* ]]; then
    root=$1
    shift
  fi
  [[ -d $root ]] || { print -u2 "bif: '$root' is not a directory"; return 1; }

  local -a dirs
  if (( $+commands[fd] )); then
    dirs=(${(f)"$(fd --type d --hidden --exclude .git --exclude node_modules . "$root" 2>/dev/null \
      | fzf -m --prompt='Import to beet> ' --header='TAB: multi-select' \
            --preview "${_fzf_tree:-ls -1 --color=always} {}")"})
  else
    dirs=(${(f)"$(find "$root" \( -name .git -o -name node_modules \) -prune -o -type d -print 2>/dev/null \
      | fzf -m --prompt='Import to beet> ' --header='TAB: multi-select' \
            --preview "${_fzf_tree:-ls -1 --color=always} {}")"})
  fi
  (( $#dirs )) || return 0
  beet import "$@" -- "${dirs[@]}"
}

compdef _directories bif

# ===========================================================================
# 3. bls — fuzzy-pick albums (TAB multi-selects), run a beet subcommand on them
#    usage: bls <subcommand> [args...]
#    e.g.   bls ls            bls ls -a        bls modify genre=Rock
#           bls move          bls info         bls remove
#    The selection is turned into EXACT queries (regex ^...$ on albumartist and
#    album; several albums are OR-ed with a `,` argument), so `bls remove` can't hit
#    "Greatest Hits" by someone else. Beet itself still asks before modify/remove/move.
# ===========================================================================
bls() {
  emulate -L zsh
  setopt extended_glob
  (( $+commands[beet] && $+commands[fzf] )) || { print -u2 'bls needs beet and fzf'; return 1; }
  (( $# )) || { print -u2 'Usage: bls <beet-subcommand> [args...]   e.g. bls ls | bls modify genre=Rock'; return 1; }

  local -a rows terms
  local row rest artist album esc_artist esc_album

  # Tab-separated so artists/albums that contain " - " stay unambiguous.
  rows=(${(f)"$(beet ls -a -f $'$albumartist\t$album\t$year' 2>/dev/null | sort -u \
    | fzf -m --delimiter=$'\t' --prompt='Select album(s)> ' \
          --header='TAB: multi-select · ENTER: confirm' \
          --preview 'beet ls -f "\$track. \$title" albumartist:{1} album:{2}')"})
  (( $#rows )) || return 0

  for row in "${rows[@]}"; do
    artist=${row%%$'\t'*}
    rest=${row#*$'\t'}
    album=${rest%%$'\t'*}
    # escape regex metacharacters: backslash before every char that is not
    # a letter, digit, underscore or space
    esc_artist=${artist//(#m)[^[:alnum:]_ ]/\\$MATCH}
    esc_album=${album//(#m)[^[:alnum:]_ ]/\\$MATCH}
    (( $#terms )) && terms+=(,)           # `,` = OR between albums
    terms+=("albumartist::^${esc_artist}\$" "album::^${esc_album}\$")
  done

  beet "$1" "${(@)argv[2,-1]}" "${terms[@]}"
}

# ===========================================================================
# 4. bsoundtrack — tag an album with category + series, then move its files
#    usage: bsoundtrack "Album Name" Games "GTA"
#    (`field=value` = assignment, `field:value` = query. Beet asks to confirm.)
# ===========================================================================
bsoundtrack() {
  (( $+commands[beet] )) || { print -u2 'bsoundtrack needs beet'; return 1; }
  (( $# == 3 )) || { print -u2 'Usage: bsoundtrack "Album Name" <category> <series>'; return 1; }
  beet modify "album:$1" "category=$2" "series=$3" && beet move "album:$1"
}
