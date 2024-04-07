#!/bin/bash

function finish() {
  result=$?
  # Your cleanup code here
  exit ${result}
}
trap finish EXIT ERR

if ! command -v rsync &>/dev/null; then
	echo "rsync is needed for firefox profile on ram"
	exit 255
fi

#Clears the Internal Field Separator (IFS) variable for the current shell environment
#Thereby removing default word-splitting behavior
IFS=

set -o errexit   # abort on nonzero exitstatus
set -o noglob    # Disable pathname expansion
set -o nounset   # abort on unbound variable
set -o pipefail  # don't hide errors within pipes
set -o noclobber # not overwrite an existing file redirection operators
set -o errtrace

cd ~/.mozilla/firefox || exit

profile=7ffqcodd.default-release

if ! test -L $profile || ! test -d $profile ; then
	echo "Firefox profile  $(pwd)${profile} doesn't exist"
	echo "exec 'find -O3 . -maxdepth 1 -iregex ".+release$" -type l -or -type d | cut --characters 3-' and replace '$profile' with the result"
	profile=$(find -O3 . -maxdepth 1 -iregex ".+release$" -type l -or -type d | cut --characters 3-)
fi

static=$profile-static
volatile=/dev/shm/firefox-$profile-$USER

if ! test -r "$volatile" ; then
	mkdir -m0700 "$volatile"
fi

if [ "$(readlink "$profile")" != "$volatile" ]; then
	mv "$profile" "$static"
	ln -s "$volatile" "$profile"
fi

if test -e "$profile"/.unpacked ; then
	rsync --archive --verbose --delete --exclude .unpacked ./"$profile"/ ./"$static"/
else
	rsync --archive --verbose ./"$static"/ ./"$profile"/
	touch "$profile"/.unpacked
fi

# catch signals and exit
# trap exit SIGINT SIGTERM EXIT
# main "$@"
