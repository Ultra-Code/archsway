#NNN file manager
export NNN_OPTS=ae

#NNN list of used plugins
export NNN_PLUG='p:preview-tui;u:getplugs;c:fzcd;j:autojump'

#ARCHIVE types supported by bsdtar
export NNN_ARCHIVE="\\.(7z|a|ace|alz|arc|arj|bz|bz2|cab|cpio|deb|gz|jar|lha|lz|lzh|lzma|lzo|rar|rpm|rz|t7z|tar|tbz|tbz2|tgz|tlz|txz|tZ|tzo|war|xpi|xz|Z|zip)$"

#set NNN_PREVIEWDIR to non volatile dir like $XDG_CACHE_HOME/nnn/previews
#if you want to keep previews on disk between reboots
export NNN_PREVIEWDIR=$XDG_CACHE_HOME/nnn/previews

# b for visiting bookmarks and , for temporary bookmarks
# B for permanent bookmarks and b <CR> for going to bookmarks dir of nnn
export NNN_BMS="b:$HOME/files/Documents;s:$HOME/files/Videos/Sitcom;l:$HOME/files/Documents/COMPUTER SCIENCE/UNDERGRADUATE;d:$HOME/Downloads"

#ENABLE file icons
export ICONLOOKUP=1

#Colors for nnn context
export NNN_COLORS='3456'

BLK=c1 CHR=e2 DIR=27 EXE=2e REG=00 HARDLINK=60
SYMLINK=33 MISSING=f7 ORPHAN=c6 FIFO=d6 SOCK=ab OTHER=c4
export NNN_FCOLORS=$BLK$CHR$DIR$EXE$REG$HARDLINK$SYMLINK$MISSING$ORPHAN$FIFO$SOCK$OTHER
