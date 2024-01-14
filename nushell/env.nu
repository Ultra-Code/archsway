# Nushell Environment Config File
#
# version = "0.88.1"
$env.EDITOR = nvim
$env.VISUAL = $env.EDITOR

def create_left_prompt [] {
    let home =  $nu.home-path

    # Perform tilde substitution on dir
    # To determine if the prefix of the path matches the home dir, we split the current path into
    # segments, and compare those with the segments of the home dir. In cases where the current dir
    # is a parent of the home dir (e.g. `/home`, homedir is `/home/user`), this comparison will
    # also evaluate to true. Inside the condition, we attempt to str replace `$home` with `~`.
    # Inside the condition, either:
    # 1. The home prefix will be replaced
    # 2. The current dir is a parent of the home dir, so it will be uneffected by the str replace
    let dir = (
        if ($env.PWD | path split | zip ($home | path split) | all { $in.0 == $in.1 }) {
            ($env.PWD | str replace $home "~")
        } else {
            $env.PWD
        }
    )

    let path_color = (if (is-admin) { ansi red_bold } else { ansi green_bold })
    let separator_color = (if (is-admin) { ansi light_red_bold } else { ansi light_green_bold })
    let path_segment = $"($path_color)($dir)"

    $path_segment | str replace --all (char path_sep) $"($separator_color)(char path_sep)($path_color)"
}

def create_right_prompt [] {
    # create a right prompt in magenta with green separators and am/pm underlined
    let time_segment = ([
        (ansi reset)
        (ansi magenta)
        (date now | format date '%x %X %p') # try to respect user's locale
    ] | str join | str replace --regex --all "([/:])" $"(ansi green)${1}(ansi magenta)" |
        str replace --regex --all "([AP]M)" $"(ansi magenta_underline)${1}")

    let last_exit_code = if ($env.LAST_EXIT_CODE != 0) {([
        (ansi rb)
        ($env.LAST_EXIT_CODE)
    ] | str join)
    } else { "" }

    ([$last_exit_code, (char space), $time_segment] | str join)
}

# Use nushell functions to define your right and left prompt
$env.PROMPT_COMMAND = {|| create_left_prompt }
# FIXME: This default is not implemented in rust code as of 2023-09-08.
$env.PROMPT_COMMAND_RIGHT = {|| create_right_prompt }

# The prompt indicators are environmental variables that represent
# the state of the prompt
$env.PROMPT_INDICATOR = {|| "> " }
$env.PROMPT_INDICATOR_VI_INSERT = {|| ": " }
$env.PROMPT_INDICATOR_VI_NORMAL = {|| "> " }
$env.PROMPT_MULTILINE_INDICATOR = {|| "::: " }

# If you want previously entered commands to have a different prompt from the usual one,
# you can uncomment one or more of the following lines.
# This can be useful if you have a 2-line prompt and it's taking up a lot of space
# because every command entered takes up 2 lines instead of 1. You can then uncomment
# the line below so that previously entered commands show with a single `🚀`.
# $env.TRANSIENT_PROMPT_COMMAND = {|| "🚀 " }
# $env.TRANSIENT_PROMPT_INDICATOR = {|| "" }
# $env.TRANSIENT_PROMPT_INDICATOR_VI_INSERT = {|| "" }
# $env.TRANSIENT_PROMPT_INDICATOR_VI_NORMAL = {|| "" }
# $env.TRANSIENT_PROMPT_MULTILINE_INDICATOR = {|| "" }
# $env.TRANSIENT_PROMPT_COMMAND_RIGHT = {|| "" }

# Specifies how environment variables are:
# - converted from a string to a value on Nushell startup (from_string)
# - converted from a value back to a string when running external commands (to_string)
# Note: The conversions happen *after* config.nu is loaded
$env.ENV_CONVERSIONS = {
    "PATH": {
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
    "Path": {
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
}

# Directories to search for scripts when calling source or use
# The default for this is $nu.default-config-dir/scripts
$env.NU_LIB_DIRS = [
    ($nu.default-config-dir | path join 'scripts') # add <nushell-config-dir>/scripts
]

# Directories to search for plugin binaries when calling register
# The default for this is $nu.default-config-dir/plugins
$env.NU_PLUGIN_DIRS = [
    ($nu.default-config-dir | path join 'plugins') # add <nushell-config-dir>/plugins
]

export-env {
    const task_path = ($nu.default-config-dir | path join task.nu)
    if not ( $task_path | path type) == file {
        print "setting up task.nu plugin"
        let filecontent = (http get https://raw.githubusercontent.com/nushell/nu_scripts/main/modules/background_task/task.nu
        | save $task_path
        )
        print "done setting up task.nu"
    }
    $env.NU_PLUGIN_DIRS = ($env.NU_PLUGIN_DIRS | prepend $task_path)
}

# Note the split row (char esep) step. We need to add it because in env.nu (untile env.nu and config.nu are evaluated),
# the environment variables inherited from the host process are still strings so we convert it into a list of strings
$env.PATH = ($env.PATH | split row (char env_sep))

let local_bin = ($nu.home-path | path join .local/bin)

$env.PATH = (if not ($local_bin in $env.PATH) { ($env.PATH | prepend $local_bin) } else { $env.PATH })

# Add lscolors for colorful ls display
# use ($nu.default-config-dir | path join lscolors.nu)

export-env {
    if not ($nu.default-config-dir | path join lscolors.nu | path type) == file {
        print "setting up LS_COLORS"
        let LS_COLORS = (http get https://github.com/trapd00r/LS_COLORS/blob/master/lscolors.sh | from json
        | get payload.blob.rawLines.0 | str substring 10.. | str trim --right --char ';'
        | save ($nu.default-config-dir | path join lscolors.nu)
        )
        print "done setting up LS_COLORS"
    }
    load-env {
          LS_COLORS : (open ($nu.default-config-dir | path join lscolors.nu))
    }
}

export-env {
    load-env {
        XDG_CACHE_HOME: ($env.HOME | path join .cache)
        XDG_CONFIG_HOME: ($env.HOME | path join .config)
        XDG_LOCAL_HOME: ($env.HOME | path join .local)
    }

    load-env {
        DOTFILES: ($env.XDG_CONFIG_HOME | path join dotfiles)
        XDG_DATA_HOME: ($env.XDG_LOCAL_HOME | path join share)
        XDG_STATE_HOME: ($env.XDG_LOCAL_HOME | path join state)
    }

    load-env {
        FZF_DEFAULT_COMMAND: '^find * -name ".*" -prune -or -type f -print'
        FZF_DEFAULT_OPTS: '--multi --cycle --height=60% --layout=reverse --border=none --info=inline --ansi'
        FZF_CTRL_T_COMMAND: '^find * -regex ".+\.\w+.+$" -prune -or -print'
        FZF_CTRL_T_OPTS: '--border=rounded'
        FZF_ALT_C_OPTS: '--border=rounded --preview="ls --recursive --color=always {}"'
        FZF_COMPLETION_OPTS: '--border --info=inline'
        FZF_COMPLETION_TRIGGER: '~~'
        GTK_THEME: 'Adwaita:dark'
        QT_STYLE_OVERRIDE: 'Adwaita-dark'
        MANPAGER: $"($env.SHELL) -c 'col --no-backspaces --spaces | bat -l man --plain'"
        MANROFFOPT: '-c'
    }

    if (which rustc | get command.0?) == rustc {
        $env.CARGO_HOME = ($env.XDG_LOCAL_HOME | path join cargo)
        load-env {
            RUSTUP_HOME: ($env.XDG_LOCAL_HOME | path join rustup)
            PATH: ($env.PATH | prepend ($env.CARGO_HOME | path join bin))
        }
    }

    if (which composer | get command.0?) == composer {
        $env.COMPOSER_HOME = ($env.XDG_LOCAL_HOME | path join composer)
        load-env {
            PATH: ($env.PATH | prepend ($env.COMPOSER_HOME | path join vendor bin))
        }
    }
}

# $env.XDG_CURRENT_DESKTOP = 'sway'
# $env.ZDOTDIR = '/firefox/home/.config/dotfiles/zsh'
# $env.ZSH_ALIASES = '/firefox/home/.config/dotfiles/zsh/.zsh_aliases'

# oh-my-posh environment setup
# (oh-my-posh init nu --config /usr/share/oh-my-posh/themes/1_shell.omp.json --print |
#     save --force ($nu.default-config-dir | path join ohmyposh.nu)
# )
# zoixde environment setup
# TODO: remove 'str replace' filter after zoxide next release which fixes this syntax error
# zoxide init nushell | str replace "def-env" "def --env" --all | str replace "cd" "enter" --all | save -f ($nu.default-config-dir | path join zoxide.nu)

# carapace _carapace nushell | save --force ~/.cache/carapace/init.nu

$env.PATH = ($env.PATH | uniq)