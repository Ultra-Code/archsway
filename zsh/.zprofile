#Set up path for interactive envirionment
export PATH=$HOME/.local/bin:$PATH

# set language
export LANG=es_US.UTF-8
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
export XDG_DATA_DIRS="/usr/local/share/:/usr/share:$HOME/.nix-profile/share"

#dir where user-specific non-essential (cached) data should be written
export XDG_CACHE_HOME="$HOME/.cache"

# add local man pages to manpath
export MANPATH="/usr/share/man:/usr/local/share/man:$XDG_DATA_HOME/man"

#theme qt apps with adawaita
export QT_STYLE_OVERRIDE=Adwaita-Dark

#set DOTFILES for personal config root directory
export DOTFILES="$HOME/.dotfiles"

#Set up zsh config root directory
export ZDOTDIR="$DOTFILES/zsh"

export ZSH_ALIASES="$ZDOTDIR/.zsh_aliases"


export HISTFILE="$ZDOTDIR/.zsh_history"    # History filepath
export HISTSIZE=1000000000              # Refers to the maximum number of commands that are loaded into memory from the history file
export SAVEHIST=1000000000              # Refers to the Maximum number of commands that are stored in the zsh history

#skip pattern at history write time
export HISTORY_IGNORE="(z|mv|rm|cp|l|vi|man|ln|tar|mkdir|cat|tree|git|g|.|~|d|a|_|-|np|e)*"

# Export default nix envs
if [[ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ]]
then
    source $HOME/.nix-profile/etc/profile.d/nix.sh
fi

export EDITOR="nvim"
export VISUAL="nvim"

export PROGRESS_ARGS='--monitor --wait'

export FZF_DEFAULT_OPTS='--multi --cycle --height 60% --layout=reverse --border=rounded --info=inline'
export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND
export FZF_CTRL_T_OPTS='--preview="cat {}"'
export FZF_ALT_C_OPTS='--preview="tree -C {}"'
