#enable fuzzy auto-completion for Zsh:
if [ -f /usr/share/fzf/key-bindings.zsh ]; then
   . /usr/share/fzf/key-bindings.zsh
   . /usr/share/fzf/completion.zsh
fi

# Completion for kitty
if which kitty &>/dev/null;then
    kitty +complete setup zsh | source /dev/stdin
fi

# add rg completion function to fpath
fpath+=(_rg)

eval "$(zoxide init zsh)"

n ()
{
    # Block nesting of nnn in subshells
    if [ -n $NNNLVL ] && [ "${NNNLVL:-0}" -ge 1 ]; then
        echo "nnn is already running"
        return
    fi

    # The behaviour is set to cd on quit (nnn checks if NNN_TMPFILE is set)
    # To cd on quit only on ^G, either remove the "export" as in:
    #    NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"
    #    (or, to a custom path: NNN_TMPFILE=/tmp/.lastd)
    # or, export NNN_TMPFILE after nnn invocation
    NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"

    nnn -aru -s n

    if [ -f "$NNN_TMPFILE" ]; then
            . "$NNN_TMPFILE"
            rm -f "$NNN_TMPFILE" > /dev/null
    fi
}
