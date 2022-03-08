#docs for these styles can be found in man zshcompsys
zstyle ':completion:*' auto-description 'info: %d'
zstyle ':completion:*' cache-path $ZSH_CACHE_DIR
zstyle ':completion:*' completer _complete _approximate # _correct _extensions _expand _ignored
zstyle ':completion:*' expand prefix suffix
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' insert-unambiguous true
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
# See man zshcompwid "completion matching control"
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[.,_-]=* r:|=* l:|=*' 'r:|[.,_-]=** r:|=* l:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' menu select=2
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-cache yes
