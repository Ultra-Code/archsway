#NOTE: make sure to export ZDOTDIR to $DOTFILES/zsh in /etc/zsh/zshenv

#specify name of current desktop
export XDG_CURRENT_DESKTOP='sway'

# Look at all system udev rules and try to work out and understand them and use the understanding to finish powersaver
export XDG_CONFIG_HOME=$HOME/.config

#Where user-specific non-essential (cached) data should be written (analogous to /var/cache).
export XDG_CACHE_HOME=$HOME/.cache

#Where user-specific data files should be written (analogous to /usr/share).
export XDG_DATA_HOME=$HOME/.local/share

#Where user-specific state files should be written (analogous to /var/lib).
export XDG_STATE_HOME=$HOME/.local/state

#set DOTFILES for personal config root directory
export DOTFILES=$XDG_CONFIG_HOME/dotfiles

#ZDOTDIR is set in /etc/zsh/zshenv
export ZSH_ALIASES=$ZDOTDIR/.zsh_aliases

# The maximum number of events stored in the internal history list
export HISTSIZE=15000

# Refers to the Maximum number of commands that are stored in the zsh history
export SAVEHIST=10000

# History filepath
export HISTFILE=$ZDOTDIR/.zsh_history

if ! pgrep -u $USER ssh-agent > /dev/null; then
    ssh-agent -t 1d > $XDG_RUNTIME_DIR/ssh-agent.env
fi

if [[ ! $SSH_AUTH_SOCK ]]; then
    source $XDG_RUNTIME_DIR/ssh-agent.env >/dev/null
fi

if [[ $(tty) == /dev/tty1 ]]; then
#for sway's output to be handled by journald
      exec systemd-cat --identifier=sway sway
fi
