#!/bin/bash

# Copyright (C) 2021 Xilinx, Inc
# SPDX-License-Identifier: BSD-3-Clause

set -x
set -e

. /etc/environment
export HOME=/root

pynq_dir="$(pip3 show pynq | grep '^Location' | cut -d : -f 2)/pynq"

cd /home/xilinx

rm -rf $pynq_dir/lib/rpi/bsp_iop_rpi
rsync -rptL pynq_patch/ $pynq_dir/
rm -rf pynq_patch

echo "from .gc import GC" >> $pynq_dir/lib/__init__.py
