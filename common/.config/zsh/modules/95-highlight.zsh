# 95-highlight.zsh — syntax highlighting. MUST be the last module sourced.
#
# Rules for this file:
#   - If it's not last, highlighting gets cleared by later bindings.
#   - Load only ONE syntax highlighter. Two competing highlighters = flicker + wrong colors.
#   - Prefer fast-syntax-highlighting if both are installed (ZDharma's fork is
#     faster and actively maintained; the original zsh-syntax-highlighting is
#     still fine but slower on large buffers).

_plugin_dir="${XDG_DATA_HOME:-$HOME/.local/share}/zsh/plugins"

if [[ -r "$_plugin_dir/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh" ]]; then
  source "$_plugin_dir/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"
elif [[ -r "$_plugin_dir/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
  source "$_plugin_dir/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

unset _plugin_dir
