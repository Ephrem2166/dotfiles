# 99-beet-override.zsh — fix `beet import <TAB>` directory completion.
# Everything except `import` uses the official _beet script (comprehensive).
# This file runs LAST (via local/*.zsh loop in .zshrc), after compinit has
# autoloaded _beet, so compdef replaces only the import subcommand.

_beet_import_complete() {
  _arguments -s \
    '(-C --donotcopy)'{-C,--donotcopy}'[do not copy]' \
    '(-c --copy)'{-c,--copy}'[copy]' \
    '(-A --noautotag)'{-A,--noautotag}'[do not autotag]' \
    '(-a --autotag)'{-a,--autotag}'[autotag]' \
    '(-P --noprompt)'{-P,--noprompt}'[do not prompt]' \
    '(-p --prompt)'{-p,--prompt}'[prompt]' \
    '(-q --quiet)'{-q,--quiet}'[quiet]' \
    '(-s --singleton)'{-s,--singleton}'[singleton]' \
    '(-t --timid)'{-t,--timid}'[timid]' \
    '(-L --library)'{-L,--library}'[library query]:query: ' \
    '(-i --incremental)'{-i,--incremental}'[skip already-imported]' \
    '(-I --noincremental)'{-I,--noincremental}'[do not skip]' \
    '--flat[flat tree]' \
    '(-g --group-albums)'{-g,--group-albums}'[group albums]' \
    '*:directory:_directories'
}

compdef _beet_import_complete beet import
EOF
