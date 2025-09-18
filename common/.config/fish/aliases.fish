###############
#### alias ####
###############
# System
alias shutdown='sudo shutdown -h now'
alias restart='sudo reboot'

# Exit and Clear
alias c='clear'
alias q='exit'

# Productive defaults for grep and tree
alias grep='grep --color=auto --exclude-dir=.git'
alias tree='tree -F --dirsfirst -a -I ".git|.hg|.svn|__pycache__|.mypy_cache|.pytest_cache|*.egg-info|.sass-cache|.DS_Store"'
alias tree2='tree -L 2'
alias tree3='tree -L 3'

# Easier directory navigation
alias ..='cd ..'
alias ...='cd ../../'
alias ....='cd ../../../'
alias .....='cd ../../../../'
# Jump to previous directory with --
#alias -- -="cd -"
alias mkdir="mkdir -pv" # Create parent directories if needed
alias rm="rm -i" # Prompt before removing files
alias reload="source ~/.config/fish/config.fish" # Reload shell configuration
alias now="date '+%Y-%m-%d %H:%M:%S'" # Show current date and time
alias mv="mv -iv" # Interactive and verbose move
alias cp="cp -iv" # Interactive and verbose copy
# System Information
alias osinfo="cat /etc/os-release" # Display OS information
alias uptime="uptime" # Display system uptime in human-readable format
alias whoami="echo $USER" # Show the current user
alias whoip="hostname -I" # Show local IP address
alias lsb="lsb_release -a" # Detailed distro information
alias hwinfo="lshw -short" # Summarized hardware info

# Date and time
alias today="date '+%Y-%m-%d'" # Current date
alias now="date '+%Y-%m-%d %H:%M:%S'" # Current date and time
alias cal="cal -3" # Current, previous, and next month calendars

# Fonts
alias fontcache='fc-cache -f -v'
alias fontfind='fc-list : family style'

# vim and emacs
alias vim="nvim"
#alias emacs="emacsclient -c -a 'emacs'"                                               # GUI versions of Emacs
#alias em="/usr/bin/emacs -nw"                                                         # Terminal version of Emacs
#alias rem="killall emacs || echo 'Emacs server not running'; /usr/bin/emacs --daemon" # Kill Emacs and restart daemon..

# adding flags
alias df='df -h' # human-readable sizes
alias free='free -m' # show sizes in MB
alias grep='grep --color=auto' # colorize output (good for log files)

# ps
alias psa="ps auxf"
alias psgrep="ps aux | grep -v grep | grep -i -e VSZ -e"
alias psmem='ps auxf | sort -nr -k 4'
alias pscpu='ps auxf | sort -nr -k 3'

# Changing "ls" to "eza"
alias ls='eza --all --icons=always --color=always --group-directories-first'
alias lt='eza --all --tree --color-scale --level=2 --icons=always --color=always --group-directories-first'
alias ll='eza -al --no-time --no-user --no-permissions --no-filesize --icons=always --color=always --group-directories-first'
alias la='eza -alh --git --icons=always --color=always --group-directories-first'

# Replace cat with bat
alias cat='bat'

# Replace grep with ripgrep
alias grep='rg'

# Archive management
alias untar="tar -xvf" # Extract tarballs
alias targz="tar -czvf" # Compress to tar.gz
alias unzip="unzip" # Extract zip files
alias untarxz="tar -xvJf" # Extract .tar.xz

# System Journal
alias loger='journalctl -p 3 -xb'
alias logf='journalctl -f'
alias logr='sudo journalctl --rotate'
alias logs='journalctl --disk-usage'
alias logv='journalctl --verify'
alias logw='sudo journalctl --vacuum-time=1s'
