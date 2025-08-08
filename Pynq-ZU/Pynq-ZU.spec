# Copyright (C) 2021-2025 Xilinx, Inc
# SPDX-License-Identifier: BSD-3-Clause

ARCH_Pynq-ZU := aarch64
BSP_Pynq-ZU := 
BITSTREAM_Pynq-ZU := base/base.bit
FPGA_MANAGER_Pynq-ZU := 1

STAGE4_PACKAGES_Pynq-ZU := pynq usbgadget usb-eth0 boot_leds
STAGE4_PACKAGES_Pynq-ZU += vbus-det python_pmbus sensorconf
STAGE4_PACKAGES_Pynq-ZU += xrt pynq_peripherals pynq_selftest
STAGE4_PACKAGES_Pynq-ZU += wilc3000
STAGE4_PACKAGES_Pynq-ZU += pynqmb_grove
