#Set up zsh config root directory
export ZDOTDIR="$HOME/configurations/zsh/"

# This sets up colors properly
export TERM="xterm-256color"

# set shell
export SHELL=/usr/bin/zsh

#directory where user-specific configuration files should be written
export XDG_CONFIG_HOME="$HOME/.etc"

#defines the preference-ordered set of base directories to search
#for configuration files in addition to the $XDG_CONFIG_HOME base directory
export XDG_CONFIG_DIR="$HOME/.config:/etc/xdg"

#dir where user-specific data files should be written
export XDG_DATA_HOME="$HOME/.local/share"

#defines the preference-ordered set of base directories to search for
#data files in addition to the $XDG_DATA_HOME base directory
export XDG_DATA_DIRS="/usr/local/share/:/usr/share/"

#dir where user-specific non-essential (cached) data should be written
export XDG_CACHE_HOME="$HOME/.cache"

#defines the base directory relative to which user-specific non-essential
#runtime files and other file objects (such as sockets, named pipes, ...)
#should be stored
export XDG_RUNTIME_DIR=/run/user/1000

export HISTFILE="$ZDOTDIR/.zsh_history"    # History filepath
export HISTSIZE=1000000000              # Refers to the maximum number of commands that are loaded into memory from the history file
export SAVEHIST=1000000000              # Refers to the Maximum number of commands that are stored in the zsh history

export ZSH_ALIASES="$ZDOTDIR/.zsh_aliases"

export EDITOR="vi"
export VISUAL="vi"

# Path to your oh-my-zsh installation.
export OHMYZSH="$XDG_DATA_HOME/.oh-my-zsh"

# Export default nix envs
if [ -f $HOME/.nix-profile/etc/profile.d/nix.sh ]; then
    source $HOME/.nix-profile/etc/profile.d/nix.sh
fi

export PATH="$HOME/.local/bin/:/sbin/:$PATH"

#Cofigurations For Building using CMAKE
export CC=/usr/bin/gcc
export CXX=/usr/bin/g++
export CMAKE_GENERATOR=Ninja

# Add env to my neovim init file
export NVIMRC="$XDG_CONFIG_HOME/nvim/init.lua"

export FZF_DEFAULT_OPTS='--multi --cycle --height 60% --layout=reverse --border=rounded --info=inline'
export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND
export FZF_CTRL_T_OPTS='--preview="cat {}"'
export FZF_ALT_C_OPTS='--preview="tree -C {}"'
