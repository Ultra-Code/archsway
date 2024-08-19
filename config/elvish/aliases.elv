use store
use path
use os

fn el { exec elvish }
edit:add-var el~ $el~

fn hx {|@files| $E:EDITOR $@files }
edit:add-var hx~ $hx~

fn Hx {|@files| sudo --preserve-env $E:EDITOR $@files }
edit:add-var Hx~ $Hx~

fn bunx {|@options| e:bunx --bun $@options }
edit:add-var bunx~ $bunx~

fn bun {|@options| e:bun --bun $@options }
edit:add-var bun~ $bun~

set edit:insert:binding[Alt-l] = { edit:clear }

set edit:command-abbr['bat'] = 'bat --style=numbers,changes'

fn sort-inplace {|file|
  order < $file | compact | to-lines stdout> $E:PREFIX/tmp/sort
  e:mv $E:PREFIX/tmp/sort (path:abs $file)
}
edit:add-var sort-inplace~ $sort-inplace~

fn history-export {
  edit:command-history | peach {|hist| put $hist[cmd]} | order | compact | to-lines
}
edit:add-var he~ $history-export~

fn store-hist {
  history-export stdout> $E:PREFIX/tmp/history
  # https://stackoverflow.com/questions/29244351/how-to-sort-a-file-in-place#29244408
  sort-inplace $E:ELVRC/history
}

fn history-diff {
  store-hist
  # https://www.oreilly.com/library/view/bash-cookbook/0596526784/ch17s16.html
  # comm -23 /tmp/history  $E:ELVRC/history
  # NOTE: comm works only with the external sort command
  # Show lines in /tmp/history(current history) which aren't in elvish/history(old history)
  e:grep -Fxvf $E:ELVRC/history $E:PREFIX/tmp/history
}  
edit:add-var hd~ $history-diff~

fn history-import {  
  store-hist
  # update current history with updated elvish/history
  if ?(e:grep -Fxvf $E:PREFIX/tmp/history $E:ELVRC/history stdout> $E:PREFIX/tmp/diffhistory) {
     cat $E:PREFIX/tmp/diffhistory | peach {|hist| store:add-cmd $hist}
  } else {
    echo "Current history is up to date"
  }
}
edit:add-var hi~ $history-import~

fn hu { edit:history:fast-forward }
edit:add-var hu~ $hu~

fn diff {|file reference|
  e:diff --report-identical-files --side-by-side --suppress-common-lines ^
  --expand-tabs --suppress-blank-empty --minimal --speed-large-files ^
  --color=always $file $reference
}
edit:add-var diff~ $diff~

fn ls {|@options_and_path|
  e:ls --color=always --hyperlink=always --classify $@options_and_path
}
edit:add-var ls~ $ls~

fn l {|@path|
  var @gitignore = (if (os:exists .gitignore) { cat .gitignore } else { echo })
  ls --almost-all --format=long --human-readable --inode --ignore-backups ^
  --ignore=.git --ignore=$@gitignore $@path
}
edit:add-var l~ $l~

set edit:command-abbr["lh"] = "ls --hyperlink"
set edit:command-abbr["lr"] = "ls --recursive"
set edit:abbr["less"] = "less -R"

fn md {|@path| mkdir --parents --verbose $@path }
edit:add-var md~ $md~

fn mc {|path| md $path ; cd $path }
edit:add-var mc~ $mc~

fn rd {|path| rmdir --parents --verbose $path}
edit:add-var rd~ $rd~

fn rm {|@path| e:rm --interactive=once --verbose --recursive $@path }
edit:add-var rm~ $rm~

fn Rm {|@path| sudo rm $@path }
edit:add-var Rm~ $Rm~

fn ln {|@source destination|
  e:ln --interactive --symbolic --relative --verbose $@source $destination
}
edit:add-var ln~ $ln~

fn Ln {|@source destination| sudo ln $@source $destination }
edit:add-var Ln~ $Ln~

fn cp {|@source destination|
  e:cp --interactive --dereference --recursive --verbose --reflink=auto ^
  --sparse=auto --archive $@source $destination
}
edit:add-var cp~ $cp~

fn Cp {|@source destination| sudo cp $@source $destination }
edit:add-var Cp~ $Cp~

fn mv {|@source destination|
  e:mv --interactive --update --debug $@source $destination
}
edit:add-var mv~ $mv~

fn Mv {|@source destination| sudo mv $@source $destination }
edit:add-var Mv~ $Mv~

fn lb {
  lsblk -oPATH,MOUNTPOINTS,LABEL,FSTYPE,SIZE,FSAVAIL,FSUSED,PARTUUID,MAJ:MIN
}
edit:add-var lb~ $lb~

fn grep {|@regex|
  e:grep --extended-regexp --color=always --ignore-case $@regex
}
edit:add-var grep~ $grep~

# implement underline for grep
# fn mg {|@args|
#   kitten hyperlinked_grep --smart-case $@args
# }
# edit:add-var mg~ $mg~

fn icat {|file| kitten icat $file }
edit:add-var icat~ $icat~

# respects gitignore and skip hidden files and cache directories
fn rg {|regex @options|
  var @gitignore = (if (os:exists .gitignore) { cat .gitignore } else { echo })
  e:grep --perl-regexp --only-matching --color=always --ignore-case ^
  --line-number --recursive --binary-files=without-match --exclude=".*" ^
  --exclude=$@gitignore --exclude-dir=$@gitignore --exclude-dir=".git" ^
  --exclude-dir="*cache*" --regexp $regex $@options
}
edit:add-var rg~ $rg~

fn sed {|file| sed --regexp-extended --silent --in-place=.bak $file }
edit:add-var sed~ $sed~

fn tarx {|archive @files| bsdtar -xvf $archive $@files }
edit:add-var tarx~ $tarx~

fn tarv {|archive| bsdtar -tvf $archive }
edit:add-var tarv~ $tarv~

fn tarzip {|archive @source|
  bsdtar --auto-compress --option --option="zip:compression=deflate" ^
  -cvf  $archive $@source
}
edit:add-var tarzip~ $tarzip~

fn targzip {|archive @source|
  bsdtar --auto-compress --option="gzip:compression-level=9" -cvf  $archive ^
  $@source
}
edit:add-var targzip~ $targzip~

fn tarzst {|archive @source|
  bsdtar --auto-compress --option="zstd:compression-level=22,zstd:threads=0" ^
  -cvf  $archive $@source
}
edit:add-var tarzst~ $tarzst~

fn tarxz {|archive @source|
  bsdtar --auto-compress --option="xz:compression-level=9,xz:threads=0" ^
  -cvf $archive $@source
}
edit:add-var tarxz~ $tarxz~

fn du {|@file| e:du -h -d 1 $@file }
edit:add-var du~ $du~

fn ee { $E:EDITOR $E:ELVRC/env.elv }
edit:add-var ee~ $ee~

fn eh { $E:EDITOR $E:ELVRC/history }
edit:add-var eh~ $eh~

fn ea { $E:EDITOR $E:ELVRC/aliases.elv }
edit:add-var ea~ $ea~

fn rc { $E:EDITOR $E:ELVRC/rc.elv }
edit:add-var rc~ $rc~

fn er { $E:EDITOR $E:DOTFILES/config/river/init.zig }
edit:add-var er~ $er~

fn pacman {|@args|
    try {
      e:pacman $@args stderr>$os:dev-null
    } catch err {
      if (has-external yay) {
          var is_ok = ?(yay $@args)
          if (not (put $is_ok)) {
            fail $is_ok
          }
        } else {
          fail $err
        }
    }
}
edit:add-var pacman~ $pacman~

#pacman aliases
set edit:command-abbr['pmi'] = 'pacman -S'
set edit:command-abbr['pmp'] = 'pacman -Rcunsv'
set edit:command-abbr['pmii'] = 'pacman -Qii'
set edit:command-abbr['pmsi'] = 'pacman -Sii'

fn pml { pacman -Qe }
edit:add-var pml~ $pml~

fn pmu { pacman -Syu }
edit:add-var pmu~ $pmu~

fn pmlr { pacman -Qmq }
edit:add-var pmlr~ $pmlr~

fn pmlf {|package|
  try {
    pacman -Ql $package stderr>$os:dev-null
  } catch err {
    try {
      pacman -Fl $package
    } catch err {
      var reason = $err[reason]
      echo (styled $reason[cmd-name] red)" exited with "(styled $reason[exit-status] red)": could not list files for the package "(styled $package blue)
    }
  }
}
edit:add-var pmlf~ $pmlf~

fn pmb {|file|
  if (has-external $file) {
    set file = (which $file)
  }
  if (and (path:is-abs $file) (os:exists &follow-symlink=$true $file)) {
    try {
      pacman -Qo $file
    } catch err {
      var reason = $err[reason]
      echo (styled $reason[cmd-name] red)" exited with "(styled $reason[exit-status] red)": could not find the package which owns "(styled $file blue)
    }
  } else {
    fail "requires the full path to the file you want to find the package it belongs to"
  }
}
edit:add-var pmb~ $pmb~

# https://github.com/elves/elvish/issues/1775
fn pmc { pacman -Rsn (pacman -Qdtq) }
edit:add-var pmc~ $pmc~

fn pmcc { pacman -Sc }
edit:add-var pmcc~ $pmcc~

fn pms {|package|
  try {
     pacman -Qs $package
    } catch err {
      try {
        pacman -Fx $package
      } catch err {
        try {
          pacman -Ss $package
        } catch err {
          var reason = $err[reason]
          echo (styled $reason[cmd-name] red)" exited with "(styled $reason[exit-status] red)": package `"(styled $package blue)"` not found in default repo"
        }
      }     
    }
}
edit:add-var pms~ $pms~

#Git aliases
set edit:command-abbr['gd'] = 'git diff'
set edit:command-abbr['gc'] = 'git commit'
set edit:command-abbr['gt'] = 'git tag -s'
set edit:command-abbr['ga'] = 'git add'
set edit:command-abbr['glf'] = 'git log --follow -p'
set edit:command-abbr['gg'] = 'git grep --recurse-submodules -I'
set edit:command-abbr['gmv'] = 'git mv'
set edit:command-abbr['grm'] = 'git rm -r'
set edit:command-abbr['gsh'] = 'git show'
set edit:command-abbr['gst'] = "git status"
set edit:command-abbr['glt'] = "git log --stat -1"
set edit:command-abbr['gsml'] = "git log --submodule -p"
set edit:command-abbr['gsmi'] = "git submodule update --init --recursive"
set edit:command-abbr['gsmr'] = "git submodule update --remote --rebase"

fn gl {|@commit_hash|
  if (eq $commit_hash []) {
    git log --graph --oneline --decorate
  } else {
   git show $@commit_hash
   # git diff $commit_hash[0]'~' $commit_hash[0]
  }
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
  git clone --filter=tree:0 $@repo
}
edit:add-var gcl~ $gcl~

fn encrypt {|in out|
  openssl enc -aes-256-cbc -pbkdf2 -iter 310000 -md sha256 -salt -in $in -out $out
}
edit:add-var encrypt~ $encrypt~

fn decrypt {|in out|
  openssl enc -aes-256-cbc -pbkdf2 -iter 310000 -md sha256 -salt -d -in $in -out $out
}
edit:add-var decrypt~ $decrypt~

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

fn objdump {|exe| e:objdump -drwC -Mintel $exe }
edit:add-var objdump~ $objdump~

fn update-mirrors {
  sudo reflector "@"$E:DOTFILES/etc/xdg/reflector/reflector.conf ^
  stdout>$os:dev-null stderr>$os:dev-null
 }
edit:add-var update-mirrors~ $update-mirrors~

fn fzt {|@path|
  $E:DOTFILES/fzf/fzt.sh $@path
}
edit:add-var fzt~ $fzt~

fn rgf {|@path|
  $E:DOTFILES/fzf/rgf.sh $@path
}
edit:add-var rgf~ $rgf~
