# 60-aliases.zsh — safe aliases only.
# Rules for this file:
#   1. No `for` loops that alias system commands — they cause `sudo sudo …` and override each other.
#   2. No aliases that recurse into themselves (`alias top='top || top'`).
#   3. No aliasing `cd`, `ps`, `grep`, `top`, or `sudo` directly — use functions where args matter.
#   4. Use `command <cmd>` inside compound aliases so shell aliases don't fire recursively.

# ---------------------------------------------------------------------------
# Shell management
# ---------------------------------------------------------------------------
alias reload='exec "$SHELL" -l'
alias c='clear'
alias q='exit'

# ---------------------------------------------------------------------------
# Navigation
# ---------------------------------------------------------------------------
alias -- -='cd -'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# ---------------------------------------------------------------------------
# File operations
# ---------------------------------------------------------------------------
alias mkdir='mkdir -pv'
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -Iv'
alias rsync='rsync -avhP --no-inc-recursive --inplace'
alias less='less -R'

# ---------------------------------------------------------------------------
# Tree
# ---------------------------------------------------------------------------
alias tree='tree -F --dirsfirst -a -I ".git|.hg|.svn|__pycache__|.mypy_cache|.pytest_cache|*.egg-info|.sass-cache|.DS_Store"'
alias tree2='tree -L 2'
alias tree3='tree -L 3'

# ---------------------------------------------------------------------------
# Colorized output
# ---------------------------------------------------------------------------
alias diff='diff --color=auto'
alias ip='ip -color=auto'

# ---------------------------------------------------------------------------
# System info
# ---------------------------------------------------------------------------
alias osinfo='cat /etc/os-release'
alias whoip='hostname -I'
alias lsb='lsblk -o name,size,label'
alias free='free -m'
alias du='du -h'

# ---------------------------------------------------------------------------
# Date and time
# ---------------------------------------------------------------------------
alias today="date '+%Y-%m-%d'"
alias now="date '+%Y-%m-%d %H:%M:%S'"
alias cal='cal -3'

# ---------------------------------------------------------------------------
# Fonts
# ---------------------------------------------------------------------------
alias fonts='fc-cache -f -v'
alias fontfind='fc-list : family style'

# ---------------------------------------------------------------------------
# Editor
# ---------------------------------------------------------------------------
# alias vi='vim -u NONE -N'                # vanilla vim (no config)
# alias vim='nvim'                         # vim = nvim with config
if (( $+commands[vim] )); then
  alias vi='vim -u NONE -N'
elif (( $+commands[nvim] )); then
  alias vi='nvim -u NONE -N'
fi
alias e='emacsclient -nw'
alias ew='emacs'
alias ec='emacsclient --alternate-editor= -nw'

# ---------------------------------------------------------------------------
# Process
# ---------------------------------------------------------------------------
alias psmem='ps auxf | sort -nr -k 4'
alias pscpu='ps auxf | sort -nr -k 3'

# ---------------------------------------------------------------------------
# Archives
# ---------------------------------------------------------------------------
alias untar='tar -xvf'
alias targz='tar -czvf'
alias untarxz='tar -xvJf'

# ---------------------------------------------------------------------------
# Journal
# ---------------------------------------------------------------------------
alias loger='journalctl -p 3 -xb'
alias logf='journalctl -f'
alias logr='sudo journalctl --rotate'
alias logs='journalctl --disk-usage'
alias logv='journalctl --verify'
alias logw='sudo journalctl --vacuum-time=1s'

# ---------------------------------------------------------------------------
# Network
# ---------------------------------------------------------------------------
alias ports='ss -tulanp'
alias listening='lsof -P -i -n'

# ---------------------------------------------------------------------------
# PATH display
# ---------------------------------------------------------------------------
alias path='echo "$PATH" | tr ":" "\n"'

# ---------------------------------------------------------------------------
# yt-dlp
# ---------------------------------------------------------------------------
alias mp3-dl='yt-dlp --ignore-config --extract-audio --audio-format mp3 --audio-quality 0 --embed-thumbnail --embed-metadata -o "$HOME/Downloads/%(title)s.%(ext)s"'

# ---------------------------------------------------------------------------
# Calc
# ---------------------------------------------------------------------------
alias calc='python3 -ic "from math import *; import cmath"'

# ---------------------------------------------------------------------------
# fzf
# ---------------------------------------------------------------------------
if (( $+commands[bat] )); then
  alias ff="fzf --preview 'bat --style=numbers --color=always {}'"
fi
# ---------------------------------------------------------------------------
# System commands
# ---------------------------------------------------------------------------
alias shutdown='sudo shutdown -h now'
alias restart='sudo reboot'
alias caffienate='systemd-inhibit tail -f /dev/null'

# ---------------------------------------------------------------------------
# Conditional replacements
# ---------------------------------------------------------------------------
# These are guarded so the shell still starts if the tool is missing.
# Use functions where argument passthrough matters — aliases break `cmd -flag`.

# bat -> cat (but `command cat` still works)
if (( $+commands[bat] )); then
  alias cat='bat'
fi

# rg -> grep — as a FUNCTION, so `grep -r foo` works correctly
# if (( $+commands[rg] )); then
#   grep() { command rg "$@"; }
# fi

# duf -> df
if (( $+commands[duf] )); then
  alias df='duf'
fi

# eza -> ls
if (( $+commands[eza] )); then
  alias ls='eza -la --group-directories-first --icons'
  alias lsa='eza --group-directories-first --all --icons=always'
  alias ll='eza --group-directories-first --octal-permissions --group --long --git --icons=always'
  alias lla='eza --group-directories-first --long --all --git --icons=always'
  alias lst='eza --long --changed --time-style relative --sort time'
  alias lsl='eza -la --icons --group-directories-first'
fi

# Distro Specific
if (( $+commands[zypper] )); then
  # openSUSE (Leap or Tumbleweed)
  alias pacup='sudo zypper dup'
  alias pacin='sudo zypper in'
  alias pacse='zypper se'
  alias pacrm='sudo zypper rm -u'
  alias pacrepos='sudo zypper lr'
  alias pacref='sudo zypper ref'
  alias pacclean='sudo zypper clean --all'
  alias pacdistup='sudo zypper dup'   # dup = safe upgrade on Tumbleweed
  alias yast2='sudo yast2'
  alias yst='sudo yast2'

elif (( $+commands[pacman] )); then
  # Arch (or Arch derivative)
  alias pacup='sudo pacman -Syu'
  alias pacin='sudo pacman -S'
  alias pacse='pacman -Ss'
  alias pacrm='sudo pacman -Rss'
  alias pacls='pacman -Q'
  alias pacorphans='pacman -Qdt'
  alias pacclean='sudo pacman -Sc'
  alias pacfiles='pacman -Ql'

  # AUR helper — uncomment the one you have
  # if (( $+commands[yay] )); then
  #   alias aurin='yay -S'
  #   alias aurse='yay -Ss'
  #   alias aurup='yay -Syu'
  # fi
  # if (( $+commands[paru] )); then
  #   alias aurin='paru -S'
  #   alias aurse='paru -Ss'
  #   alias aurup='paru -Syu'
  # fi

elif (( $+commands[apt] )); then
  # Debian / Ubuntu (fallback)
  alias pacup='sudo apt update && sudo apt upgrade'
  alias pacin='sudo apt install'
  alias pacse='apt search'
  alias pacrm='sudo apt remove'
  alias pacautorm='sudo apt autoremove'
  alias pacpurge='sudo apt purge'

elif (( $+commands[dnf] )); then
  # Fedora (fallback)
  alias pacup='sudo dnf upgrade'
  alias pacin='sudo dnf install'
  alias pacse='dnf search'
  alias pacrm='sudo dnf remove'
fi
