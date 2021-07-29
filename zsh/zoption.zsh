#Shell options
setopt HIST_IGNORE_ALL_DUPS # Do not write a duplicate event to the history file.
setopt HIST_SAVE_NO_DUPS #older commands that duplicate newer ones are omitted.
setopt SHARE_HISTORY     # Enable shells to read and write to the most recent history
setopt HIST_IGNORE_SPACE # ignore commands that start with space

#Make cd push the old directory onto the directory stack
setopt AUTO_PUSHD
#Don't push multiple copies of the same directory onto the directory stack
setopt PUSHD_IGNORE_DUPS
#Exchanges the meanings of `+' and `-' when used with a
#number to specify a directory in the stack.
setopt PUSHDMINUS

#command is the name of a directory, perform the cd command to that directory
setopt AUTO_CD
#Perform implicit tees or cats when multiple redirections are attempted
setopt MULTIOS
#If set, parameter expansion, command substitution and arithmetic
#expansion are performed in prompts
setopt PROMPT_SUBST

#Completion configurations
#
unsetopt MENU_COMPLETE
unsetopt FLOWCONTROL
#completion is done from both ends of the word
setopt COMPLETE_IN_WORD
#Automatically use menu completion after the second consecutive request for
#completion
setopt AUTO_MENU
#move cursor to the end of the word if completion was started with it in within
#word
setopt ALWAYS_TO_END
