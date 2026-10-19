# Check https://github.com/trapd00r/configs/blob/master/zsh/zshrc
# Command completion
setopt extended_glob

autoload -Uz compinit
compinit

zmodload -i zsh/complist

# General settings
zstyle ':completion:*' completer _complete _correct _approximate
zstyle ':completion:*' use-cache on
zstyle ':completion:*' menu select
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' file-list all
zstyle ':completion:*' force-list always
zstyle ':completion:*:killall:*' force-list always

# Grouping
zstyle ':completion:*' group-name ''
zstyle ':completion:*:*:-tilde-:*:*' group-order named-directories users
zstyle ':completion:*:*:-command-:*:*' group-order alias functions builtins commands

# Case-insensitive and partial matching
zstyle ':completion:*' matcher-list \
  'm:{a-zA-Z}={A-Za-z}' \
  'r:|=*' \
  'l:|=* r:|=*'

zstyle ':completion:*' verbose yes
zstyle ':completion:*' list-dirs-first true

# kill completion
zstyle ':completion:*:*:kill:*:*' command 'ps xf -U $USER -o pid,%cpu,cmd'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;32'

# Colors
if [[ -n ${LS_COLORS:-} ]]; then
  zstyle ':completion:*:*:*:*:default' list-colors ${(s.:.)LS_COLORS}
fi

# Others
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*' file-sort name

# cd tag order
zstyle ':completion:*:*:cd:*' tag-order local-directories directory-stack path-directories

# Ignore noisy completions
zstyle ':completion:*:functions' ignored-patterns '(_*|pre(cmd|exec))'
zstyle ':completion:*:(functions|parameters)' ignored-patterns '(_*|.*|-*|+*|autosuggest-*|pre(cmd|exec))'
zstyle ':completion:*:*:cd:*' ignored-patterns '(*/)#lost+found'

# Optimize common commands
zstyle ':completion:*:*:(cd|ls|rm|cp|mv):*' ignore-parents parent pwd
zstyle ':completion:*:*:(cd|ls|rm|cp|mv):*' file-sort name
zstyle ':completion:*:*:(cd|ls|rm|cp|mv):*' group-order named-directories path-directories users

zstyle ':completion:*:*:(rm|kill|diff):*' ignore-line yes
zstyle ':completion:*:*:(scp|rsync):*' file-list false
zstyle ':completion:*:*:cd:*' ignore-parents parent pwd

# git user commands
zstyle ':completion:*:*:git:*' user-commands ${${(M)${(k)commands}:#git-*}/git-/}

# zsh-autocomplete
zstyle ':autocomplete:*complete*:*' insert-unambiguous yes

# Man pages
zstyle ':completion:*:manuals' separate-sections true
zstyle ':completion:*:manuals.(^1*)' insert-sections true

# Formatting
zstyle ':completion:*:descriptions' format "[%d]"
zstyle ':completion:*:messages' format "- %d -"
zstyle ':completion:*:corrections' format "- %d - (errors %e)"
zstyle ':completion:*:default' select-prompt "Match %m  Line %l  %p"
zstyle ':completion:*:default' list-prompt "Line %l  Continue?"
zstyle ':completion:*:warnings' format "- no match - %d"

# History words
zstyle ':completion:*:history-words' stop yes
zstyle ':completion:*:history-words' remove-all-dups yes
zstyle ':completion:*:history-words' list false
zstyle ':completion:*:history-words' menu yes

# fzf-tab previews
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:complete:vim:*' fzf-preview 'bat --color=always $realpath'

zstyle ':fzf-tab:complete:(-command-|-parameter-|-brace-parameter-|export|unset|expand):*' \
  fzf-preview 'echo ${(P)word}'

zstyle ':fzf-tab:complete:systemctl-*:*' fzf-preview 'SYSTEMD_COLORS=1 systemctl status $word'

zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"
zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-preview \
  '[[ $group == "[process ID]" ]] && ps --pid=$word -o cmd --no-headers -w -w'
zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-flags --preview-window=down:3:wrap

# fzf-tab bindings
zstyle ':fzf-tab:*' fzf-bindings 'space:accept' 'ctrl-j:accept' 'ctrl-a:toggle-all'
zstyle ':fzf-tab:*' fzf-min-height 100
zstyle ':fzf-tab:*' switch-group '<' '>'

# Set dumpfile location
export ZSH_COMPDUMP="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump-${ZSH_VERSION}"

# Create cache directory if needed
[[ -d ${ZSH_COMPDUMP:h} ]] || mkdir -p ${ZSH_COMPDUMP:h}

# Only rebuild cache once per day; otherwise use -C (fast path)
if [[ -n ${ZSH_COMPDUMP}(#qN.mh+24) ]]; then
	compinit -d "$ZSH_COMPDUMP"
else
	compinit -C -d "$ZSH_COMPDUMP"
fi

# Completion cache path
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompcache"

# Max errors for approximate and correct
zstyle ':completion:*:approximate:::' max-errors 1 numeric

# menuselect
bindkey '^[[Z' reverse-menu-complete

bindkey -M menuselect "^p" backward-char
bindkey -M menuselect "^n" forward-char

bindkey -M menuselect "^h" backward-char
bindkey -M menuselect "^j" down-line-or-history
bindkey -M menuselect "^k" up-line-or-history
bindkey -M menuselect "^l" forward-char

bindkey -M menuselect "^o" accept-and-infer-next-history
