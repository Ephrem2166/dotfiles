# General Settings
# check `man zshoptions`



# Use Emacs Keybindings
# bindkey -e

# Default is 40 (0.4s)
KEYTIMEOUT=1   # 10 ms
# Go to folder path without using CD
setopt AUTO_CD
# Push the old directory onto the stack on cd.
setopt AUTO_PUSHD
# Do not store duplicates in the stack.
setopt PUSHD_IGNORE_DUPS
# Do not print the directory stack after pushd or popd.
setopt PUSHD_SILENT

# Default: Blank `pushd` goes to home
setopt PUSHD_TO_HOME

# Treat metacharcters as part of patterns for filename generation
setopt EXTENDED_GLOB
# Print error if no match found
setopt NOMATCH

setopt PROMPT_SUBST # enable command substitution in prompt
setopt LIST_PACKED  # The completion menu takes less space.

# Do not show error
setopt BEEP
# don't beep on ambiguous completions
setopt NO_LIST_BEEP
# setopt no_beep
# History Related
setopt APPENDHISTORY
setopt EXTENDED_HISTORY       # Write the history file in the ':start:elapsed;command' format.
setopt SHARE_HISTORY          # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST # Expire a duplicate event first when trimming history.
setopt HIST_IGNORE_DUPS       # Do not record an event that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS   # Delete an old recorded event if a new event is a duplicate.
setopt HIST_FIND_NO_DUPS      # Do not display a previously found event.
setopt HIST_IGNORE_SPACE      # Do not record an event starting with a space.
setopt HIST_SAVE_NO_DUPS      # Do not write a duplicate event to the history file.
setopt HIST_VERIFY            # Do not execute immediately upon history expansion.
setopt HIST_REDUCE_BLANKS     # Remove extra blanks from each command added to history
setopt HIST_FCNTL_LOCK
# Don't wait until shell exits to add commands to history
setopt INC_APPEND_HISTORY

# Wait 10 seconds wait if `rm *`
setopt RM_STAR_WAIT

# Allow comment with #
setopt INTERACTIVE_COMMENTS

# Spell Correction for Commands
setopt CORRECT
# But not for arguments
unsetopt CORRECT_ALL

# Make Alias Commands Distinct for Completion purpose
# By unsetting, substitute alias before completion
unsetopt COMPLETE_ALIASES

# When completing from the middle of a word, move the cursor to the end of the
# word;
setopt ALWAYS_TO_END

# Autoselect the first completion entry
unsetopt MENU_COMPLETE

# Show completion menu on successive tab press (menu_complete overrides)
setopt AUTO_MENU

# Automatically list choices on ambiguous completion.
setopt AUTO_LIST

# DEFAULT; will put / instead of space when autocomplete for param (ex ~D(tab)
# puts ~D/)
setopt AUTO_PARAM_SLASH

# allow completion from within a word/phrase
# ex: completes to Desktop/ from Dktop with cursor before k)
setopt COMPLETE_IN_WORD

# Show directory name
setopt AUTO_NAME_DIRS

# Allow globs to match dotfiles.
unsetopt GLOB_DOTS

# Sort numeric filenames numerically, instead of lexicographically.
setopt NUMERIC_GLOB_SORT

# case-insensitive globbing
setopt NO_CASE_GLOB

# Append trailing / to filename expansion when they match a directory
setopt MARK_DIRS

# Interrupt me to let me know a background jobs finished.
setopt NOTIFY

# Prevents accidental shell exit on Ctrl-D
setopt IGNORE_EOF

# fix the "partial line" artifact where a command
# output without a trailing newline eats your prompt
setopt PROMPT_SP
setopt PROMPT_CR

# Display red dots whilst waiting for commands to complete.
# COMPLETION_WAITING_DOTS="true"
# COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# 🔥 FIXME:: Conflicts with starship
# autoload -U colors && colors

# Now we autoload run-help and several extensions to it which provide
# more precise help for certain external commands.
autoload -Uz run-help
autoload -Uz run-help-git
autoload -Uz run-help-ip
autoload -Uz run-help-sudo

# Selecting options using Tab, arrows, and C-p / C-n:
zmodload zsh/complist


# General Settings

# --- Shell mode ---
bindkey -e

# --- Options ---
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT
setopt PUSHD_TO_HOME

setopt EXTENDED_GLOB
setopt NOMATCH
setopt NUMERIC_GLOB_SORT
setopt NO_CASE_GLOB
# NOTE: GLOB_DOTS intentionally NOT set globally — see completion file's `_comp_options+=(globdots)`
# setopt MARK_DIRS   # enable only if you want trailing / on every directory match

setopt PROMPT_SUBST
setopt PROMPT_SP
setopt PROMPT_CR
setopt LIST_PACKED

setopt NO_BEEP
setopt IGNORE_EOF
setopt INTERACTIVE_COMMENTS
setopt MULTIOS
# setopt NO_CLOBBER   # uncomment if you want > to refuse overwriting files

# --- History ---
HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history"
HISTSIZE=50000
SAVEHIST=50000
[[ -d ${HISTFILE:h} ]] || mkdir -p ${HISTFILE:h}

setopt APPENDHISTORY
setopt EXTENDED_HISTORY
setopt SHARE_HISTORY
setopt HIST_FCNTL_LOCK
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_SAVE_NO_DUPS
setopt HIST_VERIFY
setopt HIST_REDUCE_BLANKS
setopt INC_APPEND_HISTORY

# --- Correction ---
setopt RM_STAR_WAIT
setopt CORRECT
unsetopt CORRECT_ALL

# --- Completion-related shell behavior ---
unsetopt COMPLETE_ALIASES
setopt ALWAYS_TO_END
setopt COMPLETE_IN_WORD
setopt AUTO_PARAM_SLASH
setopt AUTO_NAME_DIRS
setopt NOTIFY

# Menu: pick ONE of the two below
unsetopt MENU_COMPLETE
setopt AUTO_MENU

setopt AUTO_LIST
# setopt AUTOLIST    # duplicate of AUTO_LIST

# --- Keys ---
KEYTIMEOUT=1

# --- Help system ---
autoload -Uz run-help
autoload -Uz run-help-git
autoload -Uz run-help-ip
autoload -Uz run-help-sudo

# --- PATH  ---
typeset -U path PATH
path=(
  "$HOME/.local/bin"
  "$HOME/bin"
  /usr/local/bin
  $path
)
