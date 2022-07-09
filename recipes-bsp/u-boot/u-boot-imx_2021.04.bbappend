# FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

UBOOT_SRC = "${MAAXBOARD_GIT_HOST_MIRROR}/uboot-imx.git;protocol=https"
# TODO What is the right branch anyway?
SRCBRANCH = "maaxboard_v2021.04_5.10.35_2.0.0"
SRC_URI = "${UBOOT_SRC};branch=${SRCBRANCH}"
SRCREV = "f752480a4c29d3ff7fd4008863adc286019bf594"
# SRCREV_maaxboardmini = "18bbcf32381423d32067e9f0be62ce988c787257"
# SRCREV_maaxboardnano = "349e29cdae9a823dc1e8a3696e1f0f2bdd5b6c58"
