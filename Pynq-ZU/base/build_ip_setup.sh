#!/bin/bash

# Copyright (C) 2021 Xilinx, Inc
# SPDX-License-Identifier: BSD-3-Clause


set -x
set -e

if [ ! -d "./ip" ]; then
    if [ -d "../../ip" ]; then
        cp -rf ../../ip ./ip
    else
        git clone https://github.com/Xilinx/PYNQ.git -b image_v2.7 --depth 1 pynq_git
        cp -rf pynq_git/boards/ip ./ip
        rm -rf pynq_git
    fi
fi
