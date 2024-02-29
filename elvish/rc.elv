use os
use path 
use runtime
use str
use re

# Add local/bin to path env
if (has-env WSLENV) {
     set paths = [/usr/local/sbin /usr/local/bin /usr/bin ~/.local/bin]
} else {
     set paths =  (conj $paths ~/.local/bin)
}
# https://elv.sh/ref/language.html#exception
# var output = (var error = ?(pgrep -u $E:USER ssh-agent))
if (not ?(pgrep -u $E:USER ssh-agent)) {
     ssh-agent -t 1d -c  | slurp | str:replace setenv set-env (all) | to-lines | take 2 | to-lines | slurp | print (all) > $E:XDG_RUNTIME_DIR/ssh-agent.env 
     cat $E:XDG_RUNTIME_DIR/ssh-agent.env | slurp | eval (all)
}

if (not ?(test -S $E:SSH_AUTH_SOCK)) {
     cat $E:XDG_RUNTIME_DIR/ssh-agent.env | slurp | eval (all)
}


if (re:match "/dev/tty[1-3]" (tty)) {
    # set XDG_CURRENT_DESKTOP
    set E:XDG_CURRENT_DESKTOP = river

    # for river's log output to be handled by journald
    exec systemd-cat --identifier=river river
}

set-env LS_COLORS (vivid generate alabaster_dark) # alabaster_dark ayu catppuccin-latte iceberg-dark one-dark

set-env XDG_CACHE_HOME (put $E:HOME | path:join (all) .cache)
set-env XDG_CONFIG_HOME (put $E:HOME | path:join (all) .config)
set-env XDG_LOCAL_HOME (put $E:HOME | path:join (all) .local)
set-env XDG_DATA_HOME (put $E:XDG_LOCAL_HOME | path:join (all) share)
set-env XDG_STATE_HOME (put $E:XDG_LOCAL_HOME | path:join (all) state)

set-env DOTFILES (put $E:XDG_CONFIG_HOME | path:join (all) dotfiles)
set E:ELVRC = $E:DOTFILES/elvish

set E:STARSHIP_CONFIG = $E:DOTFILES/starship/starship.toml

set-env GTK_THEME 'Adwaita:dark'
set-env QT_STYLE_OVERRIDE 'adwaita-dark'

set-env MANROFFOPT '-c'
set-env MANPAGER $runtime:elvish-path" -c 'col --no-backspaces --spaces | bat -l man --plain'"

if (os:is-dir ~/.local/cargo) {
     set E:CARGO_HOME = (put $E:XDG_LOCAL_HOME | path:join (all) cargo)
     set-env RUSTUP_HOME (put $E:XDG_LOCAL_HOME | path:join (all) rustup)
     set-env PATH  (put $E:CARGO_HOME | path:join (all) bin | conj $paths (all) | str:join ':' (all))

}

if (os:is-dir ~/.local/go) {
     set E:GOPATH = (put $E:XDG_LOCAL_HOME | path:join (all) go)
     set-env GOBIN (put $E:GOPATH | path:join (all) bin)
     set-env PATH  (put $E:GOBIN | conj $paths (all) | str:join ':' (all))
}

if (os:is-dir ~/.local/bun) {
     set E:BUN_INSTALL = $E:XDG_LOCAL_HOME/bun
     set paths =  (put $E:BUN_INSTALL | path:join (all) bin | conj $paths (all))
}

if (has-external composer) {
   set E:COMPOSER_HOME = (put $E:XDG_LOCAL_HOME | path:join (all) composer)
   set paths =  (put $E:COMPOSER_HOME | path:join (all) vendor bin | conj $paths (all))
}

# elvish limited vi editing mode
set edit:insert:binding[Ctrl-'['] = $edit:command:start~

# enable completions from these shells when completions aren't avilable in current shell
set-env CARAPACE_BRIDGES 'zsh,fish,bash,inshellisense' 
set-env CARAPACE_MATCH 1 # make completion matching case insensitive
set-env CARAPACE_ENV 1 # enable environment variable completion
eval (carapace _carapace | slurp)

eval (starship init elvish)

# dedup path list
set paths = [(put $paths | order (all) | compact)]

set-env EDITOR (if (has-external hx) { which hx } else { which helix })

use ./aliases
