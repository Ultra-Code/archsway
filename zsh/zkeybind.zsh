#use zsh in vim mode
bindkey -v

#NOTE:module zsh/complist must be loaded before autoloading compinit
#hjkl to navigate the completion menu
#the module complist give you access to menuselect
#to customize the menu selection during completion
zmodload zsh/complist
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history

#configure CTRL+x i to switch to the interactive mode in the completion menu
bindkey -M menuselect '^xi' vi-insert

#use vim key bindings kj for scrolling history in vim command mode
bindkey -M vicmd 'k' vi-up-line-or-history
bindkey -M vicmd 'j' vi-down-line-or-history

#fzf keybindings for Zsh:
if [ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]; then
   source /usr/share/doc/fzf/examples/key-bindings.zsh
fi

#Enable Shift-Tab for reverse scrolling menu complete
bindkey '^[[Z' reverse-menu-complete
