FILESEXTRAPATHS:prepend = "${THISDIR}/files:"

SRC_URI += "file://weston.service"

do_install:append() {
    install -d ${D}${sysconfdir}/systemd/system/multi-user.target.wants
    ln -sf /lib/systemd/system/weston.service ${D}${sysconfdir}/systemd/system/multi-user.target.wants/weston.service
}


FILES:${PN} += "\
    ${sysconfdir}/systemd/system/multi-user.target.wants/weston.service \
"
