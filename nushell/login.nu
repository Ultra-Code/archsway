export-env {
    let SSH_ENV_PATH = ($env.XDG_RUNTIME_DIR | path join ssh-agent.nuon)

    if  (ps | where name == 'ssh-agent' | is-empty) {
        # create ssh environment variables
        ^ssh-agent -t 1d -c | lines | first 2 | parse 'setenv {env} {value};'
            | transpose --header-row --as-record | save -f $SSH_ENV_PATH

        # load ssh environment variables
        open $SSH_ENV_PATH | load-env
    } else {
        open $SSH_ENV_PATH | load-env
    }

    # set XDG_CURRENT_DESKTOP
    $env.XDG_CURRENT_DESKTOP = river
}

if (tty) =~ "/dev/tty[1-3]" {
    # for sway's log output to be handled by journald
    # exec systemd-cat --identifier=sway sway

    # for rivers's log output to be handled by journald
    exec systemd-cat --identifier=river river
}
