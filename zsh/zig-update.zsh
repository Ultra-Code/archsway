#!/bin/zsh

ROOT=$HOME/Downloads/Compressed
REPO_URL=https://ziglang.org/download/index.json
TMPDIR=/tmp/zig-update

REPO_ENTRY=x86_64-linux

function die()
{
        echo $@
        rm -r $TMPDIR
        exit 1
}

        if [ ! -d $ROOT ]; then
        echo "Root directory $ROOT does not exist!"
        exit 1
fi

REPO=$TMPDIR/zig-repo.json

mkdir -p $TMPDIR

echo "Downloading repository..."

curl -s $REPO_URL | jq ".master[\"$REPO_ENTRY\"]" > $REPO || die "failed to aquire repo!"

TARBALL=$(jq --raw-output '.tarball' $REPO)
SHASUM=$(jq --raw-output '.shasum' $REPO)
SIZE=$(jq --raw-output '.size' $REPO)

VERSION=$(basename $TARBALL | sed 's/.tar.xz$//')

[ $VERSION != "" ] || die "Could not extract version info"

if [ -d $ROOT/$VERSION ]; then
        echo "$VERSION is already the current version!"
else
        echo "Updating to $VERSION"

        if curl $TARBALL | tar -xJC $ROOT; then

            if [ -h $ROOT/zig-current ]; then
                rm $ROOT/zig-current || die "failed to remove $ROOT/zig-current so that we can set new symlink!"
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

        else
                echo "Update failed!"
                rm -rf $ROOT/$VERSION
        fi
fi

echo "Current version is now: $(zig-dev version)"

rm -r $TMPDIR
