def completer [name:string] nothing -> closure {
    let fish_completer = {|spans|
        ^fish --command $'complete "--do-complete=($spans | str join " ")"'
        | lines | parse -r '^(?P<value>\S+)\t(?P<description>.*)'
    }

    let zoxide_completer = {|spans|
        $spans | skip 1 | ^zoxide query -l ...$in | lines | where {|x| $x != $env.PWD} | path basename
    }

    let completers = {|spans: list<string>|
        ^carapace $spans.0 nushell ...$spans | from json
        | if ($in | default [] | where value =~ '^-.*ERR$' | is-empty) { if ($in | is-empty) { do $fish_completer $spans } else { $in } }
    }

    match $name {
    zoxide => $zoxide_completer
    rest => $completers
    }
}

export-env {
    $env.config.completions.external.completer = {|spans|
        if (which zoxide | is-empty) or (which carapace | is-empty) or (which fish | is-empty) {
             return
        }

        let expanded_alias = scope aliases | where name == $spans.0 | get -i expansion.0

        let spans = if $expanded_alias != null {
            $spans | skip 1 | prepend ($expanded_alias | split row ' ' | take 1 | str trim --left --char '^')
        } else {
            $spans
        }

        match $spans.0 {
            __zoxide_z | __zoxide_zi => (completer zoxide)
            _ => (completer rest)
        } | do $in $spans
    }
}
