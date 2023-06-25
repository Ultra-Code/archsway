#!/bin/zsh

function display_power_options(){
emulate -LR zsh
setopt noglob
power_files=(
/sys/devices/system/cpu/cpufreq/policy?/energy_performance_preference
/sys/devices/system/cpu/cpu*/power/energy_perf_bias
/sys/devices/system/cpu/intel_pstate/no_turbo
/sys/devices/system/cpu/intel_pstate/max_perf_pct
/sys/devices/system/cpu/intel_pstate/hwp_dynamic_boost
/sys/devices/system/cpu/cpu?/cpufreq/scaling_governor
/sys/module/snd_hda_intel/parameters/power_save_controller
/sys/module/snd_hda_intel/parameters/power_save
/sys/class/scsi_host/host?/link_power_management_policy
)

for file in ${power_files}; do
    print $file

    setopt glob
    #use the `~` modifier to treat files as patterns since they contain *|?
    cat ${~file}
done
}

if [[ $ZDOTDIR/fd.zsh ]];
then
    source $ZDOTDIR/fd.zsh
fi
