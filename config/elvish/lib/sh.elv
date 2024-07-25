# Not supported on turmux
fn display_power_options {
    var power_files = [
        # /sys/devices/system/cpu/cpufreq/policy?/energy_performance_preference alway performance
        /sys/devices/system/cpu/cpu*/power/energy_perf_bias
        /sys/devices/system/cpu/intel_pstate/no_turbo
        /sys/devices/system/cpu/intel_pstate/max_perf_pct
        /sys/devices/system/cpu/intel_pstate/min_perf_pct
        /sys/devices/system/cpu/intel_pstate/hwp_dynamic_boost
        /sys/devices/system/cpu/cpu?/cpufreq/scaling_governor
        /sys/module/snd_hda_intel/parameters/power_save_controller
        /sys/module/snd_hda_intel/parameters/power_save
        # /sys/class/scsi_host/host?/link_power_management_policy fix wildcard
    ]

    echo "feature : value"
    for file $power_files {
        print $file
        print " : "
        cat $file
    }
}
