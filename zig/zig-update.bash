#!/bin/env bash

ROOT=$HOME/.local/zig
REPO_URL=https://ziglang.org/download/index.json
TMPDIR=/tmp/zig-update

REPO_ENTRY=x86_64-linux

REPO=$TMPDIR/zig-repo.json

function die()
{
        echo $@
        exit 1
}

function start()
{
    if [ ! -d $ROOT ]; then
        mkdir -p $ROOT
        echo "Root directory $ROOT has been created!"
    fi

    mkdir -p $TMPDIR

    echo "Downloading repository..."

}

start

function finish()
{
        echo $@
        echo "Current version is now: $(zig-dev version)"
        rm -r $TMPDIR
        exit 0
}

curl -s $REPO_URL | jq ".master[\"$REPO_ENTRY\"]" > $REPO || die "failed to aquire repo!"

TARBALL=$(jq --raw-output '.tarball' $REPO)
SHASUM=$(jq --raw-output '.shasum' $REPO)
SIZE=$(jq --raw-output '.size' $REPO)
BASENAME=$(basename $TARBALL)
VERSION=$( echo "$BASENAME" | sed 's/.tar.xz$//')

[[ $VERSION != "" ]] || die "Could not extract version info"

if  [[ $ROOT/zig-current  -ef $ROOT/$VERSION ]]; then
        echo "$VERSION is already the current version!"
else
        echo "Updating to $VERSION"

        if curl --output-dir $TMPDIR --remote-name  -C - $TARBALL && tar -C $ROOT -xJf $TMPDIR/$BASENAME; then

            if [ -h $ROOT/zig-current ]; then
                rm $ROOT/zig-current || die "failed to remove $ROOT/zig-current so that we can set new symlink!"

                find -O3 $ROOT -maxdepth 1 -mindepth 1 -ctime +3 -type d -execdir rm -rf {} + || die "failed to remove old zig master installation"

                ln -s $ROOT/$VERSION $ROOT/zig-current || die "failed to symlink $ROOT/$VERSION to $ROOT/zig-current!"
            else
                ln -s $ROOT/$VERSION $ROOT/zig-current || die "failed to set new symlink!"
            fi

            if [ -h $HOME/.local/bin/zig-dev ]; then
                rm $HOME/.local/bin/zig-dev || die "failed to remove symlink $HOME/.local/bin/zig-dev"
                ln -s $ROOT/zig-current/zig $HOME/.local/bin/zig-dev || die "failed to symlink $ROOT/zig-current/zig to ~/.local/bin/zig-dev!"
            else
                ln -s $ROOT/zig-current/zig $HOME/.local/bin/zig-dev || die "failed to set new symlink to ~/.local/bin/zig-dev!"
            fi

            finish "finished updating to $VERSION"

        else
                echo "Update failed!"
                rm -rf $ROOT/$VERSION
        fi
fi
