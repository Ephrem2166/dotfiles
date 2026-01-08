# Command completion
# Use `compinstall` for interactive configuration
autoload -Uz compinit
compinit

# TODO Completion Style
# Syntax for zstyle; `zstyle <pattern> <style> <values>`
# Syntax for completion: `:completion:<function>:<completer>:<command>:<argument>:<tag>`
# Define completers
zstyle ':completion:*' menu select=1
# Detailed file listing
zstyle ':completion:*' file-list all

# for all completions: grouping the output
zstyle ':completion:*' group-name ''

# for all completions: color
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# for all completions: selected item
# zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS} ma=0\;47

# Case Insensitivity
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# statusline for many hits
zstyle ':completion:*:default' select-prompt $'\e[01;35m -- Match %M    %P -- \e[00;00m'

# for all completions: show comments when present
zstyle ':completion:*' verbose yes

# The default directories to be completed are listed separately from and before completion for other files.
zstyle ':completion:*' list-dirs-first true

# fault tolerance
zstyle ':completion:*' completer _complete _correct _approximate _extensions

# ~dirs: reorder output sorting: named dirs over userdirs
zstyle ':completion::*:-tilde-:*:*' group-order named-directories users

# kill: advanced kill completion
zstyle ':completion::*:kill:*:*' command 'ps xf -U $USER -o pid,%cpu,cmd'
zstyle ':completion::*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;32'

zstyle ':completion:*' use-cache on

zstyle  ':completion:*' complete true

zstyle ':completion:*' complete-options true
# zstyle ':completion:*:*:kill:*' list-colors '=(#b) #([0-9]#)*( *[a-z])*=34=31=33'
# zstyle ':completion:' cache-path "$HOME/.cache/zsh/.zcompcache"
# zstyle ':completion:*:parameters' list-colors '=*=1;35'
# zstyle ':completion:*:builtins' list-colors '=*=1;34'
# zstyle ':completion:*:aliases' list-colors '=*=1;33'
# #zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
# zstyle ':completion:*:*:*:*:descriptions' format '%F{green}%d %f'
# zstyle ':completion:*:*:*:*:corrections' format '%F{yellow}!- %d (errors: %e) -!%f'
# zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
# zstyle ':completion:*:warnings' format ' %F{red}no matches found %f'
# zstyle ':completion:*:options' list-colors '=^(-- *)=34'
# zstyle ':completion:*:*:-command-:*:*' group-order alias functions builtins commands
# Grouping
# zstyle ':completion:*:*:-command-:*:*' group-order alias builtins functions commands


zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'
