# 10-options.zsh — shell options only. No history here (that's 20-history.zsh).
# Reference: `man zshoptions`

# --- Keybindings mode ---
# Explicit emacs mode. Without this, zsh inherits whatever the parent set.
[[ -o interactive ]] && bindkey -e

# Multi-key binding timeout. Default 40 (0.4 s) feels sluggish for `<M-x>` bindings.
KEYTIMEOUT=1

# --- Navigation ---
setopt AUTO_CD              # `foo/` -> `cd foo/`
setopt AUTO_PUSHD           # every cd pushes to the dir stack
setopt PUSHD_IGNORE_DUPS    # no duplicates in the stack
setopt PUSHD_SILENT         # don't print stack after pushd/popd
setopt PUSHD_TO_HOME        # bare `pushd` goes to $HOME

# --- Globbing ---
setopt EXTENDED_GLOB        # `(#b)`, `(^x)`, `(x|y)` patterns
setopt NOMATCH              # error if a glob matches nothing (default on; explicit)
setopt NUMERIC_GLOB_SORT    # file10 after file2, not before
setopt NO_CASE_GLOB         # case-insensitive globbing, matches NO_CASE_GLOB style
unsetopt GLOB_DOTS          # NEVER enable globally — makes `rm *` dangerous
# setopt MARK_DIRS          # trailing / on directory globs — noisy, leave off

# --- Interaction ---
setopt PROMPT_SUBST         # allow $() and ${} expansion inside PS1
setopt PROMPT_SP            # end partial lines with reverse-% + newline
setopt PROMPT_CR            # print CR before prompt
setopt LIST_PACKED          # tighter completion columns
setopt INTERACTIVE_COMMENTS # `# comment` works at interactive prompt
setopt MULTIOS              # `>a >b` writes to both files
setopt NOTIFY               # report bg job completion immediately
setopt IGNORE_EOF           # don't exit on Ctrl-D when buffer non-empty

# --- Beep ---
unsetopt BEEP               # no beep on any error
unsetopt LIST_BEEP          # redundant with BEEP off, but explicit

# --- Correction ---
setopt RM_STAR_WAIT         # 10 s pause before `rm *`
setopt CORRECT              # correct command typos
unsetopt CORRECT_ALL        # do NOT correct arguments (noisy)

# --- Completion-adjacent ---
unsetopt COMPLETE_ALIASES   # substitute alias before completion
setopt ALWAYS_TO_END        # cursor jumps to end of word after completion
setopt COMPLETE_IN_WORD     # complete from both ends of the word
setopt AUTO_PARAM_SLASH     # `~user<Tab>` -> `~user/`
setopt AUTO_NAME_DIRS       # `~var` names for directories in $cdpath

# --- Menu: AUTO_MENU + menu select, NOT MENU_COMPLETE ---
# MENU_COMPLETE inserts the first match immediately and cycles on Tab.
# AUTO_MENU completes as far as possible, opens menu on second Tab.
# Your zstyle 'menu select' and fzf-tab both want AUTO_MENU behavior.
unsetopt MENU_COMPLETE
setopt AUTO_MENU
setopt AUTO_LIST            # list choices on ambiguous completion

# --- zsh/complist: needed for `menuselect` keymap widgets ---
zmodload -i zsh/complist

# --- run-help extensions ---
autoload -Uz run-help run-help-git run-help-ip run-help-sudo
