#!/bin/zsh

function status_bar() {
# The abbreviated weekday (e.g., "Sat"), followed by day , short month .eg "may" , year and current time
# date like sáb 07 may 2022 and the time (e.g., 14:01). Check `man date` on how to format time and date.
    date_formatted=$(date "+%a %d %b %Y %R")

    uptime_formatted=$(uptime | sed -En 's|.+up\s+([[:digit:]:]+\s?(min)?\|[[:digit:]]+\s+days?,\s+[[:digit:]:]+\s?(min)?),.*$|\1|p')

    linux_version=$(uname -r | cut -d '-' -f1)


    echo -n "$(cpuInfo) $(memInfo) \t$(mpdInfo)\t $(networkInfo) ↑ $uptime_formatted 🐧 $linux_version $(brightnessInfo) $(audioInfo) $(batteryInfo) 📆 $date_formatted"
}

function formatTime(){
    float unformated_time=$@
    integer hours=unformated_time;
    echo -n "$hours h "
    integer minutes=$(( (unformated_time - hours) * 60 ))
    echo -n "$minutes m"
}

function batteryInfo(){
    #https://www.kernel.org/doc/html/latest/power/power_supply_class.html
  local battery_status=$(cat /sys/class/power_supply/BAT0/status)
  local battery_capacity=$(cat /sys/class/power_supply/BAT0/capacity)

    #https://www.dnkpower.com/how-to-calculate-battery-run-time/
    #my device doesn't emit /sys/class/power_supply/BAT0/voltage_max_design but from looking at voltage_now at
    #full_charge for some time gives me values ranging 12968000 - 13028000 meaning only about ~90% (voltage_min_design/12968000*100)
    #of current_now is drawn since bat voltage doesn't go beneth voltage_min_design
        float charge_now=$(cat /sys/class/power_supply/BAT0/charge_now)
        float current_now=$(cat /sys/class/power_supply/BAT0/current_now)
        float voltage_now=$(cat /sys/class/power_supply/BAT0/voltage_now)

        #https://github.com/Alexays/Waybar/blob/master/src/modules/battery.cpp#L202
        float power_now=$(( (current_now*voltage_now) / 10**6 ))
        float energy_now=$(( (charge_now*voltage_now) / 10**6 )) #10**6 convert back to uWh

        float -F 2 time_to_run_down=$(( energy_now / (power_now*0.9) ))

        local discharging="$battery_capacity% $(formatTime $time_to_run_down)"
       local charging="$battery_capacity%"

    #bat lev 0-,1-,2-,3-,4-,5-,6-,7-,8-,9-,10-
    #bat char 2-,3-,4-,5-,6-,7-,8-,9-
  if [[ $battery_status == "Discharging" ]];then
       if [[ $battery_capacity -le 10 ]];then
           echo " $discharging"
       elif [[ $battery_capacity -le 20 ]];then
           echo " $discharging"
       elif [[ $battery_capacity -le 30 ]];then
           echo " $discharging"
       elif [[ $battery_capacity -le 40 ]];then
           echo " $discharging"
       elif [[ $battery_capacity -le 50 ]];then
           echo " $discharging"
       elif [[ $battery_capacity -le 60 ]];then
           echo " $discharging"
       elif [[ $battery_capacity -le 70 ]];then
           echo " $discharging"
       elif [[ $battery_capacity -le 80 ]];then
           echo " $discharging"
       elif [[ $battery_capacity -le 90 ]];then
           echo " $discharging"
       else
           echo "🔋 $discharging"
        fi
   elif [[ $battery_status == "Unknown" ]];then
            echo "⚡ $charging"
    else
    #https://stackoverflow.com/questions/26888636/how-to-calculate-the-time-remaining-until-the-end-of-the-battery-charge
        float full_charge=$(cat /sys/class/power_supply/BAT0/charge_full)
        float full_energy=$(( (full_charge*voltage_now) / (10**6) ))

        float -F 2 time_to_full_charge=$(( (full_energy-energy_now) / power_now))

        if [[ $battery_status != "Full" ]];then
            echo "🔌 $charging $(formatTime $time_to_full_charge) to full"
        else
            echo  "🔌 $charging Full"
        fi

    fi
    #$(($(cat /sys/class/power_supply/BAT0/charge_full)/$(echo $(cat /sys/class/power_supply/BAT0/current_now).0))) remaining

}

function brightnessInfo(){
    float brightness_max=$(cat /sys/class/backlight/intel_backlight/max_brightness)
    float brightness_value=$(cat /sys/class/backlight/intel_backlight/actual_brightness)
    integer brightness=$((brightness_value/brightness_max * 100.0))

        if [[ $brightness -le 25 ]];then
             echo "🔦 $brightness%"
        elif [[ $brightness -le 50 ]];then
             echo "💡 $brightness%"
        elif [[ $brightness -le 75 ]];then
             echo "🚦 $brightness%"
        else
             echo "☀️  $brightness%"
        fi
}

function mpdInfo(){
    local mpd_tack_info=$(mpc | grep -E '^\[')
    local mpd_status=$(echo $mpd_tack_info | tr --squeeze-repeats ' ' | cut -d ' ' -f1)
    local track_lenght=$(echo $mpd_tack_info | tr --squeeze-repeats ' ' | cut -d ' ' -f3)

    if [[ $mpd_status == "[playing]" ]];then
        echo "$mpd_status  $(mpc current) $track_lenght"
    elif [[ $mpd_status == "[paused]" ]]; then
        echo "$mpd_status  $(mpc current) $track_lenght"
    else
        echo "$mpd_status"
    fi
}

function audioInfo(){

  # Get Default sink
  local sink=$(pactl info | sed -En '\@Default Sink: \w+@ {s|\w+\s+\w+:\s+([[:graph:]]+$)|\1|p}')
  # Get active sink
  local active_sink=$(pactl list sinks | sed -En '\@\s+Name:\s+'"${sink}"'$@,$p')
  # Get volume and mute status with PulseAudio
  local mute_state=$( echo $active_sink | grep 'Mute' | cut -d ':' -f2 | tr -d ' ')
  local volume=$( echo $active_sink | grep -E '^\s+Volume' | cut -d '/' -f2 | tr -d ' ')
  local output_type=$(echo $active_sink | grep 'Active Port' | cut -d ':' -f2 | tr -d ' ')

  if [[ $mute_state == "no" ]];then
       if [[ $output_type == "analog-output-headphones" ]];then
            echo "🎧 $volume"
        elif [[ $output_type == "headphone-output" ]];then
            echo " 🎧 $volume"
        else
           echo "🔊 $volume"
        fi
   else
      echo "🔇 $volume"
 fi

}

function wifiStrength(){
#https://github.com/torvalds/linux/blob/9ff9b0d392ea08090cd1780fb196f36dbb586529/drivers/net/wireless/intel/ipw2x00/ipw2200.c#L4322
#https://www.intuitibits.com/2016/03/23/dbm-to-percent-conversion/
# from my practical use rssi range -28 to -33 for 70 quality happens to be the best .ie -28 == perfect_rssi
  local rssi=$(cat /proc/net/wireless | grep -E 'wl[[:alpha:]]*' | sed -E 's|[[:blank:]]*[[:graph:]]*[[:blank:]]+[[:digit:]]+[[:blank:]]+[[:graph:]]+[[:blank:]]+(-[[:digit:]]+).*|\1|')
  local perfect_rssi=-20
  local worst_rssi=-70


  local signal_quality=$(( (100 * (perfect_rssi - worst_rssi) * (perfect_rssi - worst_rssi) - (perfect_rssi - rssi) * (15 * (perfect_rssi - worst_rssi) + 62 * (perfect_rssi - rssi))) /
            ( (perfect_rssi - worst_rssi) * (perfect_rssi - worst_rssi) ) ));

        if [[ $signal_quality -gt 100 ]]
        then
                signal_quality=100

        elif [[ $signal_quality -lt 1 ]]
        then
                signal_quality=0
        fi

        echo "$signal_quality"

}

function networkInfo {
  #for bandwidth (in/out) information is needed check /proc/net/dev
  # Print interface names with IPv4 addresses
  # Skip the first line since that's the loopback interface
  # net_info=$(ip -4 -oneline address | grep -E --invert-match '1:' | tr --squeeze-repeats ' ')
    local net_info=$(cat /proc/net/arp | sed -En '2 s|^([[:digit:].]+).*|\1|p')
    local interface=$(cat /proc/net/arp | sed -En '2 s|.*\s+(\w+)$|\1|p')
    local ip=$(echo $net_info | cut -d ' ' -f4)

    if [[ $interface =~ "en*" ]];then
        echo -n " $interface: $ip "
    fi

    local wifi_name=$(iwctl station wlan0 show | grep -E '\s+Connected\s+network' | sed -E 's|\s+\w+\s+\w+\s+([[:alnum:]]+[[:punct:][:space:]]{1}[[:alnum:]]+?).*|\1|g')
    local is_wlan_down=$(rfkill list wlan | sed -En 's|\s+Soft\s+blocked:\s+(\w+).*$|\1|p')
    if [[ $interface =~ "wl*" ]];then
        echo -n "直 $interface: $wifi_name ($(wifiStrength))% "
    elif [[ -z $wifi_name && $is_wlan_down == "no" ]]
    then
        echo -n "wlan : up "
    fi

    local bt_name=$(bluetoothctl info | sed -En 's|\s+Name:\s+([[:graph:]]+).*$|\1|p')
    local is_bt_down=$(rfkill list bluetooth | sed -En 's|\s+Soft\s+blocked:\s+(\w+).*$|\1|p')
    if [[ -n $bt_name ]];then
        echo -n "bt: $bt_name "
    elif [[ -z $bt_name && $is_bt_down == "no" ]];then
        echo -n "bt : up"
    fi

    if [[ -z $interface && $is_wlan_down == "yes" && $is_bt_down == "yes" ]]
    then
        echo "net : down"
    fi
}

function cpuInfo(){
    #todo get info from proc which might be less expensive
    #read 2. SUMMARY Display of top's man page might help to understand the various utilization values
    #https://github.com/Alexays/Waybar/blob/master/src/modules/cpu/common.cpp#L70
    #http://blog.davidecoppola.com/2016/12/cpp-program-to-get-cpu-usage-from-command-line-in-linux/
    local previous_idle_time=$(cat /proc/stat | sed -En '1 s|^\w+\s+([[:digit:]]+\s+){3}([[:digit:]]+).*|\2|p')
    #guest_nice isn't included because of limitation of sed \0 - \9
    local previous_total_time=$(( $(cat /proc/stat | sed -En '1,1 s|^\w+\s+([0-9]+)\s+([0-9]+)\s+([0-9]+)\s+([0-9]+)\s+([0-9]+)\s+([0-9]+)\s+([0-9]+)\s+([0-9]+)\s+([0-9]+)\s+([0-9]+)$| (\1 + \2 + \3 + \4 + \5 + \6 + \7 + \8 + \9)|p') ))
    sleep 0.3
    local current_idle_time=$(cat /proc/stat | sed -En '1 s|^\w+\s+([[:digit:]]+\s+){3}([[:digit:]]+).*|\2|p')
    local current_total_time=$(( $(cat /proc/stat | sed -En '1,1 s|^\w+\s+([0-9]+)\s+([0-9]+)\s+([0-9]+)\s+([0-9]+)\s+([0-9]+)\s+([0-9]+)\s+([0-9]+)\s+([0-9]+)\s+([0-9]+)\s+([0-9]+)$| (\1 + \2 + \3 + \4 + \5 + \6 + \7 + \8 + \9)|p') ))

    float idle_time=$((current_idle_time - previous_idle_time))
    float total_time=$((current_total_time - previous_total_time))

    float -F 2 usage=$((100 * (1 - (idle_time/total_time)) ))
      #maybe get average load from /proc/loadavg
      local average_load_in_1min=$(cat /proc/loadavg | cut -d' ' -f1) #uptime | sed -E 's|.{52}([[:digit:]]+.[[:digit:]]+).*|\1|g'
      print " $average_load_in_1min  $usage% "
}

function memInfo(){
    #https://pitstop.manageengine.com/portal/en/kb/articles/how-is-memory-utilization-calculated-for-linux-servers
    #Example memory_used_method: ("total memory" - "MemAvailable", matches free command) as exposed by /proc/meminfo
    local info=$(free -m | grep -E 'Mem')
    local total=$(echo $info | sed -E 's|[[:graph:]]+[[:space:]]+([[:digit:]]+).*|\1|')
    local free=$(echo $info | sed -E 's|[[:graph:]]+[[:space:]]+[[:digit:]]+[[:space:]]+[[:digit:]]+[[:space:]]+([[:digit:]]+).*|\1|')
    local buff_cache=$(echo $info |sed -E 's|[[:graph:]]+[[:space:]]+[[:digit:]]+[[:space:]]+[[:digit:]]+[[:space:]]+[[:digit:]]+[[:space:]]+[[:digit:]]+[[:space:]]+([[:digit:]]+).*|\1|')

    integer utilization=$((100 - ( (free+buff_cache) * 100 / total ) ))

    declare -F 2 used=$(echo $info | sed -E 's|[[:graph:]]+[[:space:]]+[[:digit:]]+[[:space:]]+([[:digit:]]+).*|\1|')
    used=$(( used / 1024 ))

    echo " $used GiB ($utilization)%"

}

# The argument to `sleep` is in seconds
(while true; do
   status_bar
    sleep 1
done) &
