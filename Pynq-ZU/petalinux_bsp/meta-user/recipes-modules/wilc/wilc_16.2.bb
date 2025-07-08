# Copyright (C) 2022 Xilinx, Inc

# SPDX-License-Identifier: BSD-3-Clause

SUMMARY = "Recipe for building an external wilc Linux kernel module"
SECTION = "PETALINUX/modules"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/GPL-2.0-only;md5=801f80980d171dd6425610833a22dbe6"

inherit module

SRC_URI:append = " git://github.com/linux4sam/linux-at91.git;protocol=https;branch=${BRANCH};subpath=drivers/net/wireless/microchip/wilc1000"
SRC_URI += "file://0001-wilc-pynqzu.patch"

# linux-6.1-mchp branch from Apr 16, 2024
SRCREV = "99b20cea90ff1a05163da777cb95b0dae2016ef1"
BRANCH = "linux-6.1-mchp"

DEPENDS += "virtual/kernel"

S = "${WORKDIR}/wilc1000"

EXTRA_OEMAKE = 'CONFIG_WILC=y \
		WLAN_VENDOR_MCHP=y \
		CONFIG_WILC_SDIO=m \
		CONFIG_WILC_SPI=n \
		CONFIG_WILC1000_HW_OOB_INTR=n \
		KERNEL_SRC="${STAGING_KERNEL_DIR}" \
		O=${STAGING_KERNEL_BUILDDIR}'
