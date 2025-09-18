# Set Fish greeting message (disable by setting empty string)
set fish_greeting ""

### SET EITHER DEFAULT EMACS MODE OR VI MODE ###
function fish_user_key_bindings
    fish_default_key_bindings
    #    fish_vi_key_bindings
end

# Fix PATH issues if running on a non-POSIX shell system
set -x PATH $HOME/.local/bin $HOME/bin /usr/local/bin /usr/bin /usr/bin/pandoc /bin /usr/sbin /sbin $HOME/.npm-global/bin $HOME/.nvm/versions/node/v22.14.0/bin/ $PATH
# Set default editor
set -x EDITOR nvim
set -x VISUAL nvim

# Export 
# Set custom Starship config file
set -x STARSHIP_CONFIG ~/.config/starship/starship.toml
### "nvim" as manpager
set -x MANPAGER "nvim +Man!"
# Use fzf for command history search (if installed)
if command -v fzf >/dev/null
    set -U FZF_DEFAULT_COMMAND 'rg --files --hidden --follow --glob "!.git/*"'
    set -U FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND
    set -U FZF_ALT_C_COMMAND 'fd --type d'
end
# Enable Starship prompt (if installed)
if command -v starship >/dev/null
    starship init fish | source
end

# Zoxide integration 
if command -v zoxide >/dev/null
    zoxide init fish | source
end

# Make a new directory and move into it
function mkcd
    mkdir -p $argv[1]; and cd $argv[1]
end

source ~/.config/fish/aliases.fish

# Pyenv
pyenv init - fish | source

# Yazi 
function y
	set tmp (mktemp -t "yazi-cwd.XXXXXX")
	yazi $argv --cwd-file="$tmp"
	if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
		builtin cd -- "$cwd"
	end
	rm -f -- "$tmp"
end