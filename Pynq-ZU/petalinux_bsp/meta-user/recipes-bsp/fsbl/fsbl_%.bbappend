# Copyright (C) 2021 Xilinx, Inc
# SPDX-License-Identifier: BSD-3-Clause

SRC_URI_append = " \
        file://0001-syzygy-voltage-handshake.patch \
        "
  
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

#Enable appropriate FSBL debug flags  
YAML_COMPILER_FLAGS_append = " -DFSBL_PRINT"
