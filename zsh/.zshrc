# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.dotfiles/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
     source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# To customize prompt, run `p10k configure` or edit ~/.dotfiles/zsh/.p10k.zsh.
[[ ! -f ~/.dotfiles/zsh/.p10k.zsh ]] || source ~/.dotfiles/zsh/.p10k.zsh

if [[ $ZDOTDIR/zoption.zsh ]];
then
    source $ZDOTDIR/zoption.zsh
fi

if [[ $ZDOTDIR/zkeybind.zsh ]];
then
    source $ZDOTDIR/zkeybind.zsh
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

#source zinit
source "$HOME/.dotfiles/zsh/zinit.zsh"

#Zinit plugins and snippets
zinit depth'1' light-mode for \
    romkatv/powerlevel10k

zinit wait lucid atload'_zsh_autosuggest_start' light-mode for \
    zsh-users/zsh-autosuggestions

zinit wait'3' lucid light-mode blockf for \
     spwhitt/nix-zsh-completions

zinit wait'3' lucid light-mode blockf for \
    zsh-users/zsh-completions

#help for zsh builtin cmds
autoload -Uz run-help

if [[ $ZSH_ALIASES ]];
then
    unalias -m '*'
    source $ZSH_ALIASES
fi
