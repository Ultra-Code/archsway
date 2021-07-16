# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.dotfiles/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# To customize prompt, run `p10k configure` or edit ~/.dotfiles/zsh/.p10k.zsh.
[[ ! -f ~/.dotfiles/zsh/.p10k.zsh ]] || source ~/.dotfiles/zsh/.p10k.zsh

#Setup completion system
autoload -Uz compinit
compinit

### Added by Zinit's installer
if [[ ! -f $HOME/.dotfiles/zsh/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "$HOME/.dotfiles/zsh/.zinit" && command chmod g-rwX "$HOME/.dotfiles/zsh/.zinit"
    command git clone https://github.com/zdharma/zinit "$HOME/.dotfiles/zsh/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.dotfiles/zsh/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
### End of Zinit's installer chunk

#Zinit plugins and snippets
# Load powerlevel10k theme
zinit ice depth"1" # git clone depth
zinit light romkatv/powerlevel10k

zinit ice wait lucid atload'_zsh_autosuggest_start'
zinit light zsh-users/zsh-autosuggestions

zinit ice wait lucid
zinit light agkozak/zsh-z

zinit ice wait lucid
zinit light zsh-users/zsh-history-substring-search

#my bash aliases
if [[ $ZSH_ALIASES ]];
then
    source $ZSH_ALIASES
fi

#use zsh in vim mode
bindkey -v

#use history-substring-search key bindings
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

bindkey '^[OA' history-substring-search-up
bindkey '^[OB' history-substring-search-down

#Shell options
setopt HIST_IGNORE_ALL_DUPS # Do not write a duplicate event to the history file.
setopt HIST_SAVE_NO_DUPS #older commands that duplicate newer ones are omitted.
setopt COMPLETE_ALIASES  # Add autocomplition for aliases
setopt SHARE_HISTORY     # Enable shells to read and write to the most recent history
setopt HIST_IGNORE_SPACE # ignore commands that start with space

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
