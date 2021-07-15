# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"
# ZSH_THEME="af-magic"
# ZSH_THEME="agnoster"
# ZSH_THEME="amuse"
# ZSH_THEME="crunch"
# ZSH_THEME="dogenpunk"
# ZSH_THEME="dst"
# ZSH_THEME="fino"
# ZSH_THEME="half-life"
# ZSH_THEME="jonathan"
# ZSH_THEME="kphoen"
# ZSH_THEME="linuxonly"
# ZSH_THEME="muse"
# ZSH_THEME="sorin"
# ZSH_THEME="strug"
#ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
 CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
 DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
 ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
 COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
    nix-zsh-completions
    z
    zsh-autosuggestions
)

source $OHMYZSH/oh-my-zsh.sh
#unalias -m '*' #remove all omz aliases

#my bash aliases
if [[ $ZSH_ALIASES ]];
then
    source $ZSH_ALIASES
fi

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

#use zsh in vim mode
bindkey -v

#use hjkl to navigate the auto-completion menu in zsh
zmodload zsh/complist
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history

#The function edit-command-line let you edit a command line in a text editor
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line

#use history-substring-search in vim mode
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down


# To display only username on the cmd for agnoster
#prompt_context() {
  #if [[ "$USER" != "$DEFAULT_USER" || -n "$SSH_CLIENT" ]]; then
    #prompt_segment black default "%(!.%{%F{yellow}%}.)$USER"
  #fi
#}
#prompt_context(){} disable user@host prompt


#Shell options
setopt HIST_IGNORE_ALL_DUPS # Do not write a duplicate event to the history file.
setopt HIST_SAVE_NO_DUPS #older commands that duplicate newer ones are omitted.
setopt COMPLETE_ALIASES  # Add autocomplition for aliases
setopt SHARE_HISTORY     # Enable shells to read and write to the most recent history

#fzf keybindings for Zsh:
if [ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]; then
   source /usr/share/doc/fzf/examples/key-bindings.zsh
fi
#enable fuzzy auto-completion for Zsh:
if [ -f /usr/share/doc/fzf/examples/completion.zsh ]; then
   source /usr/share/doc/fzf/examples/completion.zsh
fi

#completions for stack
#autoload -U +X bashcompinit && bashcompinit
#eval "$(stack --bash-completion-script stack)"

# Completion for kitty
kitty + complete setup zsh | source /dev/stdin

# add bdep completions for zsh to fpath
fpath=($DOTFILES/build2/completions $fpath)

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '$ZDOTDIR/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
