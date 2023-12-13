#!/bin/zsh
readonly FILE=$1
readonly WIDTH=$FZF_PREVIEW_COLUMNS
readonly HEIGHT=$FZF_PREVIEW_LINES
readonly XOFFSET=0
readonly YOFFSET=0
DIMENTIONS=${WIDTH}x${HEIGHT}

if [[ $# -ne 1 ]]; then
  >&2 echo "usage: $0 FILENAME"
  exit 1
fi

#get the extension of a file
FILE_EXT=${FILE:e}
#convert to lower case
readonly FILE_EXT=${FILE_EXT:l}

function set_dimentions(){
    if [[ $DIMENTIONS = x ]]; then
        DIMENTIONS=$(stty size < /dev/tty | awk '{print $2 "x" $1}')
    elif ! [[ $KITTY_WINDOW_ID ]] && (( FZF_PREVIEW_TOP + HEIGHT == $(stty size < /dev/tty | awk '{print $1}') )); then
      # Avoid scrolling issue when the Sixel image touches the bottom of the screen
      # * https://github.com/junegunn/fzf/issues/2544
        DIMENTIONS=${WIDTH}x$((HEIGHT - 1))
    fi
}

function preview(){
    # 1. 'memory' is the fastest option but if you want the image to be scrollable or if you want fzf to be able
    #    to redraw the image on terminal resize or on "change-preview-window" then you have to use 'stream'.
    #
    # 2. The last line of the output is the ANSI reset code without newline.
    #    This confuses fzf and makes it render scroll offset indicator.
    #    So we remove the last line and append the reset code to its previous line.
    if [[ $KITTY_WINDOW_ID ]]; then
        kitty icat --clear --transfer-mode=memory --stdin=no --place="$DIMENTIONS@${XOFFSET}x${YOFFSET}" $1 | sed '$d' | sed $'$s/$/\e[m/'

    # 2. Use chafa with Sixel output
    # Add a new line character so that fzf can display multiple images in the preview window
    elif command -v chafa > /dev/null; then
      chafa -f sixel -s "$DIMENTIONS" $FILE
      echo
    fi
}

function handle_media() {
    local ext=$1
    case $ext in
        ## Image
        png|jpg|jpeg|svg)
            # if exists convert; then
            #   convert "$3" -flatten -resize "$NNN_PREVIEWWIDTH"x"$NNN_PREVIEWHEIGHT"\> "$NNN_PREVIEWDIR/$3.jpg"
            # else
            # chafa -f sixel $FILE
            preview $FILE && exit 0
        ;;
    esac
}

function handle_fallback() {
    bat --style=numbers --color=always --paging=never --plain -- $FILE || file $FILE || true
}

function start_preview(){
    set_dimentions
    handle_media $FILE_EXT
    handle_fallback
}

start_preview
