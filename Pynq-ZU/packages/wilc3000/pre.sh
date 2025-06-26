#! /bin/bash

# Copyright (C) 2022 Xilinx, Inc
# SPDX-License-Identifier: BSD-3-Clause

target=$1
script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

sudo cp ${script_dir}/wpa_ap.service ${target}/lib/systemd/system
sudo cp -r ${script_dir}/wpa_ap ${target}/usr/local/share/
sudo mkdir ${target}/wilc_bld
sudo mkdir -p ${target}/lib/firmware/mchp
cd ${BUILD_ROOT}/${PYNQ_BOARD}/petalinux_project

petalinux-build -c wilc

src_dir="build/tmp/sysroots-components/*/wilc/lib/modules/"
kernel_version=$(ls {src_dir})

sudo mkdir -p ${target}/lib/modules/${kernel_version}/extra
sudo cp -rf ${src_dir}/*/updates/wilc-sdio.ko ${target}/lib/modules/${kernel_version}/extra/