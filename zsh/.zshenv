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

export HISTFILE="$HOME/.zsh_history"    # History filepath
export HISTSIZE=1000000                   # Maximum events for internal history
export SAVEHIST=1000000                   # Maximum events in history file

export ZSH_ALIASES="$HOME/.zsh_aliases"

export EDITOR="nvim"
export VISUAL="nvim"

# Path to your oh-my-zsh installation.
export ZSH="$XDG_DATA_HOME/.oh-my-zsh"

# Set fzf installation directory path
export FZF_BASE="/usr/bin/fzf"

#NODE global path
export NODE_REPL_HISTORY="$XDG_CONFIG_HOME/"
#export ANDROID_HOME="/opt/Android/"
export PATH="$PATH:/sbin/:$HOME/.local/bin/:$HOME/.yarn/bin/"
#export JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64/"
#export ANDROID_NKD_ROOT="/opt/Android/ndk/21.1.6352462/"

#Add completions for pipenv
#eval "$(pipenv --completion)"
#export PIPENV_VENV_IN_PROJECT=1

#Cofigurations For Building using CMAKE
export CC=/usr/bin/clang
export CXX=/usr/bin/clang++
export CMAKE_GENERATOR=Ninja

# Add env to my neovim init file
export NVIMRC="$XDG_CONFIG_HOME/nvim/init.vim"
