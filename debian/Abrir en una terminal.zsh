#!/usr/bin/zsh
#https://help.ubuntu.com/community/NautilusScriptsHowto/SampleScripts for
#sample nautilus scripts
#learn zsh scripting and convert it to pure zsh
#in ~/.local/share/nautilus/scripts/
#Dont forget to make the script executable with chmod +x
    # When a directory is selected, go there. Otherwise go to current
    # directory. If more than one directory is selected, show error.
    if [ -n "$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS" ]; then
        set $NAUTILUS_SCRIPT_SELECTED_FILE_PATHS
        if [ $# -eq 1 ]; then
            destination="$1"
            # Go to file's directory if it's a file
            if [ ! -d "$destination" ]; then
                destination="`dirname "$destination"`"
            fi
        else
            zenity --error --title="Error - Open terminal here" \
               --text="You can only select one directory."
            exit 1
        fi
    else
        destination="`echo "$NAUTILUS_SCRIPT_CURRENT_URI" | sed 's/^file:\/\///'`"
    fi

    # It's only possible to go to local directories
    if [ -n "`echo "$destination" | grep '^[a-zA-Z0-9]\+:'`" ]; then
        zenity --error --title="Error - Open terminal here" \
           --text="Only local directories can be used."
        exit 1
    fi

    cd "$destination"
    exec kitty -c NONE -o linux_display_server=Wayland -o foreground=#ffffff -o background=#181818 -o initial_window_width=80c -o initial_window_height=24c
