# Copyright (C) 2021 Xilinx, Inc
# SPDX-License-Identifier: BSD-3-Clause

if { $argc != 4 } {
    puts "The script requires the name of the IP to be passed as a tcl argument."
    puts "For example, hls_build_script.tcl -tcl_args ip_name"
    puts [llength $argv]
    puts "Arguments:"
    foreach i $argv {puts $i}
} else {
    set ip_name [lindex $argv 2]
    set version [lindex $argv 3]
}
cd ./ip/hls/
open_project ${ip_name}
set_top ${ip_name}
foreach src [glob -directory ${ip_name} *.cpp] {
    add_files ${src}
}
open_solution ${ip_name}_zu_solution
set_part {xczu7ev-ffvc1156-2-i}
create_clock -period 3.3
csynth_design
export_design -format ip_catalog -description [concat "PYNQ ZU " ${ip_name}] -version $version -display_name [concat "PYNQ ZU " ${ip_name}] 
cd ../../..
exit
