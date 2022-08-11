# Copyright (C) 2021 Xilinx, Inc
# SPDX-License-Identifier: BSD-3-Clause

SRC_URI:append = "file://bsp.cfg"
SRC_URI += "file://fix_pwrseq_simple.patch"

FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
