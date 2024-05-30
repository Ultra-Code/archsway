use os
use path 
use runtime
use str

set-env XDG_CACHE_HOME (put $E:HOME | path:join (all) .cache)
set-env XDG_CONFIG_HOME (put $E:HOME | path:join (all) .config)
set-env XDG_LOCAL_HOME (put $E:HOME | path:join (all) .local)
set-env XDG_DATA_HOME (put $E:XDG_LOCAL_HOME | path:join (all) share)
set-env XDG_STATE_HOME (put $E:XDG_LOCAL_HOME | path:join (all) state)

set-env GNUPGHOME $E:XDG_CONFIG_HOME/gnupg

if (not (has-env SSH_AUTH_SOCK)) {
     set-env SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
}

set-env DOTFILES (put $E:XDG_CONFIG_HOME | path:join (all) dotfiles)
set E:ELVRC = $E:DOTFILES/config/elvish

set-env GTK_THEME 'Adwaita:dark'
set-env QT_STYLE_OVERRIDE 'adwaita-dark'

set-env MANROFFOPT '-c'
set-env MANPAGER $runtime:elvish-path" -c 'col --no-backspaces --spaces | bat -l man --plain'"

# Setup debuginfo daemon for packages in the official repositories
cat /etc/debuginfod/archlinux.urls | set-env DEBUGINFOD_URLS (all)

# Add local/bin to path env
if (has-env WSLENV) {
     set paths = [/usr/local/sbin /usr/local/bin /usr/bin ~/.local/bin]
} else {
     set paths =  (conj $paths ~/.local/bin)
}

if (has-external modular) {
     set-env MODULAR_HOME (put $E:XDG_LOCAL_HOME | path:join (all) modular)
     var MOJO_PATH = (modular config mojo.path)
     set-env PATH  (put $MOJO_PATH | path:join (all) bin | conj $paths (all) |str:join ':' (all))
     # INFO: since the only currently supported linux distro is ubuntu/debian
     # you need to get ncurses and libedit library from debian
     # https://github.com/Sharktheone/arch-mojo/blob/main/src/install.py#L156
     if (or (not (has-env LD_LIBRARY_PATH)) (not (get-env LD_LIBRARY_PATH | str:contains (all) lib/mojo))) {
          set E:LD_LIBRARY_PATH = $E:XDG_LOCAL_HOME/lib/mojo:$E:LD_LIBRARY_PATH
     }
}

if (or (has-external rustup) (has-external rustc)) {
     set E:CARGO_HOME = (put $E:XDG_LOCAL_HOME | path:join (all) cargo)
     set-env RUSTUP_HOME (put $E:XDG_LOCAL_HOME | path:join (all) rustup)
     set-env PATH  (put $E:CARGO_HOME | path:join (all) bin | conj $paths (all) | str:join ':' (all))
}

if (has-external bun) {
     # prevent error on fresh install due to No package.json in bun/install/global
     var BUN_BINS~ = { if ?(bun pm bin -g) { echo (bun pm bin -g) } }
     set paths =  (put (BUN_BINS) | conj $paths (all))
} else {
     set E:BUN_INSTALL = $E:XDG_LOCAL_HOME/bun
     set paths =  (put $E:BUN_INSTALL | path:join (all) bin | conj $paths (all))
}

if (has-external go) {
     set E:GOPATH = (put $E:XDG_LOCAL_HOME | path:join (all) go)
     set-env GOBIN (put $E:GOPATH | path:join (all) bin)
     set-env PATH  (put $E:GOBIN | conj $paths (all) | str:join ':' (all))
}

if (has-external composer) {
   set E:COMPOSER_HOME = (put $E:XDG_LOCAL_HOME | path:join (all) composer)
   set paths =  (put $E:COMPOSER_HOME | path:join (all) vendor bin | conj $paths (all))
}

if (has-external vivid) {
    set-env LS_COLORS (vivid generate alabaster_dark) # alabaster_dark ayu catppuccin-latte iceberg-dark one-dark
}

if (has-external starship) {
  set E:STARSHIP_CONFIG = $E:DOTFILES/config/starship/starship.toml
  eval (starship init elvish)
}

if (has-external carapace) {
  # enable completions from these shells when completions aren't avilable in current shell
  set-env CARAPACE_BRIDGES 'zsh,fish,bash,inshellisense' 
  set-env CARAPACE_MATCH 1 # make completion matching case insensitive
  set-env CARAPACE_ENV 1 # enable environment variable completion
  set-env CARAPACE_LENIENT 1 # allow unknown flags
  eval (carapace _carapace | slurp)
}

set-env EDITOR (if (has-external hx) { which hx } else { which helix })

# Configure gpg pinentry to use the correct TTY
# To use the included Secure Shell Agent you need to start the gpg agent
set-env GPG_TTY (tty) ; gpg-connect-agent updatestartuptty /bye stderr>$os:dev-null stdout>&stderr

# dedup path list
set paths = [(put $paths | order (all) | compact)]
