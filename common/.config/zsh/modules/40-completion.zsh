# 40-completion.zsh — the ONE place compinit and completion styles are configured.
# Order inside this file matters:
#   1. dumpfile setup
#   2. compinit
#   3. zstyle declarations
#   4. _comp_options
#   5. fzf-tab (must be sourced AFTER compinit)

# --- Dumpfile cache ---
# Rebuild the completion cache once per day; use the fast path otherwise.
# `(#qN.mh+24)` = "files whose mtime is more than 24 hours older than now".
# If that matches, we rebuild; if not, `-C` skips the security check (fast path).
export ZSH_COMPDUMP="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump-${ZSH_VERSION}"
[[ -d ${ZSH_COMPDUMP:h} ]] || mkdir -p ${ZSH_COMPDUMP:h}

autoload -Uz compinit
if [[ -n ${ZSH_COMPDUMP}(#qN.mh+24) ]]; then
  compinit -d "$ZSH_COMPDUMP"
else
  compinit -C -d "$ZSH_COMPDUMP"
fi

# --- General ---
zstyle ':completion:*' completer _complete _correct _approximate
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompcache"
zstyle ':completion:*' menu select
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' file-list all
zstyle ':completion:*' force-list always
zstyle ':completion:*:killall:*' force-list always
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*' file-sort name
zstyle ':completion:*' verbose yes
zstyle ':completion:*' list-dirs-first true
zstyle ':completion:*' group-name ''
zstyle ':completion:*:approximate:::' max-errors 1 numeric

# --- Grouping ---
zstyle ':completion:*:*:-tilde-:*:*' group-order named-directories users
zstyle ':completion:*:*:-command-:*:*' group-order alias functions builtins commands

# --- Matcher list: exact prefix -> case-insensitive prefix -> case-insensitive substring ---
# Spec 1: exact prefix match (fast, precise — wins when it can).
# Spec 2: case-insensitive prefix match.
# Spec 3: case-insensitive substring match (fish-style — "deep" matches "How Deep is the Ocean").
# zsh tries each spec in order and uses the FIRST one that produces matches.
zstyle ':completion:*' matcher-list \
  '' \
  'm:{a-zA-Z}={A-Za-z}' \
  'm:{a-zA-Z}={A-Za-z} l:|=* r:|=*'

# --- kill completion ---
zstyle ':completion:*:*:kill:*:*' command 'ps xf -U $USER -o pid,%cpu,cmd'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;32'

# --- Colors (reuse LS_COLORS) ---
if [[ -n ${LS_COLORS:-} ]]; then
  zstyle ':completion:*:*:*:*:default' list-colors ${(s.:.)LS_COLORS}
fi

# --- cd completion ---
zstyle ':completion:*:*:cd:*' tag-order local-directories directory-stack path-directories
zstyle ':completion:*:*:cd:*' ignore-parents parent pwd
zstyle ':completion:*:*:cd:*' ignored-patterns '(*/)#lost+found'

# --- Ignore internal completion functions in their own listings ---
zstyle ':completion:*:functions' ignored-patterns '(_*|pre(cmd|exec))'
zstyle ':completion:*:(functions|parameters)' ignored-patterns '(_*|.*|-*|+*|pre(cmd|exec))'

# --- Common commands: faster, more relevant results ---
zstyle ':completion:*:*:(cd|ls|rm|cp|mv):*' ignore-parents parent pwd
zstyle ':completion:*:*:(cd|ls|rm|cp|mv):*' file-sort name
zstyle ':completion:*:*:(cd|ls|rm|cp|mv):*' group-order named-directories path-directories users
zstyle ':completion:*:*:(rm|kill|diff):*' ignore-line yes
zstyle ':completion:*:*:(scp|rsync):*' file-list false

# --- git user-commands (completes `git <tab>` with installed git-* helpers) ---
zstyle ':completion:*:*:git:*' user-commands ${${(M)${(k)commands}:#git-*}/git-/}

# --- Man pages ---
zstyle ':completion:*:manuals' separate-sections true
zstyle ':completion:*:manuals.(^1*)' insert-sections true

# --- Format strings ---
zstyle ':completion:*:descriptions' format "[%d]"
zstyle ':completion:*:messages'     format "- %d -"
zstyle ':completion:*:corrections'  format "- %d - (errors %e)"
zstyle ':completion:*:default'      select-prompt "Match %m  Line %l  %p"
zstyle ':completion:*:default'      list-prompt "Line %l  Continue?"
zstyle ':completion:*:warnings'     format "- no match - %d"

# --- History words (used by `_history_complete_word`, bound via `.`) ---
zstyle ':completion:*:history-words' stop yes
zstyle ':completion:*:history-words' remove-all-dups yes
zstyle ':completion:*:history-words' list false
zstyle ':completion:*:history-words' menu yes


# --- Tab support for sudo
zstyle ':completion:*:sudo:*' command-path \
  /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin

# --- Include dotfiles in completion only ---
# This is the SAFE alternative to `setopt GLOB_DOTS` (which we left off in
# 10-options.zsh). It only affects Tab completion, not `rm *`.
_comp_options+=(globdots)

# --- fzf-tab: MUST be sourced AFTER compinit ---
_plugin_dir="${XDG_DATA_HOME:-$HOME/.local/share}/zsh/plugins"
if [[ -r "$_plugin_dir/fzf-tab/fzf-tab.plugin.zsh" ]]; then
  source "$_plugin_dir/fzf-tab/fzf-tab.plugin.zsh"

  # --- Preview windows ---
  zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza -1 --color=always $realpath'
  zstyle ':fzf-tab:complete:cd:*'         fzf-preview 'eza -1 --color=always $realpath'
  zstyle ':fzf-tab:complete:vim:*'        fzf-preview 'bat --color=always $realpath'
  zstyle ':fzf-tab:complete:(-command-|-parameter-|-brace-parameter-|export|unset|expand):*' \
    fzf-preview 'echo ${(P)word}'
  zstyle ':fzf-tab:complete:systemctl-*:*' fzf-preview 'SYSTEMD_COLORS=1 systemctl status $word'

  # --- Process previews for kill / ps ---
  zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"
  zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-preview \
    '[[ $group == "[process ID]" ]] && ps --pid=$word -o cmd --no-headers -w -w'
  zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-flags --preview-window=down:3:wrap

  # --- Keybindings inside fzf-tab ---
  zstyle ':fzf-tab:*' fzf-bindings 'space:accept' 'ctrl-j:accept' 'ctrl-a:toggle-all'
  zstyle ':fzf-tab:*' fzf-min-height 20
  zstyle ':fzf-tab:*' switch-group '<' '>'
fi
unset _plugin_dir
