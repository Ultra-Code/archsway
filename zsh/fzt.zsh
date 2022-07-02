FZF_DEFAULT_COMMAND='find *  -name .git -prune -o -type f -print' \
    fzf --bind 'ctrl-d:reload(find *  -name .git -prune -o -type d -print)+change-prompt(dir> )+change-preview(ls --recursive --color=always {}),alt-enter:execute:nnn {}' \
        --bind 'ctrl-f:reload(find *  -name .git -prune -o -type f -print)+change-prompt(file> )+change-preview(bat --style=numbers --color=always --line-range :500 {}),enter:execute:nvim {}' \
    --preview 'bat --style=numbers --color=always --line-range :500 {}' \
    --prompt 'file> ' --height=50% --layout=reverse
