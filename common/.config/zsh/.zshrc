# ZDOTDIR should be set by ~/.zshenv. If it isn't (e.g. `zsh -f` then manual source),
# bootstrap it now so the rest of this file works.
if [[ -z $ZDOTDIR ]]; then
  export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
  export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
fi
# Guard against double-source (e.g. `source ~/.zshrc` in a running shell)
[[ -n $__ZSHRC_LOADED ]] && return
__ZSHRC_LOADED=1


# export ZSH="$HOME/.oh-my-zsh"
# ZSH_THEME=""
# plugins=(git)
# source "$ZSH/oh-my-zsh.sh"


# Load modules in order.
for _m in 00-env 10-options 20-history 30-plugins 40-completion 50-keybindings \
          60-aliases 70-functions 75-fzf 76-fzf-functions \
          90-integrations 92-prompt 95-highlight; do
  [[ -r "$ZDOTDIR/modules/${_m}.zsh" ]] \
    && source "$ZDOTDIR/modules/${_m}.zsh"
done
unset _m


# Per-machine overrides, loaded after all modules.
for _f in "$ZDOTDIR/local/"*.zsh(N); do
  source "$_f"
done
unset _f

# # 1. Environment: XDG checks, PATH, EDITOR, LOCALE, MANPAGER, DE/Wayland vars
# source "$ZDOTDIR/modules/00-env.zsh"
#
# # 2. Shell options and history
# source "$ZDOTDIR/modules/10-options.zsh"
# source "$ZDOTDIR/modules/20-history.zsh"
#
# # 3. External plugins (autosuggestions, history-substring-search)
# #    Must be sourced BEFORE compinit.
# source "$ZDOTDIR/modules/30-plugins.zsh"
#
# # 4. Completion system: compinit, zstyles, matcher-list, fzf-tab
# source "$ZDOTDIR/modules/40-completion.zsh"
#
# # 5. Keybindings — after plugins so our bindings win
# source "$ZDOTDIR/modules/50-keybindings.zsh"
#
# # 6. Aliases and functions
# source "$ZDOTDIR/modules/60-aliases.zsh"
# source "$ZDOTDIR/modules/70-functions.zsh"
#
# # 7. Integrations: fzf, zoxide, direnv, lazy nvm/pyenv
# source "$ZDOTDIR/modules/75-fzf.zsh"
# source "$ZDOTDIR/modules/76-fzf-functions.zsh"
# source "$ZDOTDIR/modules/90-integrations.zsh"
#
# # 8. Prompt — must be after everything that could print to stderr
# source "$ZDOTDIR/modules/80-prompt.zsh"
#
# # 9. Machine-local overrides: distro packages drop files here
# for _f in "$ZDOTDIR/local/"*.zsh(N); do
#   source "$_f"
# done
# unset _f
#
# # 10. Syntax highlighting — MUST be last
# source "$ZDOTDIR/modules/95-highlight.zsh"
