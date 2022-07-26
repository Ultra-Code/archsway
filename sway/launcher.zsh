#unbind isn't evaluated immediately until an event or key stroke is executed and rebind is used to bind after unbinding
FZF_DEFAULT_COMMAND='find /usr/share/applications -name "*.desktop" | xargs basename -s ".desktop"' \
        fzf --no-multi --height 100% --layout reverse-list --margin 3% --padding 3% --info hidden \
        --bind 'ctrl-d:reload(sleep 0.01;find /usr/share/applications -name "*.desktop" | xargs basename -s ".desktop")+change-prompt(desktop > )+rebind(enter)+unbind(alt-enter)' \
        --bind 'enter:execute(swaymsg -t command exec gtk-launch {})+abort' \
        --bind 'ctrl-e:reload(printenv PATH | xargs -d : -I {} -r find -L {} -maxdepth 1 -type f -executable -printf "%f\n" 2>/dev/null| sort -u)+change-prompt(executable > )+rebind(alt-enter)+unbind(enter)' \
        --bind 'alt-enter:execute(swaymsg -t command exec kitty {})+abort' \
        --prompt 'desktop > ' \
        --header-first --header "                                         sway app launcher"
