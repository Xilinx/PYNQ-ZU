# Copyright (C) 2021 Xilinx, Inc
# SPDX-License-Identifier: BSD-3-Clause

# Rebuild HLS IP from source
set current_dir [pwd]

# get list of IP from folder names
set ip {color_convert_2 pixel_pack_2 pixel_unpack_2 trace_cntrl_32 trace_cntrl_64 }
set ip_version {"1.0" "1.0" "1.0" "1.4" "1.4"}
# Check and build each IP
foreach item $ip version $ip_version {
   if {[catch { glob -directory ./ip/hls/${item}/${item}_zu_solution/impl/ip/ *.zip} zip_file]} {
# Build IP only if a packaged IP does not exist
      puts "Building $item IP"
      puts "vitis_hls -f ./build_hls_ip.tcl -tclargs ${item} ${version}"
      exec vitis_hls -f ./build_hls_ip.tcl -tclargs ${item} ${version}
   } else {
# Skip IP when a packaged IP exists in ip directory
      puts "Skipping building $item"
   }
   unset zip_file
# Testing the built IP
   puts "Checking $item"
   set fd [open ./ip/hls/${item}/${item}_zu_solution/syn/report/${item}_csynth.rpt r]
   set timing_flag 0
   set latency_flag 0
   while { [gets $fd line] >= 0 } {
# Check whether the timing has been met
    if [string match {+ Timing: } $line]  { 
      set timing_flag 1
      set latency_flag 0
      continue
    }
    if {$timing_flag == 1} {
      if [regexp {[0-9]+} $line]  {
        set period [regexp -all -inline {[0-9]*\.[0-9]*} $line]
        lassign $period target estimated uncertainty
        if {$target < $estimated} {
            puts "ERROR: Estimated clock period $estimated > target $target."
            puts "ERROR: Revise $item to be compatible with Vitis HLS."
            exit 1
        }
      }
    }
# Check whether the II has been met
    if [string match {+ Latency: } $line]  { 
      set timing_flag 0
      set latency_flag 1
      continue
    }
    if {$latency_flag == 1} {
      if [regexp {[0-9]+} $line]  {
        set interval [regexp -all -inline {[0-9]*\.*[0-9]*} $line]
        lassign $interval lc_min lc_max la_min la_max achieved target
        if {$achieved != $target} {
            puts "ERROR: Achieved II $achieved != target $target."
            puts "ERROR: Revise $item to be compatible with Vitis HLS."
            exit 1
        }
      }
    }
# Testing ends
    if [string match {== Utilization Estimates} $line]  { 
       unset timing_flag latency_flag period interval
       break
    }
   }
   unset fd
}
cd $current_dir
puts "HLS IP builds complete"
