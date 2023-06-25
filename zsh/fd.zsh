#!/bin/zsh

# https://quickref.me/find
# https://quickref.me/grep
# https://quickref.me/sed
# https://quickref.me/regex
# https://quickref.me/bash
# https://quickref.me/markdown
# https://quickref.me/mysql
# https://quickref.me/awk

fdn() {
    find * -name $1
}

fdsoon(){
find *  -name .git -prune -o -type f -print
find *  -name .git -prune -o -type d -print
find *  -name .git -prune -o -type f -print
find . -name "cat"
find . -name "cat" -v
find . -name "cat"
find --help
find -D help
find -D help help
find -D search
find -D time
find . -iname "cat"
find . -iregex "cat"
find . -iregex "*cat*"
find . -iregex "^cat*"
find . -iregex "^cat*"
find . -regex "^cat*"
find . -iregex "^cat*"
find . -iregex "out"
find . -iregex "out" -print
find . -iregex "out" -print
find . -iregex "out" -print
find . -iregex "out" .
find . -iregex "out"
find . -iregex "out"
find . -iregex "file3.txt"
find .
find . -iregex ".*file3.txt"
find . -iregex "*file3.txt"
find . -iregex ".*file3.txt"
help find
info find
info find
info find
info find
find . -regextype posix-extended -regex ".*cat.*"
find . -regextype posix-extended -iregex ".*cat.*"
find --help
find . -regextype posix-extended -iname "out"
find . -iname "out"
find . -iname "*cat*"
find . -regextype posix-extended -iregex "out"
find . -regextype posix-extended -iregex "out"
find . -regextype posix-extended -iregex ".*out.*"
find . -regextype posix-extended -iregex ".*out"
find . -regextype posix-extended -iregex ".*out.*"
find ./dir
find ./dir1
find ./dir1 -ls
grep --help
find -type f -type l dir
find -type f -type l dir1
find -type f -type l "dir1"
find . -type f -type l "dir1"
find . -type f -type l -iname "dir1"
find . -type f -type l -iname "cat"
find . -type f -iname "cat"
find . -type f -iname "cat*"
find . -type f -type l -iname "cat*"
find . -type f -type l -iname "cat*"
find . -type f -iname "cat*"
find . -maxdepth 1 -type d
find . -maxdepth 2 -type d
find . -type f -empty
find /var/log -iname "*~" -o -iname "*log*" -mtime +30
find /var/log -iname "*~" -o -iname "*log*" -mtime -30
find /var/log -iname "*~" -o -iname "*log*" -mtime 1
find /var/log -iname "*~" -o -iname "*log*" -mtime +1
find /var/log -iname "*~" -o -iname "*log*" -mtime -1
find /var/log -iname "*~" -o -iname "*log*" -mtime +1
find /var/log -iname "*~" -o -iname "*log*" -mmin +1
find /var/log -iname "*~" -o -iname "*log*" -mmin +1
find /var/log -iname "*~" -o -iname "*log*" -mtime -30 -ls
find ~/.cache/nvim/luac/ -mtime -2
find ~/.cache/nvim/luac/ -mtime +1
find ~/.cache/nvim/luac/ -mtime 1
find ~/.cache/nvim/luac/ -mtime -1
find ~/.cache/nvim/luac/ -mtime -1 -iregex ".*nvim.*"
find ~/.cache/nvim/luac/ -mtime -1 -iregex ".*config.*"
find ~/.cache/nvim/luac/ -mtime -1 -iregex ".*config.nvim.*"
find ~/.cache/nvim/luac/ -mtime -1 -iregex ".*config.nvim.*" -ls
z dot
find . -type d -user jack
find / -size +100M -size -1G
Find all php files in directory
find . -type f -name "*.php"
Find the files without permission 777.
find / -type f ! -perm 777
Find Read Only files.
find / -perm /u=r
find /home -group developer
 find . -type f \( -name "*.sh" -o -name "*.txt" \)
 find /opt /usr /var -name foo.scala -type f
 find . -type d -empty
 find . -type f -empty -delete

# atime 	access time (last time file opened)
# mtime 	modified time (last time file contents was modified)
# ctime 	changed time (last time file inode was changed)

# -mtime +0 	Modified greater than 24 hours ago
# -mtime 0 	Modified between now and 1 day ago
#
# -mtime -1 	Modified less than 1 day ago (same as -mtime 0)
# -mtime 1 	Modified between 24 and 48 hours ago
#
# -mtime +1w 	Last modified more than 1 week ago
# -ctime -6h30m 	File status changed within the last 6 hours and 30 minutes

find ./ -type f -readable -writable -exec sed -i "s/old/new/g" {} \;

#Find and suffix (added .bak)
find . -type f -name 'file*' -exec mv {} {}.bak\;
#Find and rename extension (.html => .gohtml)
find ./ -depth -name "*.html" -exec sh -c 'mv "$1" "${1%.html}.gohtml"' _ {} \;
#Merge all sorted csv files in the download directory into merged.csv
find download -type f -iname '*.csv' | sort | xargs cat > merged.csv

#Find files and set permissions to 644.
find / -type f -perm 0777 -print -exec chmod 644 {} \;

#Find directories and set permissions to 755.
find / -type d -perm 777 -print -exec chmod 755 {} \;
}
