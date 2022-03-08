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

#CTRL+x a is use to expand aliases
#configure CTRL+x i to switch to the interactive mode in the completion menu
bindkey -M menuselect '^xi' vi-insert
#Leaves the menu selection and restore the previous command.
bindkey -M menuselect '^xc' send-break
#Insert the match in your command and let the completion menu open to insert another match
bindkey -M menuselect '^xn' accept-and-menu-complete
#undo previous action
bindkey -M menuselect '^xu' undo
# moves the marker to the first line
bindkey -M menuselect '^xb' beginning-of-history
# moves the marker to the last line
bindkey -M menuselect '^xe' end-of-history

#use vim key bindings kj for scrolling history in vim command mode
bindkey -M vicmd 'k' vi-up-line-or-history
bindkey -M vicmd 'j' vi-down-line-or-history

#Enable Shift-Tab for reverse scrolling menu complete
bindkey '^[[Z' reverse-menu-complete
