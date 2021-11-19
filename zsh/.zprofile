#Set up path for interactive envirionment
export PATH=$HOME/.local/bin:$PATH

#style qt apps with adwaita
export QT_STYLE_OVERRIDE=Adwaita-dark

#style gtk apps with Adwaita dark variant
export GTK_THEME=Adwaita:dark

#set DOTFILES for personal config root directory
export DOTFILES=$HOME/.dotfiles

#Set up zsh config root directory
export ZDOTDIR=$DOTFILES/zsh

export ZSH_ALIASES=$ZDOTDIR/.zsh_aliases

export HISTFILE=$ZDOTDIR/.zsh_history    # History filepath
# The maximum number of events stored in the internal history list
export HISTSIZE=1000
# Refers to the Maximum number of commands that are stored in the zsh history
export SAVEHIST=1000000000

#skip pattern at history write time
export HISTORY_IGNORE='(z|mv|rm|cp|l|vi|man|ln|tar|mkdir|cat|tree|git|g|.|~|d|a|-|np|e|print|pm|yay|0|1|2|3|4|5|6|7|8|9|)*'

# Export default nix envs
if [[ -e $HOME/.nix-profile/etc/profile.d/nix.sh ]]
then
    source $HOME/.nix-profile/etc/profile.d/nix.sh
fi

export EDITOR=nvim
export VISUAL=nvim

export FZF_DEFAULT_OPTS='--multi --cycle --height 60% --layout=reverse --border=rounded --info=inline'
export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND
export FZF_CTRL_T_OPTS='--preview=cat {}'
export FZF_ALT_C_OPTS='--preview=tree -C {}'

#NNN file manager
export NNN_OPTS=ae

#NNN list of used plugins
export NNN_PLUG='p:preview-tui;u:getplugs;c:fzcd;j:autojump'

#ARCHIVE types supported by bsdtar
export NNN_ARCHIVE="\\.(7z|a|ace|alz|arc|arj|bz|bz2|cab|cpio|deb|gz|jar|lha|lz|lzh|lzma|lzo|rar|rpm|rz|t7z|tar|tbz|tbz2|tgz|tlz|txz|tZ|tzo|war|xpi|xz|Z|zip)$"

#set NNN_PREVIEWDIR to non volatile dir like $XDG_CACHE_HOME/nnn/previews
#if you want to keep previews on disk between reboots
export NNN_PREVIEWDIR=~/.cache/nnn/previews

#b for visiting bookmarks and , for temporary bookmarks
#B for permanent bookmarks and b <CR> for going to bookmarks dir of nnn
export NNN_BMS="d:$HOME/Documents"

#ENABLE file icons
export ICONLOOKUP=1

#Colors for nnn context
export NNN_COLORS='3456'

BLK=c1 CHR=e2 DIR=27 EXE=2e REG=00 HARDLINK=60
SYMLINK=33 MISSING=f7 ORPHAN=c6 FIFO=d6 SOCK=ab OTHER=c4
export NNN_FCOLORS=$BLK$CHR$DIR$EXE$REG$HARDLINK$SYMLINK$MISSING$ORPHAN$FIFO$SOCK$OTHER

if ! pgrep -u $USER ssh-agent > /dev/null; then
    ssh-agent -t 1d > $XDG_RUNTIME_DIR/ssh-agent.env
fi

if [[ ! $SSH_AUTH_SOCK ]]; then
    source $XDG_RUNTIME_DIR/ssh-agent.env >/dev/null
fi

if [[ $(tty) == /dev/tty1 ]]; then
#for sway's output to be handled by journald
      exec systemd-cat --identifier=sway sway
fi
