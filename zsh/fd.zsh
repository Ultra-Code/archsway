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
emulate -LR zsh
    find * -name $1
}

function fdsoon(){
emulate -LR zsh
find *  -name .git -prune -o -type d -print
find . -name "cat"
find . -type f -iname "cat*"
find . -type f -empty -delete
find /var/log -iname "*~" -o -iname "*log*" -mmin +1
find /var/log -iname "*~" -o -iname "*log*" -mtime -30 -ls
find ~/.cache/nvim/luac/ -mtime -1 -iregex ".*config.nvim.*"
find ~/.cache/nvim/luac/ -mtime -1 -iregex ".*config.nvim.*" -ls
find . -iregex ".*file3.txt" -print
find . -regextype posix-extended -iregex ".*out.*"

#Find files by limiting the directory depth to search
find . -maxdepth 1 -type d
find . -maxdepth 2 -type d

find . -type d -user jack
find / -size +100M -size -1G
#Find files by size range
find /path -type f -size +1M -size -20M

#Find all php files in directory
find . -type f -name "*.php"

#Find the files without permission 777.
find / -type f ! -perm 777

#Find Read Only files.
find / -perm /u=r
find /home -group developer
find . -type f \( -name "*.sh" -o -name "*.txt" \)
find /opt /usr /var -name foo.scala -type f

# atime     access time (last time file opened)
# mtime     modified time (last time file contents was modified)
# ctime     changed time (last time file inode was changed)

# -mtime +0     Modified greater than 24 hours ago
# -mtime 0  Modified between now and 1 day ago
#
# -mtime -1     Modified less than 1 day ago (same as -mtime 0)
# -mtime 1  Modified between 24 and 48 hours ago
#
# -mtime +1w    Last modified more than 1 week ago
# -ctime -6h30m     File status changed within the last 6 hours and 30 minutes

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

##Find executable files
find /path/to/search -type f -executable

#Finding Broken Symlinks
find /path/to/search -follow -lname "*"

#Remove Empty Directories
find /path/to/search -type d -exec rmdir --ignore-fail-on-non-empty {} + ;

#Find files not belonging to firefox at a min depth of one
find . -maxdepth 1 -name .cache -prune -o -type f -not -user firefox
}
