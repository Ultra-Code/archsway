$env.config = ($env.config | upsert render_right_prompt_on_last_line true)

$env.POWERLINE_COMMAND = 'oh-my-posh'
$env.POSH_THEME = "/usr/share/oh-my-posh/themes/1_shell.omp.json"
$env.PROMPT_INDICATOR = ""
$env.POSH_PID = (random uuid)
$env.POSH_SHELL_VERSION = (version | get version)

def posh_cmd_duration [] {
    # We have to do this because the initial value of `$env.CMD_DURATION_MS` is always `0823`,
    # which is an official setting.
    # See https://github.com/nushell/nushell/discussions/6402#discussioncomment-3466687.
    if $env.CMD_DURATION_MS == "0823" { 0 } else { $env.CMD_DURATION_MS }
}

def posh_width [] {
    (term size).columns | into string
}

# PROMPTS
$env.PROMPT_MULTILINE_INDICATOR = (^"/usr/bin/oh-my-posh" print secondary $"--config=($env.POSH_THEME)" --shell=nu $"--shell-version=($env.POSH_SHELL_VERSION)")

$env.PROMPT_COMMAND = { ||
    # hack to set the cursor line to 1 when the user clears the screen
    # this obviously isn't bulletproof, but it's a start
    let clear = (history | last 1 | get -i 0.command) == "clear"

    ^"/usr/bin/oh-my-posh" print primary $"--config=($env.POSH_THEME)" --shell=nu $"--shell-version=($env.POSH_SHELL_VERSION)" $"--execution-time=(posh_cmd_duration)" $"--status=($env.LAST_EXIT_CODE)" $"--terminal-width=(posh_width)" $"--cleared=($clear)"
}

$env.PROMPT_COMMAND_RIGHT = { ||
    ^"/usr/bin/oh-my-posh" print right $"--config=($env.POSH_THEME)" --shell=nu $"--shell-version=($env.POSH_SHELL_VERSION)" $"--execution-time=(posh_cmd_duration)" $"--status=($env.LAST_EXIT_CODE)" $"--terminal-width=(posh_width)"
}

if "true" == "true" {
    $env.TRANSIENT_PROMPT_COMMAND = { ||
        ^"/usr/bin/oh-my-posh" print transient $"--config=($env.POSH_THEME)" --shell=nu $"--shell-version=($env.POSH_SHELL_VERSION)" $"--execution-time=(posh_cmd_duration)" $"--status=($env.LAST_EXIT_CODE)" $"--terminal-width=(posh_width)"
    }
}

if "false" == "true" {
    echo ""
}
