#!/bin/env elvish
use os
use path
use str

var ZIG_ROOT = $E:HOME/.local/zig
var TMPDIR = /tmp/zig-update
var ZIG_JSON_URL = https://ziglang.org/download/index.json
var ARCH = x86_64-linux
var BRANCH = master
var NEW_ZIG_DIR = $ZIG_ROOT/zig-$BRANCH
var BIN_DIR = $E:XDG_LOCAL_HOME/bin
var FILENAME = (if (==s $BRANCH "master") { put zig-dev } else { put zig-$BRANCH })
var NEW_ZIG_EXE = $BIN_DIR/$FILENAME

fn start {
    if (not (os:is-dir $ZIG_ROOT)) {
        os:mkdir $ZIG_ROOT
        echo "Root directory "$ZIG_ROOT" has been created!"
    }

    if (not (os:is-dir $TMPDIR)) {
        os:mkdir $TMPDIR
    }
}

fn extract-info {
    try {
        var output = (curl -s $ZIG_JSON_URL | from-json | put (all)[$BRANCH][$ARCH])
        var tarball = $output[tarball]
        var basename = (path:base $tarball)
        var zig_version = (str:replace '.tar.xz' '' $basename)
        put $tarball $basename $zig_version

    } catch err {
        put $err
        echo "failed to query repo"
    }
}

fn check-and-update-zig-version {|tarball basename zig_version|
    if (and (os:exists &follow-symlink=$true $NEW_ZIG_DIR) (==s (os:eval-symlinks $NEW_ZIG_DIR) $ZIG_ROOT/$zig_version)) {

        echo $zig_version" is already the current version!"
    } else {
        echo "Updating to "$zig_version

        update-zig $tarball $basename $zig_version
    }
}

fn update-zig {|tarball basename zig_version|
    try {
        echo "Downloading repository..."

        curl --output-dir $TMPDIR --remote-name  --continue-at - $tarball 

        tar --directory $ZIG_ROOT --extract --xz --file $TMPDIR/$basename

        update-symlink $zig_version

        finish $zig_version

    } catch err {
        put $err
        echo "Update failed!"
        os:remove-all $ZIG_ROOT/$zig_version 
    }
}

fn update-symlink {|zig_version|
    fd . $ZIG_ROOT --max-depth 1 --type directory --older 3d  --exec-batch rm -rf {}

    # update directory symlink
    if (and ?(os:stat $NEW_ZIG_DIR) (==s (os:stat $NEW_ZIG_DIR)[type] symlink)) {
        os:remove $NEW_ZIG_DIR
        os:symlink $ZIG_ROOT/$zig_version $NEW_ZIG_DIR
    } else {
        os:symlink $ZIG_ROOT/$zig_version $NEW_ZIG_DIR
    }

    # update zig file symlink
    if (and ?(os:stat $NEW_ZIG_EXE) (==s (os:stat $NEW_ZIG_EXE)[type] symlink)) {
        os:remove $NEW_ZIG_EXE
        os:symlink $NEW_ZIG_DIR/zig $NEW_ZIG_EXE
    } else {
        os:symlink $NEW_ZIG_DIR/zig $NEW_ZIG_EXE
    }
}

fn finish {|zig_version|
    echo "finished updating to "$zig_version
    echo "Current version is now: "($NEW_ZIG_EXE version)
    os:remove-all $TMPDIR
}

start
var tarball basename zig_version = (extract-info)
check-and-update-zig-version $tarball $basename $zig_version
