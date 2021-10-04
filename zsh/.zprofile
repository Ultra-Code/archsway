#use wayland for firefox
#export MOZ_ENABLE_WAYLAND=1

#use wayland for qt apps
#export QT_QPA_PLATFORM=wayland-egl

# set language
export LANG=es_US.UTF-8

# set shell
export SHELL=/usr/bin/zsh

#directory where user-specific configuration files should be written
export XDG_CONFIG_HOME="$HOME/.config"

#defines the preference-ordered set of base directories to search
#for configuration files in addition to the $XDG_CONFIG_HOME base directory
export XDG_CONFIG_DIR="$HOME/.config:/etc/xdg"

#dir where user-specific data files should be written
export XDG_DATA_HOME="$HOME/.local/share"

#defines the preference-ordered set of base directories to search for
#data files in addition to the $XDG_DATA_HOME base directory
export XDG_DATA_DIRS="/usr/local/share:/usr/share:$HOME/.nix-profile/share"

#dir where user-specific non-essential (cached) data should be written
export XDG_CACHE_HOME="$HOME/.cache"

#Used for non-essential, user-specific data files such as sockets, named pipes
export XDG_RUNTIME_DIR=/run/user/$UID

# add local man pages to manpath
export MANPATH="/usr/share/man:/usr/local/share/man:$XDG_DATA_HOME/man"

#style qt apps with adwaita
export QT_STYLE_OVERRIDE=Adwaita-dark

#style gtk apps with Adwaita dark variant
export GTK_THEME=Adwaita:dark

#set DOTFILES for personal config root directory
export DOTFILES="$HOME/.dotfiles"

#Set up zsh config root directory
export ZDOTDIR="$DOTFILES/zsh"

export ZSH_ALIASES="$ZDOTDIR/.zsh_aliases"


export HISTFILE="$ZDOTDIR/.zsh_history"    # History filepath
# The maximum number of events stored in the internal history list
export HISTSIZE=1000
# Refers to the Maximum number of commands that are stored in the zsh history
export SAVEHIST=1000000000

#skip pattern at history write time
export HISTORY_IGNORE="(z|mv|rm|cp|l|vi|man|ln|tar|mkdir|cat|tree|git|g|.|~|d|a|-|np|e|print)*"

# Export default nix envs
if [[ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ]]
then
    source $HOME/.nix-profile/etc/profile.d/nix.sh
fi

export EDITOR="nvim"
export VISUAL="nvim"

export PROGRESS_ARGS='--monitor --wait'

export FZF_DEFAULT_OPTS='--multi --cycle --height 60% --layout=reverse --border=rounded --info=inline'
export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND
export FZF_CTRL_T_OPTS='--preview="cat {}"'
export FZF_ALT_C_OPTS='--preview="tree -C {}"'

#export LS_COLORS="rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.zst=01;31:*.tzst=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.wim=01;31:*.swm=01;31:*.dwm=01;31:*.esd=01;31:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.webp=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:"

#Prevent issues with mtp intercepting usb
export MTP_NO_PROBE="1"

#NNN file manager
export NNN_OPTS="ae"

#NNN list of used plugins
export NNN_PLUG='p:preview-tui;u:getplugs;c:fzcd;j:autojump'

#ENABLE file icons
export ICONLOOKUP=1

#Colors for nnn context
export NNN_COLORS='1234'

BLK="c1" CHR="e2" DIR="27" EXE="2e" REG="00" HARDLINK="60"
SYMLINK="33" MISSING="f7" ORPHAN="c6" FIFO="d6" SOCK="ab" OTHER="c4"
export NNN_FCOLORS="$BLK$CHR$DIR$EXE$REG$HARDLINK$SYMLINK$MISSING$ORPHAN$FIFO$SOCK$OTHER"


if [[ -z $WAYLAND_DISPLAY && $(tty) == /dev/tty1 ]]; then
#for sway's output to be handled by journald
      exec systemd-cat --identifier=sway sway
fi
