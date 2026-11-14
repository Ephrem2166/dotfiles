# local/10-machine.zsh.example — template for per-machine settings.
# Copy to local/10-machine.zsh (files must end in .zsh to be loaded).
# Everything here is optional and commented out.

# --- Pick the lighter syntax highlighter ---
# ZSH_HIGHLIGHTER=zsh-syntax-highlighting

# --- Move tool dirs to XDG (only if you have NOT already used them in $HOME) ---
# export CARGO_HOME="$XDG_DATA_HOME/cargo"
# export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
# export GOPATH="$XDG_DATA_HOME/go"
# export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"

# --- Extra PATH entries ---
# add_to_path "$HOME/go/bin"

# --- Work / secrets: keep them OUT of the repo that holds your dotfiles ---
# [[ -r $XDG_CONFIG_HOME/zsh/secrets.zsh ]] && source $XDG_CONFIG_HOME/zsh/secrets.zsh
