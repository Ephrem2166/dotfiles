# Check https://github.com/trapd00r/configs/blob/master/zsh/zshrc
# Command completion
# Use `compinstall` for interactive configuration
autoload -Uz compinit
compinit

# General Setting
# Syntax for zstyle; `zstyle <pattern> <style> <values>`
# Syntax for completion: `:completion:<function>:<completer>:<command>:<argument>:<tag>`
# Define completers
zstyle ':completion:*' completer _complete _correct _approximate _extensions

# Use cache for commands
zstyle ':completion:*' use-cache on

# Menu Select
zstyle ':completion:*' menu select auto

zstyle ':completion:*' accept-ezact '*(N)'

# Detailed file listing
zstyle ':completion:*' file-list all



# Grouping
# For all completions: grouping the output
zstyle ':completion:*' group-name ''
# dirs: reorder output sorting: named dirs over userdirs
zstyle ':completion::*:-tilde-:*:*' group-order named-directories users
zstyle ':completion:*:*:-command-:*:*' group-order alias functions builtins commands

# Case insensitive completion
# zstyle ':completion:*' m# Only display some tags for the command cd
zstyle ':completion:*:*:cd:*' tag-order local-directories directory-stack path-directorieeatcher-list 'm:{a-zA-Z}={A-Za-z}'
# Case insensitive and partial completion
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'


# statusline for many hits
zstyle ':completion:*:default' select-prompt $'\e[01;35m -- Match %M    %P -- \e[00;00m'

# Enable verbose completion
zstyle ':completion:*' verbose yes

# The default directories to be completed are listed separately from and before completion for other files.
zstyle ':completion:*' list-dirs-first true

# kill: advanced kill completion
zstyle ':completion::*:kill:*:*' command 'ps xf -U $USER -o pid,%cpu,cmd'
zstyle ':completion::*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;32'


zstyle  ':completion:*' complete true


# STYLE
# Colors for files and directory
zstyle ':completion:*:*:*:*:default' list-colors ${(s.:.)LS_COLORS}
# For all completions: color
# zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# #zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
# zstyle ':completion:*:*:kill:*' list-colors '=(#b) #([0-9]#)*( *[a-z])*=34=31=33'
# zstyle ':completion:' cache-path "$HOME/.cache/zsh/.zcompcache"
# zstyle ':completion:*:parameters' list-colors '=*=1;35'
# zstyle ':completion:*:builtins' list-colors '=*=1;34'
# zstyle ':completion:*:aliases' list-colors '=*=1;33'
# zstyle ':completion:*:options' list-colors '=^(-- *)=34'

# Others
# Allows // to be expanded as /
zstyle ':completion:*' squeeze-slashes true

# Autocomplete CD instead of showing a directory stack
zstyle ':completion:*' complete-options true
# Sorting matched files
# Values: dummyvalue (alphabetically), size, links, modification, access, change or inode
zstyle ':completion:*' file-sort dummyvalue

# Only display some tags for the command cd
zstyle ':completion:*:*:cd:*' tag-order local-directories directory-stack path-directories

# Disable completion for commands we don't use
zstyle ':completion:*:functions' ignored-patterns '(_*|pre(cmd|exec))'
zstyle ':completion:*:cd:*' ignored-patterns '(*/)#lost+found'

# Optimize completion for specific commands
zstyle ':completion:*:*:(cd|ls|rm|cp|mv):*' ignore-parents parent pwd
zstyle ':completion:*:*:(cd|ls|rm|cp|mv):*' file-sort name
zstyle ':completion:*:*:(cd|ls|rm|cp|mv):*' group-order 'named-directories path-directories users'


# Disable completion for commands that don't need it
zstyle ':completion:*:*:(rm|kill|diff):*' ignore-line yes
zstyle ':completion:*:*:(scp|rsync):*' file-list false


# Optimize completion for git
zstyle ':completion:*:*:git:*' user-commands ${${(M)${(k)commands}:#git-*}/git-/}

# If there is only one candidate just insert it.
zstyle ':autocomplete:*complete*:*' insert-unambiguous yes

# Format
# zstyle ':completion:*:*:*:*:descriptions' format '%F{green}%d %f'
# zstyle ':completion:*:*:*:*:corrections' format '%F{yellow}!- %d (errors: %e) -!%f'
# zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
# zstyle ':completion:*:warnings' format ' %F{red}no matches found %f'
# zstyle ':completion:*:default' list-prompt '%S%M matches%s'

zstyle ':completion:*:descriptions' format "- %d -"
zstyle ':completion:*:messages'     format "- %d -"
zstyle ':completion:*:corrections'  format "- %d - (errors %e)"
zstyle ':completion:*:default'      select-prompt "Match %m  Line %l  %p"
zstyle ':completion:*:default'      list-prompt "Line %l  Continue?"
zstyle ':completion:*:warnings'     format "- no match - %d"

# Fzf-tab
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'
# preview directory's content with eza when completing cd and ls
# zstyle ':fzf-tab:complete:*:*' fzf-preview 'file $realpath | sed -E "s/^.+: //"; hr -fg 137 -c _ -s 30;echo;eza -1 --color=always $realpath ;'
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:complete:vim:*' fzf-preview 'bat --color=always $realpath'
# environment variables
zstyle ':fzf-tab:complete:(-command-|-parameter-|-brace-parameter-|export|unset|expand):*' \
  fzf-preview 'echo ${(P)word}'

# preview systemctl status
zstyle ':fzf-tab:complete:systemctl-*:*' fzf-preview 'SYSTEMD_COLORS=1 systemctl status $word'

# give a preview of commandline arguments when completing kill
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"
zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-preview \
  '[[ $group == "[process ID]" ]] && ps --pid=$word -o cmd --no-headers -w -w'
zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-flags --preview-window=down:3:wrap

# accept with one key
zstyle ':fzf-tab:*' fzf-bindings 'space:accept'
#zstyle ':fzf-tab:*' fzf-bindings 'ctrl-j:accept' 'ctrl-a:toggle-all'
zstyle ':fzf-tab:*' fzf-bindings 'ctrl-a:toggle-all'
zstyle ':fzf-tab:*' fzf-min-height 100
