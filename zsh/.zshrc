# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.dotfiles/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# To customize prompt, run `p10k configure` or edit ~/.dotfiles/zsh/.p10k.zsh.
[[ ! -f ~/.dotfiles/zsh/.p10k.zsh ]] || source ~/.dotfiles/zsh/.p10k.zsh

#source before compinit
if [[ -f $HOME/.dotfiles/zsh/.zinit/bin/zinit.zsh ]]; then
source "$HOME/.dotfiles/zsh/.zinit/bin/zinit.zsh"
fi

#Zinit plugins and snippets
zinit depth"1" light-mode for \
    romkatv/powerlevel10k

zinit wait'9' lucid light-mode for \
    zsh-users/zsh-history-substring-search

zinit wait'9' lucid atload'_zsh_autosuggest_start' light-mode for \
    zsh-users/zsh-autosuggestions

zinit wait'9' lucid atload'_zshz_precmd' light-mode for \
    agkozak/zsh-z

zinit wait'9' lucid light-mode blockf for \
     spwhitt/nix-zsh-completions

#Setup completion system
autoload -Uz compinit
compinit

#Automatically load bash completion functions
#autoload -U +X bashcompinit && bashcompinit

if [[ $ZDOTDIR/zoption.zsh ]];
then
    source $ZDOTDIR/zoption.zsh
fi

if [[ $ZDOTDIR/zshcomp.zsh ]];
then
    source $ZDOTDIR/zshcomp.zsh
fi

if [[ $ZDOTDIR/zstyle.zsh ]];
then
    source $ZDOTDIR/zstyle.zsh
fi

if [[ $ZSH_ALIASES ]];
then
    source $ZSH_ALIASES
fi

if [[ $ZDOTDIR/zkeybind.zsh ]];
then
    source $ZDOTDIR/zkeybind.zsh
fi
