# 20-history.zsh — the ONLY place history is configured.
# Do not set HISTFILE, HISTSIZE, SAVEHIST, or HIST_* options anywhere else.

# --- Storage ---
HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history"
HISTSIZE=50000
SAVEHIST=50000

# Create the directory if it doesn't exist (fresh machine, or XDG_STATE_HOME
# was not created yet).
[[ -d ${HISTFILE:h} ]] || mkdir -p ${HISTFILE:h}

# --- Writing ---
setopt APPENDHISTORY          # append, don't overwrite
setopt INC_APPEND_HISTORY     # write immediately, not on shell exit
setopt SHARE_HISTORY          # share history live between all sessions
setopt HIST_FCNTL_LOCK        # file-lock the history file (safe with SHARE_HISTORY)

# --- Format ---
setopt EXTENDED_HISTORY       # timestamp + duration in each entry
setopt HIST_REDUCE_BLANKS     # strip extra whitespace before storing

# --- Deduplication ---
setopt HIST_IGNORE_DUPS       # don't store an event that was just stored
setopt HIST_IGNORE_ALL_DUPS   # delete the older copy of a duplicate
setopt HIST_SAVE_NO_DUPS      # don't write duplicates to the file
setopt HIST_EXPIRE_DUPS_FIRST # when trimming, remove duplicates first
setopt HIST_FIND_NO_DUPS      # when searching history, skip duplicates

# --- Filtering ---
setopt HIST_IGNORE_SPACE      # commands starting with a space are not saved

# --- Safety ---
setopt HIST_VERIFY            # show expansion, press Enter again to execute
