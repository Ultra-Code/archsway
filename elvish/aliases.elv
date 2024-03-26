use store
use path

fn el { exec elvish }
edit:add-var el~ $el~

set edit:command-abbr['df'] = 'doc:find'
set edit:command-abbr['ds'] = 'doc:show'

set edit:insert:binding[Alt-l] = { edit:clear }

set edit:abbr['ncm'] = 'ncmpcpp'

fn ls {|@options_and_path|
  e:ls --color --classify $@options_and_path
}
edit:add-var ls~ $ls~

fn l {|@path| 
    ls --almost-all --format=long --human-readable --inode --ignore-backups --ignore=.git $@path 
}
edit:add-var l~ $l~

set edit:command-abbr["lh"] = "ls --hyperlink"
set edit:command-abbr["lr"] = "ls --recursive"

fn md {|path| mkdir --parents --verbose $path}
edit:add-var md~ $md~

fn mc {|path| md $path ; cd $path }
edit:add-var mc~ $mc~

fn rd {|path| rmdir --parents --verbose $path}
edit:add-var rd~ $rd~

fn rm {|@path| e:rm --interactive=once --verbose --recursive $@path}
edit:add-var rm~ $rm~

fn grep {|@regex| e:grep --extended-regexp --color --ignore-case $@regex }
edit:add-var grep~ $grep~

fn rg {|regex| grep --line-number -I --exclude=".*" --exclude-dir=".git" --exclude-dir="*cache*" $regex }
edit:add-var rg~ $rg~

fn sed {|file| sed --regexp-extended --silent --in-place=.bak $file }
edit:add-var sed~ $sed~

set edit:abbr['bat'] = 'bat --style=numbers,changes'

fn sort-inplace {|file|
  order < $file | compact | to-lines stdout> /tmp/sort
  e:mv /tmp/sort (path:abs $file)
}
edit:add-var sort-inplace~ $sort-inplace~

fn history-export {
  edit:command-history | peach {|hist| put $hist[cmd]} | order | compact | to-lines
}
edit:add-var he~ $history-export~

fn store-hist {
  history-export stdout> /tmp/history
  # https://stackoverflow.com/questions/29244351/how-to-sort-a-file-in-place#29244408
  sort-inplace $E:DOTFILES/elvish/history
}

fn history-diff {
  store-hist
  # https://www.oreilly.com/library/view/bash-cookbook/0596526784/ch17s16.html
  # comm -23 /tmp/history  $E:DOTFILES/elvish/history
  # NOTE: comm works only with the external sort command
  # Show lines in /tmp/history(current history) which aren't in elvish/history(old history)
  grep -Fxvf $E:DOTFILES/elvish/history /tmp/history
}  
edit:add-var hd~ $history-diff~

fn history-import {  
  store-hist
  # update current history with updated elvish/history
  if ?(grep -Fxvf /tmp/history $E:DOTFILES/elvish/history stdout> /tmp/diffhistory) {
     cat /tmp/diffhistory | peach {|hist| store:add-cmd $hist}
  } else {
    echo "Current history is up to date"
  }
}
edit:add-var hi~ $history-import~

fn hu { edit:history:fast-forward }
edit:add-var hu~ $hu~

fn hx {|@files| $E:EDITOR $@files }
edit:add-var hx~ $hx~

fn Hx {|@files| sudo --preserve-env $E:EDITOR $@files}
edit:add-var Hx~ $Hx~

fn ln {|@source destination| e:ln --interactive --symbolic --relative --verbose $@source $destination }
edit:add-var ln~ $ln~

fn cp {|@source destination| e:cp --interactive --dereference --recursive --verbose --reflink=auto --sparse=auto --archive $@source $destination}
edit:add-var cp~ $cp~

fn mv {|@source destination| e:mv --interactive --update --verbose $@source $destination}
edit:add-var mv~ $mv~

#To mounting and unmount drives without user password use --owner=$E:USER
fn mount {|@point| sudo systemd-mount --no-block --fsck=no --collect  $@point}
edit:add-var mount~ $mount~

fn umount {|point| sudo systemd-umount $point}
edit:add-var umount~ $umount~

fn lmount { sudo /bin/mount }
edit:add-var lmount~ $lmount~

fn lb { lsblk -oPATH,MOUNTPOINTS,LABEL,FSTYPE,SIZE,FSAVAIL,FSUSED,PARTUUID,MAJ:MIN }
edit:add-var lb~ $lb~

fn tarx {|archive @files| bsdtar -xvf $archive $@files }
edit:add-var tarx~ $tarx~

fn tarv {|archive| bsdtar -tvf $archive }
edit:add-var tarv~ $tarv~

fn tarzip {|archive @source| bsdtar --auto-compress --option --option="zip:compression=deflate" -cvf  $archive $@source }
edit:add-var tarzip~ $tarzip~

fn targzip {|archive @source| bsdtar --auto-compress --option="gzip:compression-level=9" -cvf  $archive $@source}
edit:add-var targzip~ $targzip~

fn tarzst {|archive @source| bsdtar --auto-compress --option="zstd:compression-level=22,zstd:threads=0" -cvf  $archive $@source}
edit:add-var tarzst~ $tarzst~

fn tarxz {|archive @source| bsdtar --auto-compress --option="xz:compression-level=9,xz:threads=0" -cvf $archive $@source }
edit:add-var tarxz~ $tarxz~

fn du {|@file| e:du -h -d 1 $@file}
edit:add-var du~ $du~

fn ee { $E:EDITOR $E:ELVRC/rc.elv }
edit:add-var ee~ $ee~

fn ea { $E:EDITOR $E:ELVRC/aliases.elv }
edit:add-var ea~ $ea~

fn er { $E:EDITOR $E:DOTFILES/river/init }
edit:add-var er~ $er~

#Pacman aliases
set edit:abbr['pmu'] = "yay -Syu"
set edit:command-abbr['pmi'] = 'yay -S'
set edit:command-abbr['pmp'] = 'sudo pacman -Rcunsv'
set edit:command-abbr['pmii'] = 'pacman -Qii'
set edit:command-abbr['pmis'] = 'pacman -Qs'
set edit:command-abbr['pmsi'] = 'yay -Sii'
set edit:command-abbr['pmss'] = 'yay -Ss'
set edit:command-abbr['pmsf'] = 'yay -F'
set edit:command-abbr['pmlf'] = 'pacman -Ql'
set edit:command-abbr['pmlfr'] = 'yay -Fl'
set edit:command-abbr['pmly'] = 'pacman -Qmq'
# requires the full path to the file you want to find the package it belongs to
set edit:command-abbr['pmb'] = 'pacman -Qo'

fn pml { pacman -Qe }
edit:add-var pml~ $pml~

# https://github.com/elves/elvish/issues/1775
fn pmc { sudo pacman -Rsn (pacman -Qdtq) }
edit:add-var pmc~ $pmc~

fn pmcc { yay -Sc }
edit:add-var pmcc~ $pmcc~

fn pms {|package|
    try {
     yay -Qs '^'$package 
    } catch err {
      try {
        yay -F $package
      } catch err {
        try {
          yay -Ss '^'$package
        } catch err {
          var err = $err[reason]
          echo $err[cmd-name]" exited with "$err[exit-status]": package "$package" not found in default repo"
        }
      }     
    }
  }
edit:add-var pms~ $pms~

#Git aliases
set edit:command-abbr['gd'] = 'git diff'
set edit:command-abbr['gc'] = 'git commit'
set edit:command-abbr['ga'] = 'git add'
set edit:command-abbr['glf'] = 'git log --follow -p'
set edit:command-abbr['gg'] = 'git grep --recurse-submodules -I'
set edit:command-abbr['gm'] = 'git mv'
set edit:command-abbr['grm'] = 'git rm -r'
set edit:command-abbr['gsh'] = 'git show'
set edit:abbr['gst'] = "git status"
set edit:abbr['glt'] = "git log --stat -1"
set edit:abbr['gml'] = "git log --submodule -p "
set edit:abbr['gmi'] = "git submodule update --init --recursive"
set edit:abbr['gmi'] = "git submodule update --remote --rebase"

fn gl {
  git log --graph --oneline --decorate
}
edit:add-var gl~ $gl~

fn glp {
  git log -p
}
edit:add-var glp~ $glp~

fn gs {
  git status -s
}
edit:add-var gs~ $gs~

fn gp {
  git push
}
edit:add-var gp~ $gp~

fn gpu {
  git pull
}
edit:add-var gpu~ $gpu~

fn gcl {|@repo|
  git clone --filter=tree:0 --recurse-submodules --also-filter-submodules $@repo 
}
edit:add-var gcl~ $gcl~

set edit:command-abbr['zbr'] = 'zig build -Doptimize=ReleaseFast'
set edit:command-abbr['zb'] = 'zig build'

fn zr {|@exe_options|
    if (has-external zig) { 
         zig build run -- $@exe_options
     } else { 
        echo 'install zig on your system'
     }
 }
edit:add-var zr~ $zr~

fn z++ {|@args|
  if (has-external zig) {
     zig c++ -std=c++2b -fexperimental-library $@args
  } else {
     fail "install zig language compiler on your system" 
  }
}
edit:add-var z++~ $"z++~"

fn zcc {|@args|
  if (has-external zig) {
     zig cc -std=c2x $@args
  } else {
     fail "install zig language compiler on your system" 
  }
}
edit:add-var zcc~ $zcc~

fn a2l {|@argv|
  addr2line --functions --inlines --pretty-print --demangle --exe $argv[0] --addresses $argv[1..]
 }
edit:add-var a2l~ $a2l~
