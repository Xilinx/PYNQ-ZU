#!/bin/bash

# Copyright (C) 2021 Xilinx, Inc
# SPDX-License-Identifier: BSD-3-Clause

set -x
set -e

. /etc/environment
export HOME=/root

cd /home/xilinx

pip3 install *.tar.gz --no-deps

rm -f *.tar.gz
