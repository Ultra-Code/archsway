#!/bin/env elvish
use os
use path
use str
use flag

var ZIG_ROOT = $E:HOME/.local/zig
var BIN_DIR = $E:XDG_LOCAL_HOME/bin
var TMPDIR = /tmp/zig-update
var ZIG_JSON_URL = https://ziglang.org/download/index.json
var ARCH = x86_64-linux

fn start {
    if (not (os:is-dir $ZIG_ROOT)) {
        os:mkdir $ZIG_ROOT
        echo "Root directory "$ZIG_ROOT" has been created!"
    }
    if (not (os:is-dir $TMPDIR)) {
        os:mkdir $TMPDIR
    }
}

fn extract-info {|branch|
    var index = $TMPDIR/index.json
    # check if index hasn't change in about 70 min
    var check-index~ = { find $TMPDIR -maxdepth 1 -cmin +70 -path $index -type f }
    if (or (not (os:is-regular $index)) (str:contains (check-index | slurp) $index)) {
        try {
            curl -s $ZIG_JSON_URL stdout> $index
        } catch err {
            put $err
            echo "Failed to download the zig index.json"
        }
    }
    set index = (cat $index | from-json | put (all)[$branch][$ARCH])

    try {
        var tarball = $index[tarball]
        var basename = (path:base $tarball)
        var zig_version = (str:replace '.tar.xz' '' $basename)
        var new_zig_exe_name = (if (==s $branch "master") { put zig-dev } else { put zig-$branch })
        var new_zig_exe =  $BIN_DIR/$new_zig_exe_name
        var install_dir_link = $ZIG_ROOT/$new_zig_exe_name
        put [&tarball=$tarball &basename=$basename &zig_version=$zig_version ^
             &new_zig_exe=$new_zig_exe &install_dir_link=$install_dir_link]
    } catch err {
        put $err
        echo "failed to query repo"
    }
}

fn check-zig-version {|branch install_dir_link zig_version|
    if (and (os:exists &follow-symlink=$true $install_dir_link) ^
         (==s (os:eval-symlinks $install_dir_link) $ZIG_ROOT/$zig_version)) {
            echo $zig_version" is already the current version!"
            exit 0
    } else {
        if (==s $branch "master") {
            echo "Updating to "$zig_version
        } else {
            echo "Installing "$zig_version
        }
    }
}

fn update-symlink {|new_zig_exe install_dir_link zig_version|
    # update directory symlink
    if (and ?(os:stat $install_dir_link) (==s (os:stat $install_dir_link)[type] symlink)) {
        os:remove $install_dir_link
        os:symlink $ZIG_ROOT/$zig_version $install_dir_link
    } else {
        os:symlink $ZIG_ROOT/$zig_version $install_dir_link
    }
    # update zig file symlink
    if (and ?(os:stat $new_zig_exe) (==s (os:stat $new_zig_exe)[type] symlink)) {
        os:remove $new_zig_exe
        os:symlink $install_dir_link/zig $new_zig_exe
    } else {
        os:symlink $install_dir_link/zig $new_zig_exe
    }
}

fn update-zig {|tarball basename new_zig_exe install_dir_link zig_version|
    try { 
        find $ZIG_ROOT -maxdepth 1 -ctime +3 -type d ^
             -execdir rm -rf {} + stdout>/dev/null stderr>&stdout
    } catch err {  }
    try {
        echo "Downloading repository..."
        curl --output-dir $TMPDIR --remote-name  --continue-at - $tarball 
        echo "Extracting "$TMPDIR/$basename" to "$ZIG_ROOT
        bsdtar --directory $ZIG_ROOT --extract --xz --file $TMPDIR/$basename
        update-symlink $new_zig_exe $install_dir_link $zig_version
    } catch err {
        put $err
        echo "Update failed!"
        os:remove-all $ZIG_ROOT/$zig_version 
    }
}

fn check-and-update-zig-version {|branch tarball basename new_zig_exe install_dir_link zig_version|
    check-zig-version $branch $install_dir_link $zig_version
    update-zig $tarball $basename $new_zig_exe $install_dir_link $zig_version
}

fn finish {|new_zig_exe zig_version basename|
    echo "finished updating to "$zig_version
    echo "Current version is now: "($new_zig_exe version)
    os:remove-all $TMPDIR/$basename
}

fn set-default {|new_zig_exe zig_version|
    # set/update which binary is the default zig installation
    if (and ?(os:stat $new_zig_exe) (==s (os:stat $new_zig_exe)[type] symlink)) {
        os:remove $BIN_DIR/zig
        os:symlink $new_zig_exe $BIN_DIR/zig
        echo "default zig set to "$zig_version
    } else {
        fail "install zig before trying to set the default"
    }
}

var usage = ^
'zig-update [-branch master|0.11.0]
zig-update -default -branch master|0.11.0 
'

fn main {|&branch=master &default=$false|
    if $default {
        var info = (extract-info $branch)
        set-default $info[new_zig_exe] $info[zig_version]
        exit 0
    }
    start
    var info = (extract-info $branch)
    check-and-update-zig-version $branch $info[tarball] $info[basename] ^
        $info[new_zig_exe] $info[install_dir_link] $info[zig_version] 
    finish $info[new_zig_exe] $info[zig_version] $info[basename]
    set-default $info[new_zig_exe] $info[zig_version]
}

flag:call $main~ $args &on-parse-error={|_| print $usage; exit 1}
