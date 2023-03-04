#!/bin/zsh
readonly name=${ZSH_ARGZERO:t} # or ${(%):-%1N};

if ! which fzf &> /dev/null; then
    printf "error: fzf is required to use %s.\n" ${name} >&2
    exit 3
fi

declare user_input
if ! user_input="$(mktemp --tmpdir "${name}.input.XXXXXXXXX")";then
    print 'error: Failed to create tmp file. $TMPDIR (or /tmp if $TMPDIR is unset) may not be writable.\n' >&2
    exit 4
fi

#https://unix.stackexchange.com/questions/710366/is-there-a-zsh-equivalent-of-bash-builtin-readarray
#https://www.reddit.com/r/zsh/comments/tt6gm8/why_doesnt_zsh_have_an_equivalent_of_bashs/
readonly HELP_MSG=("${(@)${(f)$(<< EOF
launcher help\n

ctrl-d       desktop mode (default)\n
ctrl-e       exe mode\n

Enter       Confirm selection\n

?           Help (this page)\n
ESC         Quit\n
EOF
)}}")

readonly DESKTOP_FILES=("${(f)$(find /usr/share/applications -name '*.desktop')}")
#remove directory path
readonly DESKTOP_FILES_LIST=(${DESKTOP_FILES:t})
#remove file extension
readonly DESKTOP_NAMES=(${DESKTOP_FILES_LIST:r})

#split on `:`
readonly EXECUTABLE_PATH=("${(s.:.)PATH}")
#find executable files in list and separate them based on `\n`
readonly EXE_LIST=("${(f)$(find -L ${EXECUTABLE_PATH} -maxdepth 1 -type f -executable)}")
#select the base names of only unique executable files
readonly UNIQ_EXE_NAMES=(${(u)EXE_LIST:t})

readonly DEFAULT_COMMAND="print -l $DESKTOP_NAMES"
readonly ALT_COMMAND="print -l $UNIQ_EXE_NAMES"
readonly HELP="print -l '$HELP_MSG'"

echo "desktop" > $user_input &&
    SHELL="/bin/zsh" \
    FZF_DEFAULT_COMMAND="$DEFAULT_COMMAND" \
    fzf \
    --no-multi \
    --height 100% \
    --layout reverse-list \
    --marker=' ' \
    --margin 3% \
    --padding 3% \
    --info hidden \
    --header "Press ? for help or ESC to quit" \
    --prompt "desktop > " \
    --bind "enter:abort+execute:
        if grep -q 'desktop' $user_input; then
            swaymsg -t command exec gtk-launch {}
        else
            swaymsg -t command exec kitty {}
        fi
    " \
    --bind "ctrl-d:unbind(ctrl-d)+reload($DEFAULT_COMMAND)+change-prompt(desktop > )+execute-silent(echo 'desktop' > '$user_input')+rebind(ctrl-e)" \
    --bind "ctrl-e:unbind(ctrl-e)+reload($ALT_COMMAND)+change-prompt(executable >)+execute-silent(echo 'terminal' > '$user_input')+rebind(ctrl-d)" \
    --bind "?:preview($HELP)" \
    --preview-window "bottom,40%"

rm -f ${user_input} &> /dev/null
