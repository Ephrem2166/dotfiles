# General Settings
# check `man zshoptions`
# Use Emacs Keybindings
# bindkey -e
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
unsetopt BEEP

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
unsetopt ALWAYS_TO_END

# Autoselect the first completion entry
setopt MENU_COMPLETE

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
setopt GLOB_DOTS

# Sort numeric filenames numerically, instead of lexicographically.
setopt NUMERIC_GLOB_SORT
