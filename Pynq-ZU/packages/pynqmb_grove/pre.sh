#!/bin/bash

# Copyright (C) 2021 Xilinx, Inc
# SPDX-License-Identifier: BSD-3-Clause

set -x
set -e

target=$1
script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd $script_dir
./build.sh

sudo cp -r $script_dir/pynq $target/home/xilinx/pynq_patch
