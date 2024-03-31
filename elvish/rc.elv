use os
use re
use str

use ./env

# Automatically run river window manager on virtual terminal tty 1-3
# On other ttys you must run manually with the tty option
fn start-river {|&tty=$false|
     if (or (re:match "/dev/tty[1-3]" (tty)) $tty) {
        # for river's log output to be handled by journald
          if (and (has-external river) (os:eval-symlinks $E:XDG_CONFIG_HOME/river/init | os:is-regular (all))) {
             # set XDG_CURRENT_DESKTOP
               set E:XDG_CURRENT_DESKTOP = river
     
               var deps = [&vivid="for ls colors" &starship="for prompt customization" &carapace="for shell completions" 
               &kitty="as a terminal" &waylock="for screen lock" &fuzzel="as menu launcher" &swayidle="for wm idle state management"
               &wbg="for background image" &wlsunset="for night light/blue light management" &cliphist="for clipboard history" 
               &wl-paste="for copy/pasting" &grim="for screenshots" &slurp="for region slection during screenshots"
               &mpc="for music player keys control" &brightnessctl="for screen brightness control"]

               var optional_deps = [&batsignal="for battery status notification" &kanshi="for automatic output management" 
               &lf="as a file explore" &swaynag="for interactive section" &lswt="for listing wayland windows with their attributes"]

               for package [(keys $deps)] {
                    if (not (has-external $package)) {
                         fail $package" is required "$deps[$package]
                    }
               }
               for package [(keys $optional_deps)] {
                    if (not (has-external $package)) {
                         echo $package" is optionally required "$optional_deps[$package]
                    }
               }
               if (not (os:is-regular /usr/share/sounds/freedesktop/stereo/screen-capture.oga)) {
                    echo "sound-them-freedesktop package is optionally required"
               }

               exec systemd-cat --identifier=river river -no-xwayland
        } else {
               echo "Either river is not installed or found in $E:PATH"
               echo "Also make sure that your river config is located at $E:XDG_CONFIG_HOME/river/init"
        }
     }
}
edit:add-var start-river~ $start-river~

start-river

# elvish limited vi editing mode
set edit:insert:binding[Ctrl-'['] = $edit:command:start~

# https://elv.sh/ref/language.html#exception
if (not ?(pgrep -u $E:USER ssh-agent)) {
     ssh-agent -t 1d -c  | slurp | str:replace setenv set-env (all) | to-lines | take 2 | to-lines | slurp | print (all) > $E:XDG_RUNTIME_DIR/ssh-agent.env 
     cat $E:XDG_RUNTIME_DIR/ssh-agent.env | slurp | eval (all)
}

if (not ?(test -S $E:SSH_AUTH_SOCK)) {
     cat $E:XDG_RUNTIME_DIR/ssh-agent.env | slurp | eval (all)
}

use ./aliases
