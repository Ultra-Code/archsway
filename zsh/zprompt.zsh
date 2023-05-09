# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/dotfiles/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# shell prompt fn to display the level of nesting
# add shell_level to POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS
function prompt_shell_level {
[[ $SHLVL -gt 1 ]] && p10k segment -i '🙋' -t '%F{blue}%L zsh'
}

# shell prompt fn for instant prompt
function instant_prompt_shell_level {
  prompt_shell_level
}

# display exit code of application
# Manual page zshmisc(1) line 1182
function prompt_exit_code {
    p10k segment -t '%F{red}%(?..exit %? 🏁)'
}

function instant_prompt_exit_code {
    prompt_exit_code
}

# To customize prompt, run `p10k configure` or edit ~/.config/dotfiles/zsh/.p10k.zsh.
[[ ! -f ~/.config/dotfiles/zsh/.p10k.zsh ]] || {

    source ~/.config/dotfiles/zsh/.p10k.zsh

  POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS+=(

    exit_code             # exit code of lst command executed
    shell_level           # shell level of nesting
    vi_mode               # vi mode (you don't need this if you've enabled prompt_char)
    battery               # internal battery
)
}

