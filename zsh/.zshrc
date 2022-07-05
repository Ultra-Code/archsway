# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/dotfiles/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


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

#help for zsh builtin cmds
autoload -Uz run-help

#load zcalc for peforming math operations
autoload -Uz zcalc

function zc(){
    zcalc -f -e "$@"
}

function prompt_precmd_for_ctrl_z_x() {
    print -Pn "\e]133;A\e\\"
}
precmd_functions+=(propmt_precmd_for_ctrl_z_x)

if [[ $ZSH_ALIASES ]];
then
    unalias -m '*'
    source $ZSH_ALIASES
fi

# shell prompt fn to display the level of nesting
# add shell_level to POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS
function prompt_shell_level(){
[[ $SHLVL -gt 1 ]] && p10k segment -i '🙋' -t '%F{blue}%L zsh'
}

# shell prompt fn for instant prompt
function instant_prompt_shell_level(){
  prompt_shell_level
}

# To customize prompt, run `p10k configure` or edit ~/.config/dotfiles/zsh/.p10k.zsh.
[[ ! -f ~/.config/dotfiles/zsh/.p10k.zsh ]] || {

    source ~/.config/dotfiles/zsh/.p10k.zsh

  POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS+=(

    shell_level           # shell level of nesting
    vi_mode               # vi mode (you don't need this if you've enabled prompt_char)
    battery               # internal battery
)
}

if [[ $ZDOTDIR/zplugins.zsh ]];
then
    source $ZDOTDIR/zplugins.zsh
fi
