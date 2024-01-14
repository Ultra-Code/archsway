alias l =  ls
alias _ = ^sudo
alias du = du --deref --max-depth 1

# Fs operations
alias md = mkdir --verbose
alias mv = mv --interactive --verbose
alias cp = cp --interactive --progress --recursive --verbose
alias rm = rm --interactive-once --recursive --verbose --trash

alias EDITOR = ^$env.EDITOR

# edit nushell env
alias ee = EDITOR ($nu.env-path)

# edit nushell config
alias ec = EDITOR ($nu.config-path)

# edit login
alias el = EDITOR ($nu.loginshell-path)

# edit nushell alias
alias ea = EDITOR ($nu.default-config-dir | path join alias.nu)

# edit history
alias eh = EDITOR ($nu.default-config-dir | path join history.txt)

# edit river config
alias er = EDITOR ($env.XDG_CONFIG_HOME | path join river/init)

#edit $XDG_CONFIG_HOME/sway/config
alias es = do { if ($env.WSL_DISTRO_NAME? | is-empty) {
    EDITOR ($env.DOTFILES | path join sway/config)
    } else {
    EDITOR ($env.DOTFILES | path join wsl/sway_config)
    }
}

# reload nushell
alias rn = exec nu

# nproc alias for nu
alias nproc = do {sys | get cpu | length}

def la [] {
    ls --all --long | select name user group type mode num_links inode
}

def lt [] {
    ls --all --long | select name type mode created modified accessed
}

def ls-old [option:string] {
    (
    ^ls --almost-all --color --classify --format=long --human-readable --inode --ignore-backups --ignore=.git $option |
       parse -r '(?P<mode>\S+)\s+(?P<perms>\S+)\s+(?P<nlinks>\d+)\s+(?P<owner>\S+)\s+(?P<group>\S+)\s+(?P<size>\d+(?:\.\d+)?)K?\s+(?P<date>\S+\s+\d+)\s+(?P<time_year>\d+:\d+|\d+)\s+(?P<target>.*)'
    )
}
alias lh = ls-old "--hyperlink"
alias lr = ls-old "--recursive"

alias ncm = ^ncmpcpp
alias bat = ^bat --style=changes

alias Vi = _ --preserve-env nvim
alias Fm = _ --preserve-env lf

alias ln = ^ln --interactive --symbolic --relative --logical --verbose
alias lnh = ^ln --interactive --logical --verbose

#
# Mounting and unmount drives without user password
alias mount = _ systemd-mount --no-block --fsck=no --collect --owner=$USER
alias umount = _ systemd-umount
alias lmount = _ /bin/mount
alias lb = ^lsblk -oPATH,MOUNTPOINTS,LABEL,FSTYPE,SIZE,FSAVAIL,FSUSED,PARTUUID,MAJ:MIN

#
# Tar compression/decompression operations
alias tarx = ^bsdtar -xvf
alias tarv = ^bsdtar -tvf
alias tarzip = ^bsdtar --auto-compress --option="zip:compression=deflate" -cvf
alias targzip = ^bsdtar --auto-compress --option="gzip:compression-level=9" -cvf
alias tarzst = ^bsdtar --auto-compress --option="zstd:compression-level=22,zstd:threads=0" -cvf
alias tarxz = ^bsdtar --auto-compress --option="xz:compression-level=9,xz:threads=0" -cvf

#
# # Pacman aliases
alias pmu = _ pacman -Syu
alias pmr = _ pacman -Rsn
alias pmi = _ pacman -S
alias pmp = sudo pacman -Rcunsv
def pmfi [] {
    ^pacman -Slq | fzf --multi --preview "pacman -Si {1}" | xargs -ro sudo pacman -S
}
def pmfr [] {
    ^pacman -Qq | fzf --multi --preview "pacman -Qi {1}" | xargs -ro sudo pacman -Rns
}
alias pmii = ^pacman -Qii
alias pmis = ^pacman -Qs

def pms [package:string] {
    let query = do { ^pacman -Qs ^($package) } | complete
    if not ($query.exit_code == 1) { print $query.stdout } else {
        let query = do { ^pacman -F $package } | complete
        if not ($query.exit_code == 1) { print $query.stdout } else {
            let query = do { ^pacman -Ss ^($package) } | complete
            if not ($query.exit_code == 1) { print $query.stdout } else { print $query.stderr }
        }
    }
}

alias pmsi = ^pacman -Sii
alias pmss = ^pacman -Ss
alias pmsf = ^pacman -F
alias pml = ^pacman -Qe
alias pmlf = ^pacman -Ql
alias pmlfr = ^pacman -Fl
alias pmly = ^pacman -Qmq
alias pmb = ^pacman -Qo
def pmc [] {
    _ pacman -Qdtq| _ pacman -Rsn -
}
alias pmcc = _ pacman -Sc

#
# #Git aliases
alias gp = ^git push
alias gs = ^git status -s
alias gst = ^git status
alias gcl = ^git clone --recurse-submodules
alias gc = ^git commit
alias ga = ^git add
alias gpu = ^git pull
alias gl = ^git log --graph --oneline --decorate
alias glp = ^git log -p
alias glt = ^git log --stat -1
alias glf = ^git log --follow -p
alias gmlp = ^git log --submodule -p
alias gd = ^git diff
alias gg = ^git grep --recurse-submodules -I
alias gm = ^git mv
alias gr = ^git rm -r
alias grf = ^git rm -rf
alias gmu = ^git submodule update --init --recursive
alias gmpu = ^git submodule update --remote --rebase
alias gsh = ^git show

#
# #Systemd services
alias enabled_services = ^systemctl list-unit-files --type=service --state=enabled
alias running_services = ^systemctl list-units  --type=service  --state=running
alias all_services = ^systemctl -at service

# Find symbols in an executable
def a2l [program_name:string, ...args:string] : nothing -> string {
    addr2line --functions --inlines --pretty-print --demangle --exe $program_name --addresses $args
}

# Zig
def zr [...arguments:string]: nothing -> nothing {
    if (not (which zig | is-empty )) {
        zig build run -- $arguments
    }
    else
        print 'install zig on your system'
    fi
}

def d [shell_stack_position?: int] -> nothing {
    if shell_stack_position == null {
        shells
    } else {
        g $shell_stack_position
    }
}

def testvivid [] {
    for theme in (^vivid themes | split row "\n" | drop 1) {
        print $"Theme: ($theme)"
        $env.LS_COLORS = $"(^vivid generate $theme | str trim)"
        ls | print
    }
}

# alias for -
# TODO: fix and make it work
alias '-' = cd -
#
# # Changing/making/removing directory
# alias ... = ../..
# alias .... = ../../..
# alias ..... = ../../../..
# alias ...... = ../../../../..
