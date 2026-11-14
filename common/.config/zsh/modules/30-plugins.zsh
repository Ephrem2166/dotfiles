# 30-plugins.zsh — external plugins that must load BEFORE compinit.
# Plugins live at $XDG_DATA_HOME/zsh/plugins/ (cloned, not stowed).
# Missing plugins are skipped silently — the shell still starts.
# --- zsh-completions: fpath must be extended BEFORE compinit ---
for _d in "${_plugin_dirs[@]}"; do
  if [[ -d $_d/zsh-completions/src ]]; then
    fpath=("$_d/zsh-completions/src" $fpath)
    break
  fi
done
unset _d



# _plugin_dir="${XDG_DATA_HOME:-$HOME/.local/share}/zsh/plugins"

# --- zsh-autosuggestions ---
# Fish-style inline suggestions from history. The suggestion appears as grey
# text after the cursor; press End or Right to accept, or Alt+Right for one word.
# if [[ -r "$_plugin_dir/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
#   source "$_plugin_dir/zsh-autosuggestions/zsh-autosuggestions.zsh"
#
#   # Try history first, then completion. History is faster and usually what
  # you meant.
ZSH_AUTOSUGGEST_STRATEGY=(history)

  # Color 8 = bright black / grey. Matches the fish default highlight.
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=40   # skip suggestions for very long buffers
# fi
_find_plugin zsh-autosuggestions zsh-autosuggestions.zsh && source "$REPLY"


# --- zsh-history-substring-search ---
# Fish-style history search: typing "pacman" and pressing Up cycles through
# every past command *containing* "pacman", not just those starting with it.
# This plugin DEFINES the widgets; the actual bindkey happens in
# 50-keybindings.zsh so our bindings win over the plugin's defaults.
# if [[ -r "$_plugin_dir/zsh-history-substring-search/zsh-history-substring-search.zsh" ]]; then
#   source "$_plugin_dir/zsh-history-substring-search/zsh-history-substring-search.zsh"
# fi
#
#
# if [[ -d "$_plugin_dir/zsh-completions/src" ]]; then
#   fpath=("$_plugin_dir/zsh-completions/src" $fpath)
# fi
#
# unset _plugin_dir
# --- zsh-history-substring-search ---
# Defines the widgets; the bindkeys live in 50-keybindings.zsh so ours win.
_find_plugin zsh-history-substring-search zsh-history-substring-search.zsh && source "$REPLY"
