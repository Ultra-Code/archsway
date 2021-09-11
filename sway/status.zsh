#!/bin/zsh

# The Sway configuration file in ~/.config/sway/config calls this script.
# You should see changes to the status bar after saving this script.
# If not, do "killall swaybar" and $mod+Shift+c to reload the configuration.

# Produces "21 days", for example
uptime_formatted=$(uptime | cut -d ',' -f1  | cut -d ' ' -f4,5)

# The abbreviated weekday (e.g., "Sat"), followed by the ISO-formatted date
# like 2018-10-06 and the time (e.g., 14:01)
date_formatted=$(date "+%a %F %H:%M")

# Get the Linux version but remove the "-1-ARCH" part
linux_version=$(uname -r | cut -d '-' -f1)

# Returns the battery status: "Full", "Discharging", or "Charging".
battery_status=$(cat /sys/class/power_supply/BAT0/status)

# Emojis and characters for the status bar
# 💎 💻 💡 🔌 ⚡ 📁 \|
echo $uptime_formatted ↑ $linux_version 🐧 $battery_status 🔋 $date_formatted

# The Sway configuration file in ~/.config/sway/config calls this script.
# You should see changes to the status bar after saving this script.
# If not, do "killall swaybar" and $mod+Shift+c to reload the configuration.

# The abbreviated weekday (e.g., "Sat"), followed by the ISO-formatted date
# like 2018-10-06 and the time (e.g., 14:01). Check `man date` on how to format
# time and date.
date_formatted=$(date "+%a %F %H:%M")

# "upower --enumerate | grep 'BAT'" gets the battery name (e.g.,
# "/org/freedesktop/UPower/devices/battery_BAT0") from all power devices.
# "upower --show-info" prints battery information from which we get
# the state (such as "charging" or "fully-charged") and the battery's
# charge percentage. With awk, we cut away the column containing
# identifiers. i3 and sway convert the newline between battery state and
# the charge percentage automatically to a space, producing a result like
# "charging 59%" or "fully-charged 100%".
battery_info=$(upower --show-info $(upower --enumerate |\
grep 'BAT') |\
egrep "state|percentage" |\
awk '{print $2}')

# "amixer -M" gets the mapped volume for evaluating the percentage which
# is more natural to the human ear according to "man amixer".
# Column number 4 contains the current volume percentage in brackets, e.g.,
# "[36%]". Column number 6 is "[off]" or "[on]" depending on whether sound
# is muted or not.
# "tr -d []" removes brackets around the volume.
# Adapted from https://bbs.archlinux.org/viewtopic.php?id=89648
audio_volume=$(amixer -M get Master |\
awk '/Mono.+/ {print $6=="[off]" ?\
$4" 🔇": \
$4" 🔉"}' |\
tr -d [])

# Additional emojis and characters for the status bar:
# Electricity: ⚡ ↯ ⭍ 🔌
# Audio: 🔈 🔊 🎧 🎶 🎵 🎤
# Separators: \| ❘ ❙ ❚
# Misc: 🐧 💎 💻 💡 ⭐ 📁 ↑ ↓ ✉ ✅ ❎
echo $audio_volume $battery_info 🔋 $date_formatted


function print_status {

  # The configurations file in ~/.config/sway/config or
  # in ~/.config/i3/config can call this script.
  #
  # You should see changes to the status bar after saving this script.
  # For Sway:
  # If not, do "killall swaybar" and $mod+Shift+c to reload the configuration.
  # For i3:
  # If not, do "killall i3bar" and $mod+Shift+r to restart the i3 (workspaces and windows stay as they were).


  # The abbreviated weekday (e.g., "Sat"), followed by the ISO-formatted
  # date like 2018-10-06 and the time (e.g., 14:01). Check `man date`
  # on how to format time and date.
  date_formatted=$(date "+%a %F %H:%M")

  # Symbolize the time of day (morning, midday, evening, night)
  # The dash removes the zero padding in front of the hour. A leading zero wouldn't work in the if statements
  h=$(date "+%-H")
  if (($h>=22 || $h<=5)); then
    time_of_day_symbol=🌌
  elif (($h>=17)); then
    time_of_day_symbol=🌆
  elif (($h>=11)); then
    time_of_day_symbol=🌞
  else
    time_of_day_symbol=🌄
  fi
  # Sun: 🌅 🌄 ☀️  🌞
  # Moon: 🌙 🌑 🌕 🌝 🌜 🌗 🌘 🌚 🌒 🌔 🌛 🌓 🌖
  # City: 🌇 🌃 🌆
  # Stars: 🌟 🌠 🌌

  # "upower --enumerate | grep 'BAT'" gets the battery name (e.g.,
  # "/org/freedesktop/UPower/devices/battery_BAT0") from all power devices.
  # "upower --show-info" prints battery information from which we get
  # the state (such as "charging" or "fully-charged") and the battery's
  # charge percentage. With awk, we cut away the column containing
  # identifiers. tr changes the newline between battery state and
  # the charge percentage to a space. Then, sed removes the trailing space,
  # producing a result like "charging 59%" or "fully-charged 100%".
  battery_info=$(upower --show-info $(upower --enumerate |\
  grep 'BAT') |\
  egrep "state|percentage" |\
  awk '{print $2}' |\
  tr '\n' ' ' |\
  sed 's/ $//'
  )
  # Alternative: Often shows the status as "Unknown" when plugged in
  # battery_info="$(cat /sys/class/power_supply/BAT0/status) $(cat /sys/class/power_supply/BAT0/capacity)%"

  # Get volume and mute status with PulseAudio
  volume=$(pactl list sinks | grep Volume | head -n1 | awk '{print $5}')
  audio_info=$(pactl list sinks | grep Mute | awk -v vol="${volume}" '{print $2=="no"? "🔉 " vol : "🔇 " vol}')

  # Emojis and characters for the status bar:
  # Electricity: ⚡ 🗲 ↯ ⭍ 🔌 ⏻
  # Audio: 🔈 🔊 🎧 🎶 🎵 🎤🕨 🕩 🕪 🕫 🕬  🕭 🎙️🎙⏺⏩⏸
  # Circles: 🔵 🔘 ⚫ ⚪ 🔴 ⭕
  # Time: https://stackoverflow.com/questions/5437674/what-unicode-characters-represent-time
  # Mail: ✉ 🖂  🖃  🖄  🖅  🖆  🖹 🖺 🖻 🗅 🗈 🗊 📫 📬 📭 📪 📧 ✉️ 📨 💌 📩 📤 📥 📮 📯 🏤 🏣
  # Folder: 🖿 🗀  🗁  📁 🗂 🗄
  # Computer: 💻 🖥️ 🖳  🖥🖦  🖮  🖯 🖰 🖱🖨 🖪 🖫 🖬 💾 🖴 🖵 🖶 🖸 💽
  # Network, communication: 📶 🖧  📡 🖁 📱 ☎️  📞 📟
  # Keys and locks: 🗝 🔑 🗝️ 🔐 🔒 🔏 🔓
  # Checkmarks and crosses: ✅ 🗸 🗹 ❎ 🗙
  # Separators: \| ❘ ❙ ❚ ⎟⎥ ⎮  ⎢
  # Printer: ⎙
  # Misc: 🐧 🗽 💎 💡 ⭐ ↑ ↓ 🌡🕮  🕯🕱 ⚠ 🕵 🕸 ⚙️  🧲 🌐 🌍 🏠 🤖 🧪 🛡️ 🔗 📦🎁 ⏾

  # Print interface names with IPv4 addresses
  # Skip the first line since that's the loopback interface
  network_info=$(ip -4 -oneline address | awk 'NR > 1 {printf(""$2": "$4" → "); system("default_gateway_and_ssid_for_device " $2)}' | tr '\n' '|')

  echo "🖧 $network_info $audio_info 🔋 $battery_info $time_of_day_symbol $date_formatted"
}

function default_gateway_and_ssid_for_device() {

  dev=$1
  default_gateway=$(ip route show default dev $dev | awk '{print $3}')
  # This is empty if we are not connected via WiFi. To get signal strength, use "iw wlp3s0 link"
  ssid=$(iw $dev info | grep -Po '(?<=ssid ).*')
  echo $default_gateway $ssid
}
# Make the function available to be called from awk
export -f default_gateway_and_ssid_for_device


# The argument to `sleep` is in seconds
while true; do print_status; sleep 2; done
