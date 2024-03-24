#!/bin/bash
#from https://github.com/mumin16/arch-sway
# sway config in ~/.config/sway/config :
# bar {
#   status_command exec ~/.config/sway/swaybar.sh
# }
#inspiration from https://gitlab.com/bullbytes/dotfiles/-/blob/master/sway/status.sh
#https://u|nix.stackexchange.com/questions/473788/simple-swaybar-example
#https://github.com/zakariaGatter/i3blocks-gate/blob/master/i3b-gate

  # Emojis and characters for the status bar:
  # Electricity: ⚡  ↯  🔌 ⏻
  # Audio: 🔈 🔊🔉 🎧 🎶 🎵 🎤 🎙️
  # Circles: 🔵 🔘 ⚫ ⚪ 🔴 ⭕
  # Time: https://stackoverflow.com/questions/5437674/what-unicode-characters-represent-time
  # Folder:  📁
  # Mail: ✉  📫 📬 📭 📪 📧 ✉️ 📨 💌 📩 📤 📥 📮 📯 🏤 🏣
  # Computer: 💻 🖥️  💾  💽
  # Network, communication: 📶   📡  📱 ☎️  📞 📟
  # Checkmarks and crosses: ✅  ❎
  # Keys and locks: 🗝 🔑 🗝️ 🔐 🔒 🔏 🔓
  # Separators: \| ❘ ❙ ❚ ⎟⎥ ⎮  ⎢
  # Printer:
  # Misc: 🐧 🗽 💎 💡 ⭐ ↑ ↓  ⚠ ⚙️  🧲 🌐 🌍 🏠 🤖 🧪 🛡️ 🔗 📦🎁 ⏾

  # Sun: 🌅 🌄 ☀️  🌞 🌞
  # Moon: 🌙 🌑 🌕 🌝 🌜 🌗 🌘 🌚 🌒 🌔 🌛 🌓 🌖
  # City: 🌇 🌃 🌆
  # Stars: 🌟 🌠 🌌


bg_bar_color="#323232"

# Print a left caret separator
# @params {string} $1 text color, ex: "#FF0000"
# @params {string} $2 background color, ex: "#FF0000"
separator() {
  echo -n "{"
  echo -n "\"full_text\":\"\"," # CTRL+Ue0b2
  echo -n "\"separator\":false,"
  echo -n "\"separator_block_width\":0,"
  echo -n "\"border\":\"$bg_bar_color\","
  echo -n "\"border_left\":0,"
  echo -n "\"border_right\":0,"
  echo -n "\"border_top\":2,"
  echo -n "\"border_bottom\":2,"
  echo -n "\"color\":\"$1\","
  echo -n "\"background\":\"$2\""
  echo -n "}"
}

common() {
  echo -n "\"border\": \"$bg_bar_color\","
  echo -n "\"separator\":false,"
  echo -n "\"separator_block_width\":0,"
  echo -n "\"border_top\":2,"
  echo -n "\"border_bottom\":2,"
  echo -n "\"border_left\":0,"
  echo -n "\"border_right\":0"
}



shortcuts() {
  local bg="#639bd3" # vert
  separator $bg $bg_bar_color
  echo -n ",{"
  echo -n "\"name\":\"id_shortcuts\","
  echo -n "\"full_text\":\"  $(localectl status | grep "X11 Layout" | sed -e "s/^.*X11 Layout://")\","
  echo -n "\"background\":\"$bg\","
  common
  echo -n "},"
}


conn() {
  local bg="#2E7D32" # vert
  separator $bg "#639bd3"
  echo -n ",{"
  echo -n "\"name\":\"id_conn\","
  echo -n "\"full_text\":\"  $(nmcli -t -f NAME c show --active) \","
  echo -n "\"background\":\"$bg\","
  common
  echo -n "},"
}


mem_usage() {
  local bg="#3949AB"
  separator $bg "#2E7D32"
  echo -n ",{"
  echo -n "\"name\":\"id_mem_usage\","
  echo -n "\"full_text\":\" 󰀹 $(awk '/^Mem/ {print $3}' <(free -m))M \","
  echo -n "\"background\":\"#3949AB\","
  common
  echo -n "},"
}

mydate() {
  local bg="#E0E0E0"
  separator $bg "#3949AB"
  echo -n ",{"
  echo -n "\"name\":\"id_time\","
  echo -n "\"full_text\":\"  $(date "+%H:%M") \","
  echo -n "\"color\":\"#000000\","
  echo -n "\"background\":\"$bg\","
  common
  echo -n "},"
}

battery0() {
  if [ -f /sys/class/power_supply/BAT0/uevent ]; then
    local bg="#D69E2E"
    separator $bg "#E0E0E0"
    bg_separator_previous=$bg
    prct=$(cat /sys/class/power_supply/BAT0/uevent | grep "POWER_SUPPLY_CAPACITY=" | cut -d'=' -f2)
    charging=$(cat /sys/class/power_supply/BAT0/uevent | grep "POWER_SUPPLY_STATUS" | cut -d'=' -f2) # POWER_SUPPLY_STATUS=Discharging|Charging
    icon=""
    if [ "$charging" == "Charging" ]; then
      icon="󰃨"
    fi
    echo -n ",{"
    echo -n "\"name\":\"battery0\","
    echo -n "\"full_text\":\" ${icon} ${prct}% \","
    echo -n "\"color\":\"#000000\","
    echo -n "\"background\":\"$bg\","
    common
    echo -n "},"
  else
    bg_separator_previous="#E0E0E0"
  fi
}

volume() {
  local bg="#673AB7"
  separator $bg $bg_separator_previous
  vol=$(awk -F"[][]" '/Left:/ { print $2 }' <(amixer sget Master))
  echo -n ",{"
  echo -n "\"name\":\"id_volume\","
  if [ $vol -le 0 ]; then
    echo -n "\"full_text\":\" 󰆪 ${vol} \","
  else
    echo -n "\"full_text\":\"  ${vol} \","
  fi
  echo -n "\"background\":\"$bg\","
  common
  echo -n "},"
  separator $bg_bar_color $bg
}

logout() {
  echo -n ",{"
  echo -n "\"name\":\"id_logout\","
  echo -n "\"full_text\":\"  \""
  echo -n "}"
}

# https://github.com/i3/i3/blob/next/contrib/trivial-bar-script.sh
echo '{ "version": 1, "click_events":true }'     # Send the header so that i3bar knows we want to use JSON:
echo '['                    # Begin the endless array.
echo '[]'                   # We send an empty first array of blocks to make the loop simpler:

# Now send blocks with information forever:
(while :;
do
	echo -n ",["
  shortcuts
  conn
  mem_usage
  mydate
  battery0
  volume
  logout
  echo "]"
	sleep 10
done) &

# click events
while read line;
do

  # TERMINAL
  if [[ $line == *"name"*"id_shortcuts"* ]]; then
    foot -e ~/.config/sway/shortcuts.sh &

  # CONNECTION
  elif [[ $line == *"name"*"id_conn"* ]]; then
    foot -e nmtui &

  # MEMORY
  elif [[ $line == *"name"*"id_mem_usage"* ]]; then
    foot -e htop &

  # TIME
  elif [[ $line == *"name"*"id_time"* ]]; then
    foot -e ~/.config/sway/click_time.sh &

  # VOLUME
  elif [[ $line == *"name"*"id_volume"* ]]; then
    foot -e alsamixer &

  # LOGOUT
  elif [[ $line == *"name"*"id_logout"* ]]; then
    swaymsg exit &

  fi
done
