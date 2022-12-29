#!/bin/zsh
output=$(timeout 60.1 pidstat 60 -p ALL)
IFS='
'
for line in $output; do
    # extract N-th column with awk
    pid=`echo $line | awk '{ print $4}'`    # PID
    pcpu=`echo $line | awk '{ print $9}'`   # percentage CPU
    cpu=`echo $line | awk '{ print $10}'`   # CPU ID
    cmd=`echo $line | awk '{ print $11}'`   # command
    echo "$pid $pcpu $cpu $cmd"
done

#!/bin/bash
#
# experimental battery discharge alerter
#
nsecs=3 # loop sleep time between readings
#
ful=$(cat /sys/class/power_supply/BAT0/energy_full)
#
oldval=0
while true
do
  cur=$(cat /sys/class/power_supply/BAT0/energy_now)
  dif="$((ful - cur))"
  slope="$((cur - oldval))"
  if [ "$slope" -lt 0 ]
  then
    echo "*** discharging!"
    notify-send -u critical -i "notification-message-IM" "discharging"
  fi
 oldval=$cur
 sleep $nsecs
done

# cat /tmp/testscript.sh
#!/bin/bash

runtime="5 minute"
endtime=$(date -ud "$runtime" +%s)

while [[ $(date -u +%s) -le $endtime ]]
do
    echo "Time Now: `date +%H:%M:%S`"
    echo "Sleeping for 10 seconds"
    sleep 10
done

 alias grep='grep -T --color --exclude=ignore_file* --exclude-dir=ignore-dir*'
# What that does is find all files in your current directory excluding the directory (or file) named "ignore", then executes the command grep -r something on each file found in the non-ignored files.
 find . -path ./ignore -prune -o -exec grep -r something {} \;

#Do you need to search a large directory of large files? ripgrep uses parallelism by default, which tends to make it faster than a standard grep -r search.
#However, if you're OK writing the occasional
find ./ -print0 | xargs -P8 -0 grep #command , then maybe grep is good enough.

git grep when seaching in a git repo


#you don't require find command. You can use grep to search in directory. You can ignore directory by using exclude-dir syntax.
grep -r --exclude-dir=".git;.svn" "string to search" directory

grep -R --exclude-dir=".git" --exclude-dir=".svn" MyRegex

check for a command
if command -v bat &>/dev/null
        then
                bat --color=always --style=plain --pager=never "$file" "$@"
        else
                cat "$file"
        fi

        # opendocument with pandoc/odt2txt
function view_opendocument() {
        if ! hash odt2txt 2>/dev/null; then
                return 1
        elif ! hash pandoc 2>/dev/null; then
                odt2txt "${FILE}"
        elif ! hash glow 2>/dev/null; then
                pandoc "${FILE}" --to=markdown || odt2txt "${FILE}"
        elif hash glow 2>/dev/null; then
                glow -s dark -w "${WIDTH}" \
                        <(pandoc "${FILE}" --to=markdown || odt2txt "${FILE}")
        fi
        return $?
}

# CPU USAGE
# emulate -L zsh
float -F 2 usage=$((100 - $(top -bn1 | sed -En '/^.Cpu/ s|.*ni.\s+([0-9.]+)\s+id.*|\1|p') ))
echo "cpu usage from top is $usage%"
# print cpu usage top 2 : $((100.0 - $(top -bn2 | sed -En '0,/^%Cpu/! s|^.*,\s(....\|...)\s+id,.*$|\1|1p;') ))
#$(( 100.0 - $(top -bn2 | sed -En '\|^%Cpu|p' | sed -En '2 s|^.*,\s(....\|...)\s+id,.*$|\1|p') ))
#
# Code:
#
# sed  '0,/Jack/! s/Jack/Rob/' file.txt
#
# The exclamation mark negates everything from the beginning of the file to the first "Jack", so that the substitution operates on all the following lines. Note that I believe this is a gnu sed operation only.
#
# If you need to operate on only the second occurrence, and ignore any subsequent matches, you can use a nested expression.
# Code:
#
# sed  '0,/Jack/! {0,/Jack/ s/Jack/Rob/}' file.txt
#
# Here, the bracketed expression will operate on the output of the first part, but in this case, it will exit after changing the first matching "Jack".
#
# cat /proc/stat |grep 'cpu\s'|awk '{print ($5*100)/($2+$3+$4+$5+$6+$7+$8+$9+$10)}'|awk '{print "CPU Usage in awk: " 100-$1}'
# print cpu usage is sed $(( $(cat /proc/stat | sed -En '1,1 s|^\w+\s+([0-9]+)\s+([0-9]+)\s+([0-9]+)\s+([0-9]+)\s+([0-9]+)\s+([0-9]+)\s+([0-9]+)\s+([0-9]+)\s+([0-9]*)\s+([0-9]*)$| ( 100.0 - ( \4 * 100.0)/ (\1 + \2 + \3 + \4 + \5 + \6 + \7 + \8 + \9) )|p') ))
# cat /proc/stat | sed -En '1,1 s|^\w+\s+([0-9]+)\s+([0-9]+)\s+([0-9]+)\s+([0-9]+)\s+([0-9]+)\s+([0-9]+)\s+([0-9]+)\s+([0-9]+)\s+([0-9]*)\s+([0-9]*)$| printf "%s %.1f" "cpu usage in sed math is" $(( 100 - ( \4 * 100)/ (\1 + \2 + \3 + \4 + \5 + \6 + \7 + \8 + \9) ))|ep'
# echo cpu usage in vmstat 2 2 is $(( 100 -  $(vmstat '2' '2' | sed -En '4,4 s|.*\s([[:digit:]]{2}).*|\1|p') ))%
# echo CPU Usage in vm 1 2 : $(( 100 - $(vmstat 1 2|tail -1|awk '{print $15}') ))%
#
#
#aplication of this
active_sink=$(pactl list sinks | sed -En '0,\@^\s+\w+:\s+SUSPENDED@! {\@^\s+\w+:\s+SUSPENDED@,$p}')
output_type=$(echo $active_sink | sed '0,\@^\s+Volume@! {\@^\s+Volume@ s|.+/\s+([[:digit:]]+%).*|\1|p}')
function cpuUsage(){
    local previous_idle_time=$(cat /proc/stat | sed -En '1 s|^\w+\s+([[:digit:]]+\s+){3}([[:digit:]]+).*|\2|p')
    #guest_nice isn't included because of limitation of sed \0 - \9
    local previous_total_time=$(cat /proc/stat | sed -En '1,1 s|^\w+\s+([0-9]+)\s+([0-9]+)\s+([0-9]+)\s+([0-9]+)\s+([0-9]+)\s+([0-9]+)\s+([0-9]+)\s+([0-9]+)\s+([0-9]+)\s+([0-9]+)$| echo $((\1 + \2 + \3 + \4 + \5 + \6 + \7 + \8 + \9))|ep')
    sleep 0.3
    local current_idle_time=$(cat /proc/stat | sed -En '1 s|^\w+\s+([[:digit:]]+\s+){3}([[:digit:]]+).*|\2|p')
    local current_total_time=$(cat /proc/stat | sed -En '1,1 s|^\w+\s+([0-9]+)\s+([0-9]+)\s+([0-9]+)\s+([0-9]+)\s+([0-9]+)\s+([0-9]+)\s+([0-9]+)\s+([0-9]+)\s+([0-9]+)\s+([0-9]+)$| echo $((\1 + \2 + \3 + \4 + \5 + \6 + \7 + \8 + \9))|ep')

    float idle_time=$((current_idle_time - previous_idle_time))
    float total_time=$((current_total_time - previous_total_time))

    float -F 2 cpu_utility=$((100 * (1 - (idle_time/total_time)) ))
    echo "Cpu utility is $cpu_utility%"
}

cpuUsage


  # Getting Audio information for PulseAudio
   Get Default sink
   local sink=$(pactl info | sed -En '\@Default Sink: \w+@ {s|\w+\s+\w+:\s+([[:graph:]]+$)|\1|p}')
   # Get active sink
   local active_sink=$(pactl list sinks | sed -En '\@\s+Name:\s+'"${sink}"'$@,$p')
   # Get volume and mute status with PulseAudio
   local mute_state=$( echo $active_sink | grep 'Mute' | cut -d ':' -f2 | tr -d ' ')
   local volume=$( echo $active_sink | grep -E '^\s+Volume' | cut -d '/' -f2 | tr -d ' ')
   local output_type=$(echo $active_sink | grep 'Active Port' | cut -d ':' -f2 | tr -d ' ')

