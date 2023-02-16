#!/bin/zsh
readonly FILE=$1
readonly WIDTH=$2
readonly HEIGHT=$3
readonly XOFFSET=$4
readonly YOFFSET=$5

#get the extension of a file
FILE_EXT=${FILE:e}
#convert to lower case
readonly FILE_EXT=${FILE_EXT:l}
readonly CACHE_PATH="${TMPDIR:-/tmp}/lf_cache"

#mime type of file
readonly MIMETYPE=$(file --dereference --brief --mime-type "$FILE")

#my improvement on https://raw.githubusercontent.com/duganchen/kitty-pistol-previewer/main/vidthumb
function cache(){
    if (( $# < 2 )); then
    print "usage: $0 CACHE_PATH File" >&2
    exit -1
  fi
    if  [[  ! -d $1 || ! -f $2 ]]; then
        exit 1
    fi

    printf '%s/%s' $1 "$(stat --printf '%n\0%i\0%F\0%s\0%W\0%Y' -- "$(readlink -f "$2")" | b2sum | cut -d ' ' -f1)"
}

readonly CACHED_FILE=$(cache $CACHE_PATH "$FILE")

function isImageNew {
    if [[ ! -f $CACHED_FILE ]];then
        echo "true"
    else
        echo "false"
    fi
}

function preview(){
    if (( $# < 1 )); then
    print "usage: $0 File" >&2
    exit -1
  fi
  #If the previewer returns a non-zero exit code, then the preview cache for the given file is disabled.
  #This means that if the file is selected in the future, the previewer is called once again.
  #The cleaner is only called if previewing is enabled, the previewer is set, and the previously selected file had its preview cache disabled
    if [[ -n $WAYLAND_DISPLAY ]]
    then
            kitten icat --transfer-mode=file --stdin=no --place "${WIDTH}x${HEIGHT}@${XOFFSET}x${YOFFSET}" "$1" < /dev/null > /dev/tty && exit 1;
    fi
}


function handle_image() {

    local mimetype=$1
    case "$mimetype" in
        ## SVG
        # image/svg+xml|image/svg)
        #     convert -- "${FILE}" $CACHED_FILE && exit 6
        #     exit 1;;

        ## Image
        image/*)
        # if exists convert; then
        #                convert "$3" -flatten -resize "$NNN_PREVIEWWIDTH"x"$NNN_PREVIEWHEIGHT"\> "$NNN_PREVIEWDIR/$3.jpg"
        #            else
                # chafa -f sixel $FILE
                preview $FILE
                ;;

        ## Video
        video/*)
            # Thumbnail
            if [[ $(isImageNew) == "true" ]];then
                lf -remote "send $id echo 'caching'"
                ffmpegthumbnailer -i "${FILE}" -o $CACHED_FILE -s 0 || exit $?
            fi

            preview $CACHED_FILE

            exit 1;;

        ## PDF
        application/pdf)
            if [[ $(isImageNew) == "true" ]];then
            pdftoppm -f 1 -l 1 \
                     -singlefile \
                     -jpeg -tiffcompression jpeg \
                     -- "${FILE}" $CACHED_FILE || exit $?
            mv "${CACHED_FILE}.jpg" ${CACHED_FILE}
            fi

                preview $CACHED_FILE

                exit 1;;

        # */*office*|*/*document*)
        #     if [[ $(isImageNew) == "true" ]];then
        #     #image is store in the cache dir with same name as FILE
        #         libreoffice --convert-to jpg "$FILE" --outdir ${CACHE_PATH:A} &>/dev/null
        #     #get the CACHED_FILE's dirname and append the file without its previous extension since its now jpeg so
        #     #instead append .jpg and move to the CACHED_FILE
        #     local current_img="${CACHE_PATH:A}/${${FILE:t}%.*}.jpg"
        #
        #         mv "$current_img" "$CACHED_FILE"
        #     fi
        #
        #     preview $CACHED_FILE
        #     ;;
        #

        ## ePub, MOBI, FB2 (using Calibre)
        application/epub+zip|application/x-mobipocket-ebook|\
        application/x-fictionbook+xml)

            if [[ $(isImageNew) == "true" ]];then
            gnome-epub-thumbnailer "${FILE}" $CACHED_FILE  || \
            gnome-mobi-thumbnailer "${FILE}" $CACHED_FILE  || \
            # ePub (using https://github.com/marianosimone/epub-thumbnailer)
            epub-thumbnailer "${FILE}" $CACHED_FILE "${WIDTH}" || \
            ebook-meta --get-cover=$CACHED_FILE -- "${FILE}" >/dev/null || exit $?
            fi

            preview $CACHED_FILE
            exit 1;;

    esac

}

function handle_mime() {

    local mimetype=$1
    case "${mimetype}" in
        ## RTF and DOC
        # text/rtf|*msword)
        #     ## Preview as text conversion
        #     ## note: catdoc does not always work for .doc files
        #     ## catdoc: http://www.wagner.pp.ru/~vitus/software/catdoc/
        #     catdoc -- "${FILE}" && exit 5
        #     exit 1;;

        ## DOCX, ePub, FB2 (using markdown)
        ## You might want to remove "|epub" and/or "|fb2" below if you have
        ## uncommented other methods to preview those formats
        # *wordprocessingml.document|*/epub+zip|*/x-fictionbook+xml)
        #     ## Preview as markdown conversion
        #     pandoc -s -t markdown -- "${FILE}" || exit $?;;

        ## XLS
        # *ms-excel)
        #     ## Preview as csv conversion
        #     ## xls2csv comes with catdoc:
        #     ##   http://www.wagner.pp.ru/~vitus/software/catdoc/
        #     xls2csv -- "${FILE}" || exit $?;;

        ## Text | md
        text/*)
            ## Syntax highlight
            bat --color=always --style="plain" --terminal-width $WIDTH --pager never -- "${FILE}" || exit $?;;

        ## Image
        # image/*)
        #     ## Preview as text conversion
        #     # img2txt --gamma=0.6 --width=$WIDTH -- "${FILE}" && exit 4
        #     exiftool "${FILE}" || exit $?;;

        ## Video and audio
        # video/* | audio/*)
        #     mediainfo "${FILE}" || \
        #     exiftool "${FILE}" || exit $?;;
    esac
}

function handle_extension() {

    local ext=$1
    case "${ext}" in
        ## Archive
        a|ace|alz|arc|arj|bz|bz2|cab|cpio|deb|gz|jar|lha|lz|lzh|lzma|lzo|\
        rpm|rz|t7z|tar|tbz|tbz2|tgz|tlz|txz|tZ|tzo|war|xpi|xz|Z|zip)
            bsdtar --list --file "${FILE}" || \
            atool --list -- "${FILE}" || \
            exit $?;;
        rar)
            ## Avoid password prompt by providing empty password
            unrar lt -p- -- "${FILE}" || exit $?;;
        7z)
            ## Avoid password prompt by providing empty password
            7z l -p -- "${FILE}" || exit $?;;

        ## OpenDocument
        # odt|ods|odp|sxw)
        #     ## Preview as text conversion
        #     odt2txt "${FILE}" || \
        #     ## Preview as markdown conversion
        #     pandoc -s -t markdown -- "${FILE}" || exit $?;;

        ## XLSX
        # xlsx)
        #     ## Preview as csv conversion
        #     ## Uses: https://github.com/dilshod/xlsx2csv
        #     xlsx2csv -- "${FILE}" || exit $?;;

        ## HTML
        htm|html|xhtml)
            ## Preview as text conversion
            bat -l html -- "$FILE" || \
            lynx -dump -- "${FILE}" || \
            elinks -dump "${FILE}" || \
            w3m -dump "${FILE}" || \
            pandoc -s -t markdown -- "${FILE}" || exit $?;;

        ## JSON
        json)
            jq --color-output . "${FILE}" || \
            bat -l json "$FILE" || \
            python -m json.tool -- "${FILE}" || exit $?;;


    esac
}


function handle_fallback() {
    bat -- $FILE
}

function start_preview(){
    [[ ! -d $CACHE_PATH ]] && mkdir -p $CACHE_PATH

handle_image $MIMETYPE
handle_extension $FILE_EXT
handle_mime $MIMETYPE
handle_fallback
}

start_preview
