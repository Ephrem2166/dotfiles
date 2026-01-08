# Use the CLI find to get all files, excluding any filepath
# containing the string "git".
export FZF_DEFAULT_COMMAND='find . -type f ! -path "*git*"'

# Use the CLI fd to respect ignore files (like '.gitignore'),
# display hidden files, and exclude the '.git' directory.
# export FZF_DEFAULT_COMMAND='\
# fd -L -c  \
# --hidden \
# --exclude ".git" \
# --exclude=node_modules \
# --strip-cwd-prefix \
# --no-ignore \
# '
export FZF_DEFAULT_COMMAND='fd --hidden --follow --exclude=.git --exclude=node_modules'
# Use the CLI ripgrep to respect ignore files (like '.gitignore'),
# display hidden files, and exclude the '.git' directory.
export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git"'

# Options for path completion (e.g. vim **<TAB>)
export FZF_COMPLETION_PATH_OPTS='--walker file,dir,follow,hidden'

# Options for directory completion (e.g. cd **<TAB>)
# export FZF_COMPLETION_DIR_OPTS='--walker dir,follow'

# GENERAL OPTIONS
export FZF_DEFAULT_OPTS="\
--exact \
--smart-case \
--algo=v2 \
--height=60% \
--layout=reverse \
--margin=0,5 \
--padding 1,2 \
--border=rounded \
--border-label ' FZF' \
--border-label-pos top \
--no-mouse \
--cycle \
--multi \
# --ansi \ # Performance Problems
--info=inline \
--prompt=' ' \
--pointer='→' \
--marker='+' \
--header='Use CTRL-C or ESC to cancel' \
--header-first \
--reverse \
--color='fg+:#81a1c1,fg:#d8dee9,bg:#2E3440,border:#4C566A,spinner:0,info:#a3be8c,pointer:#bf616a,marker:#81A1C1,prompt:#eceff4' \
--bind='ctrl-d:abort' \
# --preview='if [ -d {} ]; then tree -C -L 2 {}; elif [ -f {} ]; then bat -f --style=numbers {}; fi' \
# --preview-window='right:60%:wrap,<50(bottom,50%)' \
--style full \
# --input-label ' Input' \
# --header-label 'File Type' \
--bind='ctrl-p:preview(stat {})' \
--bind='ctrl-c:abort' \
--bind='ctrl-b:preview-page-up' \
--bind='ctrl-f:preview-page-down' \
--bind='ctrl-u:preview-half-page-up' \
--bind='ctrl-d:preview-half-page-down' \
"

# Preview file content using bat (https://github.com/sharkdp/bat)
export FZF_CTRL_T_OPTS="
  --walker-skip .git,node_modules,target \
  --preview 'bat -n --color=always {}' \
  --bind 'ctrl-/:change-preview-window(down|hidden|)' \
  --border=rounded \
  --preview-window=65% \
"

# CTRL-R - Paste the selected command from history onto the command-line
# CTRL-Y to copy the command into clipboard using pbcopy
export FZF_CTRL_R_OPTS="
  --height 80%
  --margin 0,10
  --preview-window='bottom:3:wrap:border-top,<50(bottom:3:wrap:border-top)'
  --with-nth '2..'
  --preview 'echo {2..}'
  --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
  --bind 'change:first'
  --color header:italic
  --header 'Press CTRL-Y to copy command into clipboard'"

# Print tree structure in the preview window
export FZF_ALT_C_OPTS=" \
  --walker-skip .git,node_modules,target \
  --preview 'tree -C {}' \
"

# Source FZF Functions
source $ZDOTDIR/fzf_functions
