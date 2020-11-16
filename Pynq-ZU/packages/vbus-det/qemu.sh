#!/bin/bash

# Copyright (C) 2021 Xilinx, Inc
# SPDX-License-Identifier: BSD-3-Clause

set -x
set -e

# create a pulse to reset USB 3.0
systemctl enable vbus-det.service
