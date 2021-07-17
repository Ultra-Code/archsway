#use zsh in vim mode
bindkey -v

#use history-substring-search key bindings
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

bindkey '^[OA' history-substring-search-up
bindkey '^[OB' history-substring-search-down

#fzf keybindings for Zsh:
if [ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]; then
   source /usr/share/doc/fzf/examples/key-bindings.zsh
fi

