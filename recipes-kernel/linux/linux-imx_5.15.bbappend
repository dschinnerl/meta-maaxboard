require recipes-kernel/linux/linux-maaxboard-src-5.15.inc

KERNEL_DEF_CONFIG ??= "maaxboard_defconfig"
#KERNEL_DEF_CONFIG_maaxboardnano = "maaxboard_nano_defconfig"
#KERNEL_DEF_CONFIG_maaxboard = "maaxboard_defconfig"
#KERNEL_DEF_CONFIG_maaxboardmini = "maaxboard_mini_defconfig"
#KBUILD_DEFCONFIG_maaxboardnano = "maaxboard_nano_defconfig"

KERNEL_DTC_FLAGS = "-@"

DEFAULTTUNE:use-mainline-bsp = "cortexa53-crypto"

MACHINE_FEATURES += "pci wifi bluetooth bcm43455 bcm4356"

# NXP BSP can consume proprietary jailhouse and BCM4359 firmware
# Since the firmware is not available publicly, and rather distributed
# under "Proprietary" license - we opt-out from using it in all BSPs
# and pin it to NXP BSP only
# OP-TEE is also applicable to NXP BSP, mainline BSP seems not to have
# a full support for it yet.
MACHINE_FEATURES:append:use-nxp-bsp = " optee jailhouse bcm4359"

do_copy_defconfig:maaxboardbase () {
    install -d ${B}
    # copy latest imx_v8_defconfig to use for mx8
    mkdir -p ${B}
    cp ${S}/arch/arm64/configs/${KERNEL_DEF_CONFIG} ${B}/.config
    cp ${S}/arch/arm64/configs/${KERNEL_DEF_CONFIG} ${B}/../defconfig
}

# Auto load Wi-Fi(nxp8987) driver moal
# /etc/modprobe.d/moal.conf
#KERNEL_MODULE_AUTOLOAD_maaxboardnano += "moal"
#KERNEL_MODULE_PROBECONF_maaxboardnano += "moal"
#module_conf_moal_maaxboardnano = "options moal mod_para=nxp/wifi_mod_para_sd8987.conf"

KERNEL_DEVICETREE2_maaxboardnano  = " \
    freescale/overlays/maaxboard-nano-audio.dtbo \
    freescale/overlays/maaxboard-nano-ext-spi.dtbo \
    freescale/overlays/maaxboard-nano-ext-sai3.dtbo \
    freescale/overlays/maaxboard-nano-ext-uart4.dtbo \
    freescale/overlays/maaxboard-nano-ext-gpio.dtbo \
    freescale/overlays/maaxboard-nano-mic.dtbo \
    freescale/overlays/maaxboard-nano-ext-i2c.dtbo \
    freescale/overlays/maaxboard-nano-mipi.dtbo \
    freescale/overlays/maaxboard-nano-ext-pwm.dtbo \
    freescale/overlays/maaxboard-nano-ov5640.dtbo \
"
KERNEL_DEVICETREE2_maaxboard  = " \
    freescale/overlays/maaxboard-as0260.dtbo \
    freescale/overlays/maaxboard-dual-display.dtbo \
    freescale/overlays/maaxboard-ext-gpio.dtbo \
    freescale/overlays/maaxboard-ext-i2c.dtbo \
    freescale/overlays/maaxboard-ext-pwm.dtbo \
    freescale/overlays/maaxboard-ext-sai2.dtbo \
    freescale/overlays/maaxboard-ext-spi.dtbo \
    freescale/overlays/maaxboard-ext-uart2.dtbo \
    freescale/overlays/maaxboard-ext-wm8960.dtbo \
    freescale/overlays/maaxboard-hdmi.dtbo \
    freescale/overlays/maaxboard-mipi.dtbo \
    freescale/overlays/maaxboard-ov5640.dtbo \
    freescale/overlays/maaxboard-usb0-device.dtbo \
"

do_compile:append() {
    if [ -n "${KERNEL_DTC_FLAGS}" ]; then
        export DTC_FLAGS="${KERNEL_DTC_FLAGS}"
    fi

    for dtbf in ${KERNEL_DEVICETREE2}; do
        dtb=`normalize_dtb "$dtbf"`
        oe_runmake $dtb CC="${KERNEL_CC} $cc_extra " LD="${KERNEL_LD}" ${KERNEL_EXTRA_ARGS}
    done
}

do_deploy:append(){
    install -d ${DEPLOYDIR}/overlays
    cp ${WORKDIR}/build/arch/arm64/boot/dts/freescale/overlays/* ${DEPLOYDIR}/overlays
}
