#!/bin/bash

# Copyright (C) 2022 Xilinx, Inc
# SPDX-License-Identifier: BSD-3-Clause

set -e

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

pynq_path="../../../pynq/"
common_path="standalone_domain/bsp"

# build IO Processor (IOP) binaries
cd $script_dir/$pynq_path/boards/sw_repo
sed -i 's/ps7_cortexa9_0/psu_cortexa53_0/g' build_project.tcl
make clean && make XSA=$script_dir/../../base/base.xsa

cd $script_dir/$pynq_path/boards/sw_repo
rm -rf bsp_iop_grove_mb/iop_grove_mb/$common_path/iop_grove_mb/code
rm -rf bsp_iop_grove_mb/iop_grove_mb/$common_path/iop_grove_mb/libsrc
cp -rf bsp_iop_grove_mb/iop_grove_mb/$common_path \
    $script_dir/pynq/lib/gc/bsp_iop_grove

cd $script_dir/$pynq_path/boards/sw_repo
rm -rf bsp_iop_rpi_mb/iop_rpi_mb/$common_path/iop_rpi_mb/code
rm -rf bsp_iop_rpi_mb/iop_rpi_mb/$common_path/iop_rpi_mb/libsrc
mkdir -p $script_dir/pynq/lib/rpi
cp -rf bsp_iop_rpi_mb/iop_rpi_mb/$common_path \
    $script_dir/pynq/lib/rpi/bsp_iop_rpi

cd $script_dir/$pynq_path/boards/sw_repo
make clean
