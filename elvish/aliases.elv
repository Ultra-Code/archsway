fn el { exec elvish }
edit:add-var el~ $el~

set edit:insert:binding[Alt-l] = { edit:clear }

fn ls {|@options_and_path|
  e:ls --color --classify $@options_and_path
}
edit:add-var ls~ $ls~

fn l {|@path| 
    ls --almost-all --format=long --human-readable --inode --ignore-backups --ignore=.git $@path 
}
edit:add-var l~ $l~

fn lh { ls --hyperlink . }
edit:add-var lh~ $lh~

fn lr { ls --recursive . }
edit:add-var lr~ $lr~

fn md {|path| mkdir --parents --verbose $path}
edit:add-var md~ $md~

fn mc {|path| mkdir --parents --verbose $path ; cd $path }
edit:add-var mc~ $mc~

fn rd {|path| rmdir --parents --verbose $path}
edit:add-var rd~ $rd~

fn rm {|@path| e:rm --interactive=once --verbose --recursive $@path}
edit:add-var rm~ $rm~

set edit:command-abbr['bat'] = 'bat --style=numbers,changes'

fn history-export {
  edit:command-history | peach {|hist| put $hist[cmd]} | order | compact | to-lines
}
edit:add-var history-export~ $history-export~

fn store-hist {
  history-export stdout> /tmp/history
  # https://stackoverflow.com/questions/29244351/how-to-sort-a-file-in-place#29244408
  order < $E:DOTFILES/elvish/history | compact | to-lines stdout> /tmp/oldhistory ; e:mv /tmp/oldhistory $E:DOTFILES/elvish/history
}

fn history-diff {
  store-hist
  # https://www.oreilly.com/library/view/bash-cookbook/0596526784/ch17s16.html
  # Show lines in current history which aren't in elvish/history
  comm -23 /tmp/history  $E:DOTFILES/elvish/history  
}  
edit:add-var history-diff~ $history-diff~

fn history-import {  
  use store
  store-hist
  # update current history with elvish/history
  var _ = ?(comm -23 $E:DOTFILES/elvish/history /tmp/history stdout> /tmp/diffhistory)
  cat /tmp/diffhistory | peach {|hist| store:add-cmd $hist}
}
edit:add-var history-import~ $history-import~

fn ncm { ncmpcpp }
edit:add-var ncm~ $ncm~

set edit:command-abbr['hx'] = 'helix'
set edit:command-abbr['Hx'] = 'sudo --preserve-env helix'

fn ln {|source destination| e:ln --interactive --symbolic --relative --logical --verbose $source $destination }
edit:add-var ln~ $ln~

fn cp {|source destination| e:cp --interactive --dereference --recursive --update --verbose --reflink=auto --sparse=auto --archive $source $destination}
edit:add-var cp~ $cp~

fn mv {|@source destination| e:mv --interactive --update --verbose $@source $destination}
edit:add-var mv~ $mv~
# right_format = "$memory_usage$os$localip$shell$shlvl$time"


#mounting and unmount drives without user password
fn mount {|point| sudo systemd-mount --no-block --fsck=no --collect --owner=$E:USER $point}
edit:add-var mount~ $mount~

fn umount {|point| sudo systemd-umount $point}
edit:add-var umount~ $umount~

fn lmount { sudo /bin/mount }
edit:add-var lmount~ $lmount~

fn lb { lsblk -oPATH,MOUNTPOINTS,LABEL,FSTYPE,SIZE,FSAVAIL,FSUSED,PARTUUID,MAJ:MIN }
edit:add-var lb~ $lb~

fn tarx {|archive| bsdtar -xvf $archive }
edit:add-var tarx~ $tarx~

fn tarv {|archive| bsdtar -tvf $archive }
edit:add-var tarv~ $tarv~

fn tarzip {|archive source| bsdtar --auto-compress --option --option="zip:compression=deflate" -cvf  $archive $source }
edit:add-var tarzip~ $tarzip~

fn targzip {|archive source| bsdtar --auto-compress --option="gzip:compression-level=9" -cvf  $archive $source}
edit:add-var targzip~ $targzip~

fn tarzst {|archive source| bsdtar --auto-compress --option="zstd:compression-level=22,zstd:threads=0" -cvf  $archive $source}
edit:add-var tarzst~ $tarzst~

fn tarxz {|archive source| bsdtar --auto-compress --option="xz:compression-level=9,xz:threads=0" -cvf $archive $source }
edit:add-var tarxz~ $tarxz~

fn du { e:du -h -d 1 }
edit:add-var du~ $du~

fn ee { (external $E:EDITOR) $E:ELVRC/rc.elv }
edit:add-var ee~ $ee~

fn ea { (external $E:EDITOR) $E:ELVRC/aliases.elv }
edit:add-var ea~ $ea~

fn er { (external $E:EDITOR) $E:DOTFILES/river/init }
edit:add-var er~ $er~

#Pacman aliases
fn pmu { sudo pacman -Syu }
edit:add-var pmu~ $pmu~

set edit:command-abbr['pmr'] = 'sudo pacman -Rsn'
set edit:command-abbr['pmi'] = 'sudo pacman -S'
set edit:command-abbr['pmp'] = 'sudo pacman -Rcunsv'
set edit:command-abbr['pmii'] = 'sudo pacman -Qii'
set edit:command-abbr['pmis'] = 'sudo pacman -Qs'
set edit:command-abbr['pmsi'] = 'pacman -Sii'
set edit:command-abbr['pmss'] = 'pacman -Ss'
set edit:command-abbr['pmsf'] = 'pacman -F'
set edit:command-abbr['pml'] = 'pacman -Qe'
set edit:command-abbr['pmlf'] = 'pacman -Ql'
set edit:command-abbr['pmlfr'] = 'pacman -Fl'
set edit:command-abbr['pmly'] = 'pacman -Qmq'
set edit:command-abbr['pmb'] = 'pacman -Qo'

fn pms {|package|
    try {
     pacman -Qs '^'$package 
    } catch err {
      try {
        pacman -F $package
      } catch err {
        try {
          pacman -Ss '^'$package
        } catch err {
          var err = $err[reason]
          echo $err[cmd-name]" exited with "$err[exit-status]": package "$package" not found in default repo"
        }
      }     
    }
  }
edit:add-var pms~ $pms~

fn pmc { sudo pacman -Qdtq| sudo pacman -Rsn - }
edit:add-var pmc~ $pmc~

fn pmcc { sudo pacman -Sc }
edit:add-var pmcc~ $pmcc~

#Git aliases
fn gp { git push }
edit:add-var gp~ $gp~

fn gs { git status -s }
edit:add-var gs~ $gs~

fn gst { git status }
edit:add-var gst~ $gst~

fn gpu { git pull }
edit:add-var gpu~ $gpu~

fn gl { git log --graph --oneline --decorate }
edit:add-var gl~ $gl~

fn glp { git log -p }
edit:add-var glp~ $glp~

fn glt { git log --stat -1 }
edit:add-var glt~ $glt~

fn gmlp { git log --submodule -p }
edit:add-var gmlp~ $gmlp~

fn gmi { git submodule update --init --recursive }
edit:add-var gmi~ $gmi~

fn gmu { git submodule update --remote --rebase }
edit:add-var gmu~ $gmu~

fn gd {|@path| git diff $@path | bat --style=numbers,changes }
edit:add-var gd~ $gd~

set edit:command-abbr['gcl'] = 'git clone --recurse-submodules'
set edit:command-abbr['gc'] = 'git commit'
set edit:command-abbr['ga'] = 'git add'
set edit:command-abbr['glf'] = 'git log --follow -p'
set edit:command-abbr['gg'] = 'git grep --recurse-submodules -I'
set edit:command-abbr['gm'] = 'git mv'
set edit:command-abbr['grm'] = 'git rm -r'
set edit:command-abbr['gsh'] = 'git show'

fn a2l {|@argv|
  addr2line --functions --inlines --pretty-print --demangle --exe $argv[0] --addresses $argv[1..]
 }
edit:add-var a2l~ $a2l~

fn zr {|@exe_options|
    if (has-external zig) { 
         zig build run -- $@exe_options
     } else { 
        echo 'install zig on your system'
     }
 }
edit:add-var zr~ $zr~

set edit:command-abbr['zb'] = 'zig build -Doptimize=ReleaseFast'
