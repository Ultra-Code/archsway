(FZF_DEFAULT_COMMAND='^fd --type file --hidden'
    fzf --bind $"ctrl-d:reload('(^fd --type d)')+change-prompt('(dir> )')+change-preview('(^ls --recursive --color=always {})'),alt-enter:execute:('(^lf {})')"
        --bind $"ctrl-f:reload('(^fd --type f)')+change-prompt('(file> )')+change-preview('(^bat --style=numbers --color=always --line-range 30:500  {})'),enter:execute:('(^nvim {})')"
        --preview $'($env.DOTFILES)/fzf/previewer.zsh {}'
        --prompt 'file> '
        --height=50%
        --layout=reverse
)
