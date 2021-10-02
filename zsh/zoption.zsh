#Shell options
# Do not write a duplicate event to the history file.
setopt HIST_IGNORE_ALL_DUPS
#older commands that duplicate newer ones are omitted when writing out from the
#internal to external history
setopt HIST_SAVE_NO_DUPS
# ignore commands that start with space
# Enable shells to read and write to the most recent history
setopt HIST_IGNORE_SPACE
#Remove superfluous blanks from each command line being added to the history list
setopt HIST_REDUCE_BLANKS
#use a single, shared history file across the sessions and append to it rather than overwrite
setopt SHARE_HISTORY

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
#completion is done from both ends of the word
setopt COMPLETE_IN_WORD
#if set hit the tab key will list possible completions, but not substitute them in the
#command prompt
setopt GLOB_COMPLETE
#Try  to correct the spelling of commands
setopt CORRECT
#unsetopt MENU_COMPLETE
#unsetopt FLOWCONTROL
#Automatically use menu completion after the second consecutive request for
#completion
#setopt AUTO_MENU
#move cursor to the end of the word if completion was started with it in within
#word
#setopt ALWAYS_TO_END

#MISC
# Don't send SIGHUP to background processes when the shell exits.
setopt NOHUP
# avoid "beep"ing
setopt NOBEEP

