#load instant prompt first
if [[ $ZDOTDIR/zprompt.zsh ]];
then
    source $ZDOTDIR/zprompt.zsh
fi

if [[ $ZDOTDIR/zoption.zsh ]];
then
    source $ZDOTDIR/zoption.zsh
fi

#compinstall can be use to generate & configure your completion style
# setup zsh completion system
autoload -Uz compinit && compinit

if [[ $ZDOTDIR/zstyle.zsh ]];
then
    source $ZDOTDIR/zstyle.zsh
fi

if [[ $ZDOTDIR/zshcomp.zsh ]];
then
    source $ZDOTDIR/zshcomp.zsh
fi

if [[ $ZDOTDIR/zkeybind.zsh ]];
then
    source $ZDOTDIR/zkeybind.zsh
fi

if [[ $ZDOTDIR/zplugins.zsh ]];
then
    source $ZDOTDIR/zplugins.zsh
fi

#help for zsh builtin cmds
autoload -Uz run-help

#load zcalc for peforming math operations
autoload -Uz zcalc

#emit OSC-133;A sequence before each prompt to enable jumping
#bettwen prompts in foot with ctrl+shit+{z(up),x(down)}
if [[ $TERM == "foot" ]];
then
    function precmd() {
        print -Pn "\e]133;A\e\\"
    }
fi

if [[ $ZSH_ALIASES ]];
then
    unalias -m '*'
    source $ZSH_ALIASES
fi
