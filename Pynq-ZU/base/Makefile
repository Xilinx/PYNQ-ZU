# Copyright (C) 2021-2025 Xilinx, Inc
# SPDX-License-Identifier: BSD-3-Clause

overlay_name := base
design_name := base

all: block_design bitstream check_timing
	@echo
	@tput setaf 2 ; echo "Built $(overlay_name) successfully!"; tput sgr0;
	@echo

hls_ip:
	git submodule init && git submodule update
	vivado -mode batch -source build_ip.tcl -notrace

block_design: hls_ip
	vivado -mode batch -source $(overlay_name).tcl -notrace

bitstream:
	vivado -mode batch -source build_bitstream.tcl -notrace

check_timing:
	vivado -mode batch -source check_timing.tcl -notrace

clean:
	rm -rf $(overlay_name) *.jou *.log NA .Xil *.zip *.str
