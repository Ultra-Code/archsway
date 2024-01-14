# For more information on defining custom themes, see
# https://www.nushell.sh/book/coloring_and_theming.html
# And here is the theme collection
# https://github.com/nushell/nu_scripts/tree/main/themes

# Define your colors

const base16_colors = {
    base00 : "#181818" # Default Background
    base01 : "#282828" # Lighter Background (Used for status bars, line number and folding marks)
    base02 : "#383838" # Selection Background
    base03 : "#585858" # Comments, Invisibles, Line Highlighting
    base04 : "#b8b8b8" # Dark Foreground (Used for status bars)
    base05 : "#d8d8d8" # Default Foreground, Caret, Delimiters, Operators
    base06 : "#e8e8e8" # Light Foreground (Not often used)
    base07 : "#f8f8f8" # Light Background (Not often used)
    base08 : "#ab4642" # Variables, XML Tags, Markup Link Text, Markup Lists, Diff Deleted
    base09 : "#dc9656" # Integers, Boolean, Constants, XML Attributes, Markup Link Url
    base0a : "#f7ca88" # Classes, Markup Bold, Search Text Background
    base0b : "#a1b56c" # Strings, Inherited Class, Markup Code, Diff Inserted
    base0c : "#86c1b9" # Support, Regular Expressions, Escape Characters, Markup Quotes
    base0d : "#7cafc2" # Functions, Methods, Attribute IDs, Headings
    base0e : "#ba8baf" # Keywords, Storage, Selector, Markup Italic, Diff Changed
    base0f : "#a16946" # Deprecated, Opening/Closing Embedded Language Tags, e.g. <?php ?>
}

# we're creating a theme here that uses the colors we defined above.

const base16_theme = {
    separator: $base16_colors.base03
    leading_trailing_space_bg: $base16_colors.base04
    header: $base16_colors.base0b
    date: $base16_colors.base0e
    filesize: $base16_colors.base0d
    row_index: $base16_colors.base0c
    bool: $base16_colors.base08
    int: $base16_colors.base0b
    duration: $base16_colors.base08
    range: $base16_colors.base08
    float: $base16_colors.base08
    string: $base16_colors.base04
    nothing: $base16_colors.base08
    binary: $base16_colors.base08
    cellpath: $base16_colors.base08
    hints: dark_gray

    # shape_garbage: { fg: $base16_colors.base07 bg: $base16_colors.base08 attr: b} # base16 white on red
    # but i like the regular white on red for parse errors
    shape_garbage: { fg: "#FFFFFF" bg: "#FF0000" attr: b}
    shape_bool: $base16_colors.base0d
    shape_int: { fg: $base16_colors.base0e attr: b}
    shape_float: { fg: $base16_colors.base0e attr: b}
    shape_range: { fg: $base16_colors.base0a attr: b}
    shape_internalcall: { fg: $base16_colors.base0c attr: b}
    shape_external: $base16_colors.base0c
    shape_externalarg: { fg: $base16_colors.base0b attr: b}
    shape_literal: $base16_colors.base0d
    shape_operator: $base16_colors.base0a
    shape_signature: { fg: $base16_colors.base0b attr: b}
    shape_string: $base16_colors.base0b
    shape_filepath: $base16_colors.base0d
    shape_globpattern: { fg: $base16_colors.base0d attr: b}
    shape_variable: $base16_colors.base0e
    shape_flag: { fg: $base16_colors.base0d attr: b}
    shape_custom: {attr: b}
}

const dark_theme = {
    # color for nushell primitives
    separator: white
    leading_trailing_space_bg: { attr: n } # no fg, no bg, attr none effectively turns this off
    header: green_bold
    empty: blue
    # Closures can be used to choose colors for specific values.
    # The value (in this case, a bool) is piped into the closure.
    # eg) {|| if $in { 'light_cyan' } else { 'light_gray' } }
    bool: light_cyan
    int: white
    filesize: cyan
    duration: white
    date: purple
    range: white
    float: white
    string: white
    nothing: white
    binary: white
    cell-path: white
    row_index: green_bold
    record: white
    list: white
    block: white
    hints: dark_gray
    search_result: {bg: red fg: white}
    shape_and: purple_bold
    shape_binary: purple_bold
    shape_block: blue_bold
    shape_bool: light_cyan
    shape_closure: green_bold
    shape_custom: green
    shape_datetime: cyan_bold
    shape_directory: cyan
    shape_external: cyan
    shape_externalarg: green_bold
    shape_external_resolved: light_yellow_bold
    shape_filepath: cyan
    shape_flag: blue_bold
    shape_float: purple_bold
    # shapes are used to change the cli syntax highlighting
    shape_garbage: { fg: white bg: red attr: b}
    shape_globpattern: cyan_bold
    shape_int: purple_bold
    shape_internalcall: cyan_bold
    shape_keyword: cyan_bold
    shape_list: cyan_bold
    shape_literal: blue
    shape_match_pattern: green
    shape_matching_brackets: { attr: u }
    shape_nothing: light_cyan
    shape_operator: yellow
    shape_or: purple_bold
    shape_pipe: purple_bold
    shape_range: yellow_bold
    shape_record: cyan_bold
    shape_redirection: purple_bold
    shape_signature: green_bold
    shape_string: green
    shape_string_interpolation: cyan_bold
    shape_table: blue_bold
    shape_variable: purple
    shape_vardecl: purple
}

const light_theme = {
    # color for nushell primitives
    separator: dark_gray
    leading_trailing_space_bg: { attr: n } # no fg, no bg, attr none effectively turns this off
    header: green_bold
    empty: blue
    # Closures can be used to choose colors for specific values.
    # The value (in this case, a bool) is piped into the closure.
    # eg) {|| if $in { 'dark_cyan' } else { 'dark_gray' } }
    bool: dark_cyan
    int: dark_gray
    filesize: cyan_bold
    duration: dark_gray
    date: purple
    range: dark_gray
    float: dark_gray
    string: dark_gray
    nothing: dark_gray
    binary: dark_gray
    cell-path: dark_gray
    row_index: green_bold
    record: dark_gray
    list: dark_gray
    block: dark_gray
    hints: dark_gray
    search_result: {fg: white bg: red}
    shape_and: purple_bold
    shape_binary: purple_bold
    shape_block: blue_bold
    shape_bool: light_cyan
    shape_closure: green_bold
    shape_custom: green
    shape_datetime: cyan_bold
    shape_directory: cyan
    shape_external: cyan
    shape_externalarg: green_bold
    shape_external_resolved: light_purple_bold
    shape_filepath: cyan
    shape_flag: blue_bold
    shape_float: purple_bold
    # shapes are used to change the cli syntax highlighting
    shape_garbage: { fg: white bg: red attr: b}
    shape_globpattern: cyan_bold
    shape_int: purple_bold
    shape_internalcall: cyan_bold
    shape_keyword: cyan_bold
    shape_list: cyan_bold
    shape_literal: blue
    shape_match_pattern: green
    shape_matching_brackets: { attr: u }
    shape_nothing: light_cyan
    shape_operator: yellow
    shape_or: purple_bold
    shape_pipe: purple_bold
    shape_range: yellow_bold
    shape_record: cyan_bold
    shape_redirection: purple_bold
    shape_signature: green_bold
    shape_string: green
    shape_string_interpolation: cyan_bold
    shape_table: blue_bold
    shape_variable: purple
    shape_vardecl: purple
}

export-env {
    $env.config = ($env.config | upsert color_config $light_theme) # if you want a more interesting theme, you can replace the empty record with `$dark_theme`, `$light_theme` or another custom record
}
