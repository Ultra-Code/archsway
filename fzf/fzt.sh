#!/bin/bash
path=.
if test -n "$1"; then
  user_path=$1
  if test -d "$user_path"; then
    path=$user_path
  else
    echo "path $path does not exit"
    exit 1
  fi
fi

function finish() {
  result=$?
  # Your cleanup code here
  exit ${result}
}
trap finish EXIT SIGINT ERR SIGTERM

FZF_DEFAULT_COMMAND="find $path  -name .git -prune -o -type f -print" \
  fzf --bind "ctrl-d:reload(find $path -name .git -prune -o -type d -print)+change-prompt(dir> )+change-preview(ls --recursive --color=always {}),alt-enter:execute:lf {}" \
  --bind "ctrl-f:reload(find $path -name .git -prune -o -type f -print)+change-prompt(file> )+change-preview(bat --style=numbers --color=always --line-range :500 {}),enter:execute:nvim {}" \
  --preview 'bat --style=numbers --color=always --line-range :500 {}' \
  --prompt 'file> ' --height=50% --layout=reverse
