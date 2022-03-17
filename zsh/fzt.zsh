FZF_DEFAULT_COMMAND='fd . --type file' \
    fzf --bind 'ctrl-d:reload(fd . --type directory)+change-prompt(dir> )+change-preview(exa --tree {}),alt-enter:execute:nnn {}' \
        --bind 'ctrl-f:reload(fd . --type file)+change-prompt(file> )+change-preview(bat --style=numbers --color=always --line-range :500 {}),enter:execute:nvim {}' \
    --preview 'bat --style=numbers --color=always --line-range :500 {}' \
    --prompt 'file> ' --height=50% --layout=reverse
