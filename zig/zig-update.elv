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
    try {
        var output = (curl -s $ZIG_JSON_URL | from-json | put (all)[$branch][$ARCH])
        var tarball = $output[tarball]
        var basename = (path:base $tarball)
        var zig_version = (str:replace '.tar.xz' '' $basename)
        var new_zig_exe_name = (if (==s $branch "master") { put zig-dev } else { put zig-$branch })
        var new_zig_exe =  $BIN_DIR/$new_zig_exe_name
        var install_dir_link = $ZIG_ROOT/$new_zig_exe_name
        put $tarball $basename $zig_version $new_zig_exe $install_dir_link

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
        find -O3 $ZIG_ROOT -maxdepth 1 -ctime +3 -type d ^
             -execdir rm -rf {} + stdout>/dev/null stderr>&stdout
    } catch err { 
        echo "No old zig installations to clean" 
    }

    try {
        echo "Downloading repository..."
        curl --output-dir $TMPDIR --remote-name  --continue-at - $tarball 

        echo "Extracting "$TMPDIR/$basename" to "$ZIG_ROOT
        bsdtar --directory $ZIG_ROOT --extract --xz --option="xz:threads=0" ^
            --file $TMPDIR/$basename
      
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

fn finish {|new_zig_exe zig_version|
    echo "finished updating to "$zig_version
    echo "Current version is now: "($new_zig_exe version)
    os:remove-all $TMPDIR
}

var usage = ^
'zig-update [-branch master|0.11.0]
'
fn main {|&branch=master|
    start
    var tarball basename zig_version new_zig_exe install_dir_link = (extract-info $branch)
    check-and-update-zig-version $branch $tarball $basename $new_zig_exe $install_dir_link $zig_version 
    finish $new_zig_exe $zig_version
}
flag:call $main~ $args &on-parse-error={|_| print $usage; exit 1}
