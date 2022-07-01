#!/bin/zsh
#The main idea was from https://unix.stackexchange.com/questions/84437/how-do-i-make-my-laptop-sleep-when-it-reaches-some-low-battery-threshold/289129#289129
POWERSUPPLY_PATH="/sys/class/power_supply/BAT0/status"
BATTERY_CAPACITY_PATH="/sys/class/power_supply/BAT0/capacity"

BATTERY_STATUS=$(cat $POWERSUPPLY_PATH)
BATTERY_CAPACITY=$(cat $BATTERY_CAPACITY_PATH)

if [[ $BATTERY_CAPACITY -gt 25 ]]
then
    return

elif [[ $BATTERY_CAPACITY -lt 4 ]]
then
    return

elif [[ $BATTERY_CAPACITY -lt 7  &&  $BATTERY_STATUS == "Discharging" ]]
then
    CRITICAL_BATTERY_SOUND="/usr/share/sounds/freedesktop/stereo/alarm-clock-elapsed.oga"
    paplay $CRITICAL_BATTERY_SOUND

    swaynag -t error -m "Battery Critical : About to shutdown connect charger Battery level is ${BATTERY_CAPACITY}%!" \
        -b "Hybrid-sleep" "systemctl hybrid-sleep" -b "Hibernate" "systemctl hibernate" \
        -s "NO"

    paplay $CRITICAL_BATTERY_SOUND

elif [[ $BATTERY_CAPACITY -lt 15  &&  $BATTERY_STATUS == "Discharging" ]]
then
    LOW_BATTERY_SOUND="/usr/share/sounds/freedesktop/stereo/phone-outgoing-busy.oga"
    paplay $VERY_LOW_BATTERY_SOUND

    swaynag -t warning -m "Very Low Battery : About to shutdown connect charger Battery level is ${BATTERY_CAPACITY}%!" \
        -b "Hybrid-sleep" "systemctl hybrid-sleep" -b "Hibernate" "systemctl hibernate" \
        -s "NO"

    paplay $VERY_LOW_BATTERY_SOUND

elif [[ $BATTERY_CAPACITY -lt 20  &&  $BATTERY_STATUS == "Discharging" ]]
then
    LOW_BATTERY_SOUND="/usr/share/sounds/freedesktop/stereo/suspend-error.oga"

    swaynag -t warning -m "Low Battery : Battery level is ${BATTERY_CAPACITY}%!" \
        -b "Hybrid-sleep" "systemctl hybrid-sleep" -s "NO"

    paplay $LOW_BATTERY_SOUND

elif [[ $BATTERY_CAPACITY -lt 25  &&  $BATTERY_STATUS == "Discharging" ]]
then
    swaynag -t warning -m "Low Battery : Battery level is ${BATTERY_CAPACITY}%!" \
        -s "OK"

fi

