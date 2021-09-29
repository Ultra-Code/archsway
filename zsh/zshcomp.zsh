#enable fuzzy auto-completion for Zsh:
if [ -f /usr/share/fzf/key-bindings.zsh ]; then
   . /usr/share/fzf/key-bindings.zsh
fi

#completions for stack
#eval "$(stack --bash-completion-script stack)"

# Completion for kitty
kitty + complete setup zsh | source /dev/stdin

function d () {
  if [[ -n $1 ]]; then
    dirs "$@"
  else
    dirs -v | head -10
  fi
}
compdef _dirs d
