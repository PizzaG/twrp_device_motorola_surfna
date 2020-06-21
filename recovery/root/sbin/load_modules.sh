#!/sbin/sh

load_panel_modules()
{
    path=$1
    panel_supplier=""
    panel_supplier=$(cat /sys/devices/virtual/graphics/fb0/panel_supplier 2> /dev/null)

    case $panel_supplier in
        hlt)
            insmod $path/focaltech_mmi.ko
			       insmod $path/drv2624_mmi.ko
            ;;
        djn)
            insmod $path/focaltech_mmi.ko
			       insmod $path/drv2624_mmi.ko
            ;;
        wistron)
            insmod $path/focaltech_mmi.ko
			       insmod $path/drv2624_mmi.ko
            ;;
        
        *)
            echo "$panel_supplier not supported"
            ;;
    esac
}

# Main
mount /dev/block/bootdevice/by-name/vendor /vendor -o ro

# MMI Common
insmod /vendor/lib/modules/exfat.ko
insmod /vendor/lib/modules/utags.ko
insmod /vendor/lib/modules/sensors_class.ko
insmod /vendor/lib/modules/mmi_annotate.ko
insmod /vendor/lib/modules/mmi_info.ko
insmod /vendor/lib/modules/tzlog_dump.ko
insmod /vendor/lib/modules/mmi_sys_temp.ko

# Spaceminer touchscreen workaround
#insmod /vendor/lib/modules/*.ko ###LgPWNd # Some drivers don't like being inserted twice

## Surfna specific
insmod /vendor/lib/modules/tps61280.ko
insmod /vendor/lib/modules/drv2624_mmi.ko
insmod /vendor/lib/modules/sx932x_sar.ko
insmod /vendor/lib/modules/focaltech_mmi.ko
insmod /vendor/lib/modules/snd_soc_tfa9874.ko
##insmod /vendor/lib/modules/abov_sar.ko
insmod /vendor/lib/modules/nova_36525_mmi.ko
insmod /vendor/lib/modules/mcDrvModule.ko

# Load panel modules
if [ -d /vendor/lib/modules ]; then
    load_panel_modules /vendor/lib/modules
else
    # In case /vendor is empty for whatever reason
    # make sure at least touchscreen is working
    load_panel_modules /sbin/modules
fi

umount /vendor
setprop drivers.loaded 1
