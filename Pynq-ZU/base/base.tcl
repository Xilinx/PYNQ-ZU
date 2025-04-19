###############################################################################
 #  Copyright (c) 2020-2025, Xilinx, Inc.
 #  All rights reserved.
 #
 #  Redistribution and use in source and binary forms, with or without
 #  modification, are permitted provided that the following conditions are met:
 #
 #  1.  Redistributions of source code must retain the above copyright notice,
 #     this list of conditions and the following disclaimer.
 #
 #  2.  Redistributions in binary form must reproduce the above copyright
 #      notice, this list of conditions and the following disclaimer in the
 #      documentation and/or other materials provided with the distribution.
 #
 #  3.  Neither the name of the copyright holder nor the names of its
 #      contributors may be used to endorse or promote products derived from
 #      this software without specific prior written permission.
 #
 #  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 #  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
 #  THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 #  PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
 #  CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 #  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 #  PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
 #  OR BUSINESS INTERRUPTION). HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 #  WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
 #  OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 #  ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 #
###############################################################################
###############################################################################
 #
 #
 # @file base.tcl
 #
 # Vivado tcl script to generate the bitstream base.bit.
 #
 # <pre>
 # MODIFICATION HISTORY:
 #
 # Ver   Who  Date     Changes
 # ----- --- -------- -----------------------------------------------
 # 2.00a pp   09/30/2020 Updated 2019.1 version to 2020.1
 #	                 Changed pr_axi_shutdown_manager to dfx_axi_shutdown_manager
 #			  Changed v_proc_ss:2.1 to v_proc_ss:2.2
 # 2.00b pp	  Fixed DMA address space bug of the pmod0_trace_analyzer
 # 2.00c pp   Xilinx board store support added
 # 2.00d pp   Added Address Remapper IP to remap MB access to upper 2 GB of 
 #            LOW_DDR
 # 2.00e pp   replaced zynq targeting trace controllers with mpsoc targeting
 #            controller
 # 2.00f pp   Update ip repository path to point to the board's local repository
 #
 # 2.10a mr   Fixed pixel channel arrangement, disable MM2S and unaligned
 #            transfers in mipi vdma. Add pixel pack in mipi hierarchy
 #
 # 2.70 mr    Update to Vivado 2020.2
 #
 # 3.00 mr     Update to Vivado 2022.1
 #
 # 3.10 mr     Update to Vivado 2024.1
 #
 # </pre>
 #
###############################################################################

################################################################
# This is a generated script based on design: base
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2024.1
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_gid_msg -ssname BD::TCL -id 2041 -severity "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# Check if target board is in board_files database.
################################################################
set_param board.repoPaths [get_property LOCAL_ROOT_DIR [xhub::get_xstores xilinx_board_store]]

set board [get_board_parts "*:pynqzu:*" -latest_file_version]
if { ${board} eq "" } {
    xhub::refresh_catalog [xhub::get_xstores xilinx_board_store]
    xhub::install [xhub::get_xitems "tul.com.tw:xilinx_board_store:pynqzu:*"]
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source base_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./base/base.xpr> in the current working folder.

set overlay_name base
set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project ${overlay_name} ${overlay_name} -part xczu5eg-sfvc784-1-e
   set_property BOARD_PART tul.com.tw:pynqzu:part0:1.1 [current_project]
}

set_property ip_repo_paths "./../../pynq/boards/ip/"  [current_project]
update_ip_catalog

# CHANGE DESIGN NAME HERE
variable design_name
set design_name base

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_gid_msg -ssname BD::TCL -id 2001 -severity "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_gid_msg -ssname BD::TCL -id 2002 -severity "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_gid_msg -ssname BD::TCL -id 2003 -severity "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_gid_msg -ssname BD::TCL -id 2004 -severity "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_gid_msg -ssname BD::TCL -id 2005 -severity "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_gid_msg -ssname BD::TCL -id 2006 -severity "ERROR" $errMsg}
   return $nRet
}

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
xilinx.com:ip:axi_iic:2.1\
user.org:user:address_remap:1.0\
xilinx.com:user:audio_codec_ctrl:1.0\
xilinx.com:ip:axi_intc:4.1\
xilinx.com:ip:axi_register_slice:2.1\
xilinx.com:ip:smartconnect:1.0\
xilinx.com:ip:clk_wiz:6.0\
xilinx.com:ip:xlconcat:2.1\
xilinx.com:ip:xlconstant:1.1\
xilinx.com:ip:axi_gpio:2.0\
xilinx.com:ip:util_ds_buf:2.2\
xilinx.com:ip:xlslice:1.0\
xilinx.com:ip:mdm:3.2\
xilinx.com:ip:proc_sys_reset:5.0\
xilinx.com:ip:zynq_ultra_ps_e:3.5\
xilinx.com:ip:dfx_axi_shutdown_manager:1.0\
xilinx.com:ip:system_management_wiz:1.3\
xilinx.com:user:dff_en_reset_vector:1.0\
xilinx.com:user:io_switch:1.1\
xilinx.com:ip:microblaze:11.0\
xilinx.com:ip:axi_bram_ctrl:4.1\
xilinx.com:ip:axi_timer:2.0\
xilinx.com:ip:axi_quad_spi:3.2\
xilinx.com:ip:axi_uartlite:2.0\
xilinx.com:ip:axi_vdma:6.3\
xilinx.com:ip:axis_register_slice:1.1\
xilinx.com:ip:axis_subset_converter:1.1\
xilinx.com:ip:v_demosaic:1.1\
xilinx.com:ip:v_gamma_lut:1.1\
xilinx.com:ip:mipi_csi2_rx_subsystem:6.0\
xilinx.com:ip:v_proc_ss:2.3\
xilinx.com:ip:axi_dma:7.1\
xilinx.com:ip:axis_data_fifo:2.0\
xilinx.com:hls:trace_cntrl_64:1.4\
xilinx.com:hls:trace_cntrl_32:1.4\
xilinx.com:ip:lmb_v10:3.0\
xilinx.com:ip:blk_mem_gen:8.4\
xilinx.com:ip:lmb_bram_if_cntlr:4.0\
xilinx.com:hls:color_convert_2:1.0\
xilinx.com:ip:v_hdmi_rx_ss:3.2\
xilinx.com:hls:pixel_pack_2:1.0\
xilinx.com:ip:v_hdmi_tx_ss:3.2\
xilinx.com:hls:pixel_unpack_2:1.0\
xilinx.com:ip:vid_phy_controller:2.2\
"

   set list_ips_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2011 -severity "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2012 -severity "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

if { $bCheckIPsPassed != 1 } {
  common::send_gid_msg -ssname BD::TCL -id 2023 -severity "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################


# Hierarchical cell: phy
proc create_hier_cell_phy { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_phy() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 vid_phy_axi4lite

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 vid_phy_rx_axi4s_ch0

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 vid_phy_rx_axi4s_ch1

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 vid_phy_rx_axi4s_ch2

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 vid_phy_status_sb_rx

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 vid_phy_status_sb_tx

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 vid_phy_tx_axi4s_ch0

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 vid_phy_tx_axi4s_ch1

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 vid_phy_tx_axi4s_ch2


  # Create pins
  create_bd_pin -dir I -type clk HDMI_RX_CLK_N_IN
  create_bd_pin -dir I -type clk HDMI_RX_CLK_P_IN
  create_bd_pin -dir I -from 2 -to 0 HDMI_RX_DAT_N_IN
  create_bd_pin -dir I -from 2 -to 0 HDMI_RX_DAT_P_IN
  create_bd_pin -dir I HDMI_SI5324_LOL_IN
  create_bd_pin -dir O -type clk HDMI_TX_CLK_N_OUT
  create_bd_pin -dir O -type clk HDMI_TX_CLK_P_OUT
  create_bd_pin -dir O -from 2 -to 0 HDMI_TX_DAT_N_OUT
  create_bd_pin -dir O -from 2 -to 0 HDMI_TX_DAT_P_OUT
  create_bd_pin -dir O -type clk RX_REFCLK_N_OUT
  create_bd_pin -dir O -type clk RX_REFCLK_P_OUT
  create_bd_pin -dir I -type rst TX_EN_OUT
  create_bd_pin -dir I -type clk TX_REFCLK_N_IN
  create_bd_pin -dir I -type clk TX_REFCLK_P_IN
  create_bd_pin -dir O -type intr irq2
  create_bd_pin -dir O -type clk rx_video_clk
  create_bd_pin -dir I -type clk s_axi_cpu_aclk
  create_bd_pin -dir I -type rst s_axi_cpu_aresetn
  create_bd_pin -dir O -type clk tx_video_clk
  create_bd_pin -dir O -type clk vid_phy_rx_axi4s_aclk
  create_bd_pin -dir O -type clk vid_phy_tx_axi4s_aclk

  # Create instance: vid_phy_controller, and set properties
  set vid_phy_controller [ create_bd_cell -type ip -vlnv xilinx.com:ip:vid_phy_controller:2.2 vid_phy_controller ]
  set_property -dict [ list \
   CONFIG.CHANNEL_ENABLE {X0Y4 X0Y5 X0Y6} \
   CONFIG.CHANNEL_SITE {X0Y4} \
   CONFIG.C_INPUT_PIXELS_PER_CLOCK {2} \
   CONFIG.C_INT_HDMI_VER_CMPTBLE {3} \
   CONFIG.C_NIDRU {false} \
   CONFIG.C_NIDRU_REFCLK_SEL {0} \
   CONFIG.C_RX_PLL_SELECTION {0} \
   CONFIG.C_RX_REFCLK_SEL {1} \
   CONFIG.C_Rx_Protocol {HDMI} \
   CONFIG.C_TX_PLL_SELECTION {6} \
   CONFIG.C_TX_REFCLK_SEL {0} \
   CONFIG.C_Tx_Protocol {HDMI} \
   CONFIG.C_Txrefclk_Rdy_Invert {true} \
   CONFIG.C_Use_Oddr_for_Tmds_Clkout {true} \
   CONFIG.C_vid_phy_rx_axi4s_ch_INT_TDATA_WIDTH {20} \
   CONFIG.C_vid_phy_rx_axi4s_ch_TDATA_WIDTH {20} \
   CONFIG.C_vid_phy_rx_axi4s_ch_TUSER_WIDTH {1} \
   CONFIG.C_vid_phy_tx_axi4s_ch_INT_TDATA_WIDTH {20} \
   CONFIG.C_vid_phy_tx_axi4s_ch_TDATA_WIDTH {20} \
   CONFIG.C_vid_phy_tx_axi4s_ch_TUSER_WIDTH {1} \
   CONFIG.Rx_GT_Line_Rate {5.94} \
   CONFIG.Rx_GT_Ref_Clock_Freq {297} \
   CONFIG.Transceiver_Width {2} \
   CONFIG.Tx_GT_Line_Rate {5.94} \
   CONFIG.Tx_GT_Ref_Clock_Freq {297} \
 ] $vid_phy_controller

  # Create interface connections
  connect_bd_intf_net -intf_net intf_net_v_hdmi_tx_ss_LINK_DATA0_OUT [get_bd_intf_pins vid_phy_tx_axi4s_ch0] [get_bd_intf_pins vid_phy_controller/vid_phy_tx_axi4s_ch0]
  connect_bd_intf_net -intf_net intf_net_v_hdmi_tx_ss_LINK_DATA1_OUT [get_bd_intf_pins vid_phy_tx_axi4s_ch1] [get_bd_intf_pins vid_phy_controller/vid_phy_tx_axi4s_ch1]
  connect_bd_intf_net -intf_net intf_net_v_hdmi_tx_ss_LINK_DATA2_OUT [get_bd_intf_pins vid_phy_tx_axi4s_ch2] [get_bd_intf_pins vid_phy_controller/vid_phy_tx_axi4s_ch2]
  connect_bd_intf_net -intf_net intf_net_vid_phy_controller_vid_phy_rx_axi4s_ch0 [get_bd_intf_pins vid_phy_rx_axi4s_ch0] [get_bd_intf_pins vid_phy_controller/vid_phy_rx_axi4s_ch0]
  connect_bd_intf_net -intf_net intf_net_vid_phy_controller_vid_phy_rx_axi4s_ch1 [get_bd_intf_pins vid_phy_rx_axi4s_ch1] [get_bd_intf_pins vid_phy_controller/vid_phy_rx_axi4s_ch1]
  connect_bd_intf_net -intf_net intf_net_vid_phy_controller_vid_phy_rx_axi4s_ch2 [get_bd_intf_pins vid_phy_rx_axi4s_ch2] [get_bd_intf_pins vid_phy_controller/vid_phy_rx_axi4s_ch2]
  connect_bd_intf_net -intf_net intf_net_vid_phy_controller_vid_phy_status_sb_rx [get_bd_intf_pins vid_phy_status_sb_rx] [get_bd_intf_pins vid_phy_controller/vid_phy_status_sb_rx]
  connect_bd_intf_net -intf_net intf_net_vid_phy_controller_vid_phy_status_sb_tx [get_bd_intf_pins vid_phy_status_sb_tx] [get_bd_intf_pins vid_phy_controller/vid_phy_status_sb_tx]
  connect_bd_intf_net -intf_net intf_net_zynq_us_ss_0_M00_AXI [get_bd_intf_pins vid_phy_axi4lite] [get_bd_intf_pins vid_phy_controller/vid_phy_axi4lite]

  # Create port connections
  connect_bd_net -net net_bdry_in_HDMI_RX_CLK_N_IN [get_bd_pins HDMI_RX_CLK_N_IN] [get_bd_pins vid_phy_controller/mgtrefclk1_pad_n_in]
  connect_bd_net -net net_bdry_in_HDMI_RX_CLK_P_IN [get_bd_pins HDMI_RX_CLK_P_IN] [get_bd_pins vid_phy_controller/mgtrefclk1_pad_p_in]
  connect_bd_net -net net_bdry_in_HDMI_RX_DAT_N_IN [get_bd_pins HDMI_RX_DAT_N_IN] [get_bd_pins vid_phy_controller/phy_rxn_in]
  connect_bd_net -net net_bdry_in_HDMI_RX_DAT_P_IN [get_bd_pins HDMI_RX_DAT_P_IN] [get_bd_pins vid_phy_controller/phy_rxp_in]
  connect_bd_net -net net_bdry_in_HDMI_SI5324_LOL_IN [get_bd_pins HDMI_SI5324_LOL_IN] [get_bd_pins vid_phy_controller/tx_refclk_rdy]
  connect_bd_net -net net_bdry_in_TX_REFCLK_N_IN [get_bd_pins TX_REFCLK_N_IN] [get_bd_pins vid_phy_controller/mgtrefclk0_pad_n_in]
  connect_bd_net -net net_bdry_in_TX_REFCLK_P_IN [get_bd_pins TX_REFCLK_P_IN] [get_bd_pins vid_phy_controller/mgtrefclk0_pad_p_in]
  connect_bd_net -net net_vcc_const_dout [get_bd_pins TX_EN_OUT] [get_bd_pins vid_phy_controller/vid_phy_rx_axi4s_aresetn] [get_bd_pins vid_phy_controller/vid_phy_tx_axi4s_aresetn]
  connect_bd_net -net net_vid_phy_controller_irq [get_bd_pins irq2] [get_bd_pins vid_phy_controller/irq]
  connect_bd_net -net net_vid_phy_controller_phy_txn_out [get_bd_pins HDMI_TX_DAT_N_OUT] [get_bd_pins vid_phy_controller/phy_txn_out]
  connect_bd_net -net net_vid_phy_controller_phy_txp_out [get_bd_pins HDMI_TX_DAT_P_OUT] [get_bd_pins vid_phy_controller/phy_txp_out]
  connect_bd_net -net net_vid_phy_controller_rx_tmds_clk_n [get_bd_pins RX_REFCLK_N_OUT] [get_bd_pins vid_phy_controller/rx_tmds_clk_n]
  connect_bd_net -net net_vid_phy_controller_rx_tmds_clk_p [get_bd_pins RX_REFCLK_P_OUT] [get_bd_pins vid_phy_controller/rx_tmds_clk_p]
  connect_bd_net -net net_vid_phy_controller_rx_video_clk [get_bd_pins rx_video_clk] [get_bd_pins vid_phy_controller/rx_video_clk]
  connect_bd_net -net net_vid_phy_controller_rxoutclk [get_bd_pins vid_phy_rx_axi4s_aclk] [get_bd_pins vid_phy_controller/rxoutclk] [get_bd_pins vid_phy_controller/vid_phy_rx_axi4s_aclk]
  connect_bd_net -net net_vid_phy_controller_tx_tmds_clk_n [get_bd_pins HDMI_TX_CLK_N_OUT] [get_bd_pins vid_phy_controller/tx_tmds_clk_n]
  connect_bd_net -net net_vid_phy_controller_tx_tmds_clk_p [get_bd_pins HDMI_TX_CLK_P_OUT] [get_bd_pins vid_phy_controller/tx_tmds_clk_p]
  connect_bd_net -net net_vid_phy_controller_tx_video_clk [get_bd_pins tx_video_clk] [get_bd_pins vid_phy_controller/tx_video_clk]
  connect_bd_net -net net_vid_phy_controller_txoutclk [get_bd_pins vid_phy_tx_axi4s_aclk] [get_bd_pins vid_phy_controller/txoutclk] [get_bd_pins vid_phy_controller/vid_phy_tx_axi4s_aclk]
  connect_bd_net -net net_zynq_us_ss_0_peripheral_aresetn [get_bd_pins s_axi_cpu_aresetn] [get_bd_pins vid_phy_controller/vid_phy_axi4lite_aresetn] [get_bd_pins vid_phy_controller/vid_phy_sb_aresetn]
  connect_bd_net -net net_zynq_us_ss_0_s_axi_aclk [get_bd_pins s_axi_cpu_aclk] [get_bd_pins vid_phy_controller/drpclk] [get_bd_pins vid_phy_controller/vid_phy_axi4lite_aclk] [get_bd_pins vid_phy_controller/vid_phy_sb_aclk]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: hdmi_out
proc create_hier_cell_hdmi_out { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_hdmi_out() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 LINK_DATA0_OUT

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 LINK_DATA1_OUT

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 LINK_DATA2_OUT

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 SB_STATUS_IN

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_CPU_IN

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 TX_DDC_OUT

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_control

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_control1

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 stream_in_64


  # Create pins
  create_bd_pin -dir I TX_HPD_IN
  create_bd_pin -dir I -type clk aclk
  create_bd_pin -dir I acr_valid
  create_bd_pin -dir I -type rst aresetn
  create_bd_pin -dir I fid
  create_bd_pin -dir O -type intr irq1
  create_bd_pin -dir I -type clk link_clk
  create_bd_pin -dir I -type clk s_axi_cpu_aclk
  create_bd_pin -dir I -type rst s_axi_cpu_aresetn
  create_bd_pin -dir I -type clk s_axis_audio_aclk
  create_bd_pin -dir I -type rst s_axis_audio_aresetn
  create_bd_pin -dir I -type clk video_clk

  # Create instance: color_convert, and set properties
  set color_convert [ create_bd_cell -type ip -vlnv xilinx.com:hls:color_convert_2:1.0 color_convert ]

  # Create instance: frontend, and set properties
  set frontend [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_hdmi_tx_ss:3.2 frontend ]
  set_property -dict [ list \
   CONFIG.C_ADDR_WIDTH {13} \
   CONFIG.C_ADD_MARK_DBG {false} \
   CONFIG.C_EXDES_AXILITE_FREQ {100} \
   CONFIG.C_EXDES_NIDRU {true} \
   CONFIG.C_EXDES_RX_PLL_SELECTION {0} \
   CONFIG.C_EXDES_TOPOLOGY {0} \
   CONFIG.C_EXDES_TX_PLL_SELECTION {6} \
   CONFIG.C_HDMI_FAST_SWITCH {true} \
   CONFIG.C_HDMI_VERSION {3} \
   CONFIG.C_HPD_INVERT {false} \
   CONFIG.C_HYSTERESIS_LEVEL {12} \
   CONFIG.C_INCLUDE_HDCP_1_4 {false} \
   CONFIG.C_INCLUDE_HDCP_2_2 {false} \
   CONFIG.C_INCLUDE_LOW_RESO_VID {false} \
   CONFIG.C_INCLUDE_YUV420_SUP {false} \
   CONFIG.C_INPUT_PIXELS_PER_CLOCK {2} \
   CONFIG.C_MAX_BITS_PER_COMPONENT {8} \
   CONFIG.C_VALIDATION_ENABLE {false} \
   CONFIG.C_VIDEO_MASK_ENABLE {1} \
   CONFIG.C_VID_INTERFACE {0} \
 ] $frontend

  # Create instance: pixel_reorder, and set properties
  set pixel_reorder [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_subset_converter:1.1 pixel_reorder ]
  set_property -dict [ list \
   CONFIG.M_TDATA_NUM_BYTES {6} \
   CONFIG.S_TDATA_NUM_BYTES {6} \
   CONFIG.TDATA_REMAP {tdata[47:40],tdata[31:24],tdata[39:32],tdata[23:16],tdata[7:0],tdata[15:8]} \
 ] $pixel_reorder

  # Create instance: pixel_unpack, and set properties
  set pixel_unpack [ create_bd_cell -type ip -vlnv xilinx.com:hls:pixel_unpack_2:1.0 pixel_unpack ]

  # Create instance: tx_video_axis_reg_slice, and set properties
  set tx_video_axis_reg_slice [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 tx_video_axis_reg_slice ]

  # Create interface connections
  connect_bd_intf_net -intf_net axi_interconnect_M07_AXI [get_bd_intf_pins s_axi_control] [get_bd_intf_pins color_convert/s_axi_control]
  connect_bd_intf_net -intf_net axi_interconnect_M10_AXI [get_bd_intf_pins s_axi_control1] [get_bd_intf_pins pixel_unpack/s_axi_control]
  connect_bd_intf_net -intf_net axi_vdma_0_M_AXIS_MM2S [get_bd_intf_pins stream_in_64] [get_bd_intf_pins pixel_unpack/stream_in_64]
  connect_bd_intf_net -intf_net axis_subset_converter_0_M_AXIS [get_bd_intf_pins frontend/VIDEO_IN] [get_bd_intf_pins pixel_reorder/M_AXIS]
  connect_bd_intf_net -intf_net color_convert_0_stream_out_48 [get_bd_intf_pins color_convert/stream_out_48] [get_bd_intf_pins tx_video_axis_reg_slice/S_AXIS]
  connect_bd_intf_net -intf_net intf_net_v_hdmi_tx_ss_DDC_OUT [get_bd_intf_pins TX_DDC_OUT] [get_bd_intf_pins frontend/DDC_OUT]
  connect_bd_intf_net -intf_net intf_net_v_hdmi_tx_ss_LINK_DATA0_OUT [get_bd_intf_pins LINK_DATA0_OUT] [get_bd_intf_pins frontend/LINK_DATA0_OUT]
  connect_bd_intf_net -intf_net intf_net_v_hdmi_tx_ss_LINK_DATA1_OUT [get_bd_intf_pins LINK_DATA1_OUT] [get_bd_intf_pins frontend/LINK_DATA1_OUT]
  connect_bd_intf_net -intf_net intf_net_v_hdmi_tx_ss_LINK_DATA2_OUT [get_bd_intf_pins LINK_DATA2_OUT] [get_bd_intf_pins frontend/LINK_DATA2_OUT]
  connect_bd_intf_net -intf_net intf_net_vid_phy_controller_vid_phy_status_sb_tx [get_bd_intf_pins SB_STATUS_IN] [get_bd_intf_pins frontend/SB_STATUS_IN]
  connect_bd_intf_net -intf_net intf_net_zynq_us_ss_0_M02_AXI [get_bd_intf_pins S_AXI_CPU_IN] [get_bd_intf_pins frontend/S_AXI_CPU_IN]
  connect_bd_intf_net -intf_net pixel_unpack_0_stream_out_48 [get_bd_intf_pins color_convert/stream_in_48] [get_bd_intf_pins pixel_unpack/stream_out_48]
  connect_bd_intf_net -intf_net tx_video_axis_reg_slice_M_AXIS [get_bd_intf_pins pixel_reorder/S_AXIS] [get_bd_intf_pins tx_video_axis_reg_slice/M_AXIS]

  # Create port connections
  connect_bd_net -net acr_valid_1 [get_bd_pins acr_valid] [get_bd_pins frontend/acr_valid]
  connect_bd_net -net net_bdry_in_TX_HPD_IN [get_bd_pins TX_HPD_IN] [get_bd_pins frontend/hpd]
  connect_bd_net -net net_v_hdmi_rx_ss_fid [get_bd_pins fid] [get_bd_pins frontend/fid]
  connect_bd_net -net net_v_hdmi_tx_ss_irq [get_bd_pins irq1] [get_bd_pins frontend/irq]
  connect_bd_net -net net_v_hdmi_tx_ss_locked [get_bd_pins frontend/locked]
  connect_bd_net -net net_vid_phy_controller_tx_video_clk [get_bd_pins video_clk] [get_bd_pins frontend/video_clk]
  connect_bd_net -net net_vid_phy_controller_txoutclk [get_bd_pins link_clk] [get_bd_pins frontend/link_clk]
  connect_bd_net -net net_zynq_us_ss_0_clk_out2 [get_bd_pins aclk] [get_bd_pins color_convert/ap_clk] [get_bd_pins color_convert/control] [get_bd_pins frontend/s_axis_video_aclk] [get_bd_pins pixel_reorder/aclk] [get_bd_pins pixel_unpack/ap_clk] [get_bd_pins pixel_unpack/control] [get_bd_pins tx_video_axis_reg_slice/aclk]
  connect_bd_net -net net_zynq_us_ss_0_dcm_locked [get_bd_pins aresetn] [get_bd_pins color_convert/ap_rst_n] [get_bd_pins color_convert/ap_rst_n_control] [get_bd_pins frontend/s_axis_video_aresetn] [get_bd_pins pixel_reorder/aresetn] [get_bd_pins pixel_unpack/ap_rst_n] [get_bd_pins pixel_unpack/ap_rst_n_control] [get_bd_pins tx_video_axis_reg_slice/aresetn]
  connect_bd_net -net net_zynq_us_ss_0_peripheral_aresetn [get_bd_pins s_axi_cpu_aresetn] [get_bd_pins frontend/s_axi_cpu_aresetn]
  connect_bd_net -net net_zynq_us_ss_0_s_axi_aclk [get_bd_pins s_axi_cpu_aclk] [get_bd_pins frontend/s_axi_cpu_aclk]
  connect_bd_net -net s_axis_audio_aclk_1 [get_bd_pins s_axis_audio_aclk] [get_bd_pins frontend/s_axis_audio_aclk]
  connect_bd_net -net s_axis_audio_aresetn_1 [get_bd_pins s_axis_audio_aresetn] [get_bd_pins frontend/s_axis_audio_aresetn]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: hdmi_in
proc create_hier_cell_hdmi_in { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_hdmi_in() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 LINK_DATA0_IN

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 LINK_DATA1_IN

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 LINK_DATA2_IN

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 RX_DDC_OUT

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 SB_STATUS_IN

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_CPU_IN

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_control

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_control1

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 stream_out_64


  # Create pins
  create_bd_pin -dir I RX_DET_IN
  create_bd_pin -dir O RX_HPD_OUT
  create_bd_pin -dir I -type clk aclk
  create_bd_pin -dir I -type rst aresetn
  create_bd_pin -dir O fid
  create_bd_pin -dir O -type intr irq
  create_bd_pin -dir I -type clk link_clk
  create_bd_pin -dir I -type clk s_axi_cpu_aclk
  create_bd_pin -dir I -type rst s_axi_cpu_aresetn
  create_bd_pin -dir I -type clk s_axis_audio_aclk
  create_bd_pin -dir I -type rst s_axis_audio_aresetn
  create_bd_pin -dir I -type clk video_clk

  # Create instance: color_convert, and set properties
  set color_convert [ create_bd_cell -type ip -vlnv xilinx.com:hls:color_convert_2:1.0 color_convert ]

  # Create instance: frontend, and set properties
  set frontend [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_hdmi_rx_ss:3.2 frontend ]
  set_property -dict [ list \
   CONFIG.C_ADDR_WIDTH {10} \
   CONFIG.C_ADD_MARK_DBG {false} \
   CONFIG.C_CD_INVERT {true} \
   CONFIG.C_EDID_RAM_SIZE {256} \
   CONFIG.C_HDMI_FAST_SWITCH {true} \
   CONFIG.C_HDMI_VERSION {3} \
   CONFIG.C_HPD_INVERT {false} \
   CONFIG.C_INCLUDE_HDCP_1_4 {false} \
   CONFIG.C_INCLUDE_HDCP_2_2 {false} \
   CONFIG.C_INCLUDE_LOW_RESO_VID {false} \
   CONFIG.C_INCLUDE_YUV420_SUP {false} \
   CONFIG.C_INPUT_PIXELS_PER_CLOCK {2} \
   CONFIG.C_MAX_BITS_PER_COMPONENT {8} \
   CONFIG.C_VALIDATION_ENABLE {false} \
   CONFIG.C_VID_INTERFACE {0} \
 ] $frontend

  # Create instance: pixel_pack, and set properties
  set pixel_pack [ create_bd_cell -type ip -vlnv xilinx.com:hls:pixel_pack_2:1.0 pixel_pack ]

  # Create instance: pixel_reorder, and set properties
  set pixel_reorder [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_subset_converter:1.1 pixel_reorder ]
  set_property -dict [ list \
   CONFIG.M_TDATA_NUM_BYTES {6} \
   CONFIG.S_TDATA_NUM_BYTES {6} \
   CONFIG.TDATA_REMAP {tdata[47:40],tdata[31:24],tdata[39:32],tdata[23:16],tdata[7:0],tdata[15:8]} \
 ] $pixel_reorder

  # Create instance: rx_video_axis_reg_slice, and set properties
  set rx_video_axis_reg_slice [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 rx_video_axis_reg_slice ]

  # Create interface connections
  connect_bd_intf_net -intf_net axi_interconnect_M08_AXI [get_bd_intf_pins s_axi_control] [get_bd_intf_pins color_convert/s_axi_control]
  connect_bd_intf_net -intf_net axi_interconnect_M09_AXI [get_bd_intf_pins s_axi_control1] [get_bd_intf_pins pixel_pack/s_axi_control]
  connect_bd_intf_net -intf_net color_convert_1_stream_out_48 [get_bd_intf_pins color_convert/stream_out_48] [get_bd_intf_pins pixel_pack/stream_in_48]
  connect_bd_intf_net -intf_net frontend_VIDEO_OUT [get_bd_intf_pins frontend/VIDEO_OUT] [get_bd_intf_pins pixel_reorder/S_AXIS]
  connect_bd_intf_net -intf_net intf_net_v_hdmi_rx_ss_DDC_OUT [get_bd_intf_pins RX_DDC_OUT] [get_bd_intf_pins frontend/DDC_OUT]
  connect_bd_intf_net -intf_net intf_net_vid_phy_controller_vid_phy_rx_axi4s_ch0 [get_bd_intf_pins LINK_DATA0_IN] [get_bd_intf_pins frontend/LINK_DATA0_IN]
  connect_bd_intf_net -intf_net intf_net_vid_phy_controller_vid_phy_rx_axi4s_ch1 [get_bd_intf_pins LINK_DATA1_IN] [get_bd_intf_pins frontend/LINK_DATA1_IN]
  connect_bd_intf_net -intf_net intf_net_vid_phy_controller_vid_phy_rx_axi4s_ch2 [get_bd_intf_pins LINK_DATA2_IN] [get_bd_intf_pins frontend/LINK_DATA2_IN]
  connect_bd_intf_net -intf_net intf_net_vid_phy_controller_vid_phy_status_sb_rx [get_bd_intf_pins SB_STATUS_IN] [get_bd_intf_pins frontend/SB_STATUS_IN]
  connect_bd_intf_net -intf_net intf_net_zynq_us_ss_0_M01_AXI [get_bd_intf_pins S_AXI_CPU_IN] [get_bd_intf_pins frontend/S_AXI_CPU_IN]
  connect_bd_intf_net -intf_net pixel_pack_0_stream_out_64 [get_bd_intf_pins stream_out_64] [get_bd_intf_pins pixel_pack/stream_out_64]
  connect_bd_intf_net -intf_net pixel_reorder_M_AXIS [get_bd_intf_pins pixel_reorder/M_AXIS] [get_bd_intf_pins rx_video_axis_reg_slice/S_AXIS]
  connect_bd_intf_net -intf_net rx_video_axis_reg_slice_M_AXIS [get_bd_intf_pins color_convert/stream_in_48] [get_bd_intf_pins rx_video_axis_reg_slice/M_AXIS]

  # Create port connections
  connect_bd_net -net net_bdry_in_RX_DET_IN [get_bd_pins RX_DET_IN] [get_bd_pins frontend/cable_detect]
  connect_bd_net -net net_v_hdmi_rx_ss_fid [get_bd_pins fid] [get_bd_pins frontend/fid]
  connect_bd_net -net net_v_hdmi_rx_ss_hpd [get_bd_pins RX_HPD_OUT] [get_bd_pins frontend/hpd]
  connect_bd_net -net net_v_hdmi_rx_ss_irq [get_bd_pins irq] [get_bd_pins frontend/irq]
  connect_bd_net -net net_vid_phy_controller_rx_video_clk [get_bd_pins video_clk] [get_bd_pins frontend/video_clk]
  connect_bd_net -net net_vid_phy_controller_rxoutclk [get_bd_pins link_clk] [get_bd_pins frontend/link_clk]
  connect_bd_net -net net_zynq_us_ss_0_clk_out2 [get_bd_pins aclk] [get_bd_pins color_convert/ap_clk] [get_bd_pins color_convert/control] [get_bd_pins frontend/s_axis_video_aclk] [get_bd_pins pixel_pack/ap_clk] [get_bd_pins pixel_pack/control] [get_bd_pins pixel_reorder/aclk] [get_bd_pins rx_video_axis_reg_slice/aclk]
  connect_bd_net -net net_zynq_us_ss_0_dcm_locked [get_bd_pins aresetn] [get_bd_pins color_convert/ap_rst_n] [get_bd_pins color_convert/ap_rst_n_control] [get_bd_pins frontend/s_axis_video_aresetn] [get_bd_pins pixel_pack/ap_rst_n] [get_bd_pins pixel_pack/ap_rst_n_control] [get_bd_pins pixel_reorder/aresetn] [get_bd_pins rx_video_axis_reg_slice/aresetn]
  connect_bd_net -net net_zynq_us_ss_0_peripheral_aresetn [get_bd_pins s_axi_cpu_aresetn] [get_bd_pins frontend/s_axi_cpu_aresetn]
  connect_bd_net -net net_zynq_us_ss_0_s_axi_aclk [get_bd_pins s_axi_cpu_aclk] [get_bd_pins frontend/s_axi_cpu_aclk]
  connect_bd_net -net s_axis_audio_aclk_1 [get_bd_pins s_axis_audio_aclk] [get_bd_pins frontend/s_axis_audio_aclk]
  connect_bd_net -net s_axis_audio_aresetn_1 [get_bd_pins s_axis_audio_aresetn] [get_bd_pins frontend/s_axis_audio_aresetn]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: timers_subsystem
proc create_hier_cell_timers_subsystem { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_timers_subsystem() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S00_AXILite

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S01_AXILite


  # Create pins
  create_bd_pin -dir O -from 1 -to 0 dout
  create_bd_pin -dir I -type clk s_axi_aclk
  create_bd_pin -dir I -type rst s_axi_aresetn
  create_bd_pin -dir I -type rst s_axi_aresetn1
  create_bd_pin -dir O -from 1 -to 0 timers_interrupt

  # Create instance: mb_timers_interrupt, and set properties
  set mb_timers_interrupt [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 mb_timers_interrupt ]

  # Create instance: mb_timers_pwm, and set properties
  set mb_timers_pwm [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 mb_timers_pwm ]

  # Create instance: timer_0, and set properties
  set timer_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_timer:2.0 timer_0 ]

  # Create instance: timer_1, and set properties
  set timer_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_timer:2.0 timer_1 ]

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins S01_AXILite] [get_bd_intf_pins timer_1/S_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M04_AXI [get_bd_intf_pins S00_AXILite] [get_bd_intf_pins timer_0/S_AXI]

  # Create port connections
  connect_bd_net -net mb_timers_interrupt_dout [get_bd_pins timers_interrupt] [get_bd_pins mb_timers_interrupt/dout]
  connect_bd_net -net mb_timers_pwm_dout [get_bd_pins dout] [get_bd_pins mb_timers_pwm/dout]
  connect_bd_net -net peripheral_aresetn1_1 [get_bd_pins s_axi_aresetn1] [get_bd_pins timer_1/s_axi_aresetn]
  connect_bd_net -net ps7_0_FCLK_CLK0 [get_bd_pins s_axi_aclk] [get_bd_pins timer_0/s_axi_aclk] [get_bd_pins timer_1/s_axi_aclk]
  connect_bd_net -net rst_clk_wiz_1_100M_peripheral_aresetn [get_bd_pins s_axi_aresetn] [get_bd_pins timer_0/s_axi_aresetn]
  connect_bd_net -net timer_0_interrupt [get_bd_pins mb_timers_interrupt/In0] [get_bd_pins timer_0/interrupt]
  connect_bd_net -net timer_0_pwm0 [get_bd_pins mb_timers_pwm/In0] [get_bd_pins timer_0/pwm0]
  connect_bd_net -net timer_1_interrupt [get_bd_pins mb_timers_interrupt/In1] [get_bd_pins timer_1/interrupt]
  connect_bd_net -net timer_1_pwm0 [get_bd_pins mb_timers_pwm/In1] [get_bd_pins timer_1/pwm0]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: spi_subsystem
proc create_hier_cell_spi_subsystem { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_spi_subsystem() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S00_AXILite

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S01_AXILite

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:spi_rtl:1.0 SPI_0

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:spi_rtl:1.0 SPI_1


  # Create pins
  create_bd_pin -dir O -type intr ip2intc_spi_0_irpt
  create_bd_pin -dir O -type intr ip2intc_spi_1_irpt
  create_bd_pin -dir I -type clk s_axi_aclk
  create_bd_pin -dir I -type rst s_axi_aresetn
  create_bd_pin -dir I -type rst s_axi_aresetn1

  # Create instance: spi_0, and set properties
  set spi_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_quad_spi:3.2 spi_0 ]
  set_property -dict [ list \
   CONFIG.C_USE_STARTUP {0} \
 ] $spi_0

  # Create instance: spi_1, and set properties
  set spi_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_quad_spi:3.2 spi_1 ]
  set_property -dict [ list \
   CONFIG.C_USE_STARTUP {0} \
 ] $spi_1

  # Create interface connections
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M00_AXI [get_bd_intf_pins S01_AXILite] [get_bd_intf_pins spi_0/AXI_LITE]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M11_AXI [get_bd_intf_pins S00_AXILite] [get_bd_intf_pins spi_1/AXI_LITE]
  connect_bd_intf_net -intf_net spi_1_SPI_0 [get_bd_intf_pins SPI_0] [get_bd_intf_pins spi_1/SPI_0]
  connect_bd_intf_net -intf_net spi_SPI_0 [get_bd_intf_pins SPI_1] [get_bd_intf_pins spi_0/SPI_0]

  # Create port connections
  connect_bd_net -net ps7_0_FCLK_CLK0 [get_bd_pins s_axi_aclk] [get_bd_pins spi_0/ext_spi_clk] [get_bd_pins spi_0/s_axi_aclk] [get_bd_pins spi_1/ext_spi_clk] [get_bd_pins spi_1/s_axi_aclk]
  connect_bd_net -net rst_clk_wiz_1_100M_peripheral_aresetn [get_bd_pins s_axi_aresetn] [get_bd_pins spi_0/s_axi_aresetn]
  connect_bd_net -net s_axi_aresetn_1 [get_bd_pins s_axi_aresetn1] [get_bd_pins spi_1/s_axi_aresetn]
  connect_bd_net -net spi_0_ip2intc_irpt [get_bd_pins ip2intc_spi_0_irpt] [get_bd_pins spi_0/ip2intc_irpt]
  connect_bd_net -net spi_1_ip2intc_irpt [get_bd_pins ip2intc_spi_1_irpt] [get_bd_pins spi_1/ip2intc_irpt]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: lmb
proc create_hier_cell_lmb_3 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_lmb_3() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:bram_rtl:1.0 BRAM_PORTB

  create_bd_intf_pin -mode MirroredMaster -vlnv xilinx.com:interface:lmb_rtl:1.0 DLMB

  create_bd_intf_pin -mode MirroredMaster -vlnv xilinx.com:interface:lmb_rtl:1.0 ILMB


  # Create pins
  create_bd_pin -dir I -type clk LMB_Clk
  create_bd_pin -dir I -from 0 -to 0 -type rst SYS_Rst

  # Create instance: dlmb_v10, and set properties
  set dlmb_v10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_v10:3.0 dlmb_v10 ]

  # Create instance: ilmb_v10, and set properties
  set ilmb_v10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_v10:3.0 ilmb_v10 ]

  # Create instance: lmb_bram, and set properties
  set lmb_bram [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 lmb_bram ]
  set_property -dict [ list \
   CONFIG.Enable_B {Use_ENB_Pin} \
   CONFIG.Memory_Type {True_Dual_Port_RAM} \
   CONFIG.Port_B_Clock {100} \
   CONFIG.Port_B_Enable_Rate {100} \
   CONFIG.Port_B_Write_Rate {50} \
   CONFIG.Use_RSTB_Pin {true} \
   CONFIG.use_bram_block {BRAM_Controller} \
 ] $lmb_bram

  # Create instance: lmb_bram_if_cntlr, and set properties
  set lmb_bram_if_cntlr [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_bram_if_cntlr:4.0 lmb_bram_if_cntlr ]
  set_property -dict [ list \
   CONFIG.C_ECC {0} \
   CONFIG.C_NUM_LMB {2} \
 ] $lmb_bram_if_cntlr

  # Create interface connections
  connect_bd_intf_net -intf_net Conn [get_bd_intf_pins dlmb_v10/LMB_Sl_0] [get_bd_intf_pins lmb_bram_if_cntlr/SLMB1]
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins BRAM_PORTB] [get_bd_intf_pins lmb_bram/BRAM_PORTB]
  connect_bd_intf_net -intf_net lmb_bram_if_cntlr_BRAM_PORT [get_bd_intf_pins lmb_bram/BRAM_PORTA] [get_bd_intf_pins lmb_bram_if_cntlr/BRAM_PORT]
  connect_bd_intf_net -intf_net microblaze_0_dlmb [get_bd_intf_pins DLMB] [get_bd_intf_pins dlmb_v10/LMB_M]
  connect_bd_intf_net -intf_net microblaze_0_ilmb [get_bd_intf_pins ILMB] [get_bd_intf_pins ilmb_v10/LMB_M]
  connect_bd_intf_net -intf_net microblaze_0_ilmb_bus [get_bd_intf_pins ilmb_v10/LMB_Sl_0] [get_bd_intf_pins lmb_bram_if_cntlr/SLMB]

  # Create port connections
  connect_bd_net -net SYS_Rst_1 [get_bd_pins SYS_Rst] [get_bd_pins dlmb_v10/SYS_Rst] [get_bd_pins ilmb_v10/SYS_Rst] [get_bd_pins lmb_bram_if_cntlr/LMB_Rst]
  connect_bd_net -net microblaze_0_Clk [get_bd_pins LMB_Clk] [get_bd_pins dlmb_v10/LMB_Clk] [get_bd_pins ilmb_v10/LMB_Clk] [get_bd_pins lmb_bram_if_cntlr/LMB_Clk]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: iic_subsystem
proc create_hier_cell_iic_subsystem { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_iic_subsystem() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 IIC

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 IIC_0

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S00_AXILite

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S01_AXILite


  # Create pins
  create_bd_pin -dir O -type intr iic2intc_0_irpt
  create_bd_pin -dir O -type intr iic2intc_1_irpt
  create_bd_pin -dir I -type clk s_axi_aclk
  create_bd_pin -dir I -type rst s_axi_aresetn1
  create_bd_pin -dir I -type rst s_axil_aresetn

  # Create instance: iic_0, and set properties
  set iic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_iic:2.1 iic_0 ]

  # Create instance: iic_1, and set properties
  set iic_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_iic:2.1 iic_1 ]

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins S01_AXILite] [get_bd_intf_pins iic_1/S_AXI]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins IIC] [get_bd_intf_pins iic_1/IIC]
  connect_bd_intf_net -intf_net iic_IIC [get_bd_intf_pins IIC_0] [get_bd_intf_pins iic_0/IIC]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M01_AXI [get_bd_intf_pins S00_AXILite] [get_bd_intf_pins iic_0/S_AXI]

  # Create port connections
  connect_bd_net -net iic_1_iic2intc_irpt [get_bd_pins iic2intc_1_irpt] [get_bd_pins iic_1/iic2intc_irpt]
  connect_bd_net -net mb1_iic_iic2intc_irpt [get_bd_pins iic2intc_0_irpt] [get_bd_pins iic_0/iic2intc_irpt]
  connect_bd_net -net peripheral_aresetn1_1 [get_bd_pins s_axi_aresetn1] [get_bd_pins iic_1/s_axi_aresetn]
  connect_bd_net -net ps7_0_FCLK_CLK0 [get_bd_pins s_axi_aclk] [get_bd_pins iic_0/s_axi_aclk] [get_bd_pins iic_1/s_axi_aclk]
  connect_bd_net -net rst_clk_wiz_1_100M_peripheral_aresetn [get_bd_pins s_axil_aresetn] [get_bd_pins iic_0/s_axi_aresetn]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: lmb
proc create_hier_cell_lmb_2 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_lmb_2() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:bram_rtl:1.0 BRAM_PORTB

  create_bd_intf_pin -mode MirroredMaster -vlnv xilinx.com:interface:lmb_rtl:1.0 DLMB

  create_bd_intf_pin -mode MirroredMaster -vlnv xilinx.com:interface:lmb_rtl:1.0 ILMB


  # Create pins
  create_bd_pin -dir I -type clk LMB_Clk
  create_bd_pin -dir I -from 0 -to 0 -type rst SYS_Rst

  # Create instance: dlmb_v10, and set properties
  set dlmb_v10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_v10:3.0 dlmb_v10 ]

  # Create instance: ilmb_v10, and set properties
  set ilmb_v10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_v10:3.0 ilmb_v10 ]

  # Create instance: lmb_bram, and set properties
  set lmb_bram [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 lmb_bram ]
  set_property -dict [ list \
   CONFIG.Enable_B {Use_ENB_Pin} \
   CONFIG.Memory_Type {True_Dual_Port_RAM} \
   CONFIG.Port_B_Clock {100} \
   CONFIG.Port_B_Enable_Rate {100} \
   CONFIG.Port_B_Write_Rate {50} \
   CONFIG.Use_RSTB_Pin {true} \
   CONFIG.use_bram_block {BRAM_Controller} \
 ] $lmb_bram

  # Create instance: lmb_bram_if_cntlr, and set properties
  set lmb_bram_if_cntlr [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_bram_if_cntlr:4.0 lmb_bram_if_cntlr ]
  set_property -dict [ list \
   CONFIG.C_ECC {0} \
   CONFIG.C_NUM_LMB {2} \
 ] $lmb_bram_if_cntlr

  # Create interface connections
  connect_bd_intf_net -intf_net Conn [get_bd_intf_pins dlmb_v10/LMB_Sl_0] [get_bd_intf_pins lmb_bram_if_cntlr/SLMB1]
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins BRAM_PORTB] [get_bd_intf_pins lmb_bram/BRAM_PORTB]
  connect_bd_intf_net -intf_net lmb_bram_if_cntlr_BRAM_PORT [get_bd_intf_pins lmb_bram/BRAM_PORTA] [get_bd_intf_pins lmb_bram_if_cntlr/BRAM_PORT]
  connect_bd_intf_net -intf_net microblaze_0_dlmb [get_bd_intf_pins DLMB] [get_bd_intf_pins dlmb_v10/LMB_M]
  connect_bd_intf_net -intf_net microblaze_0_ilmb [get_bd_intf_pins ILMB] [get_bd_intf_pins ilmb_v10/LMB_M]
  connect_bd_intf_net -intf_net microblaze_0_ilmb_bus [get_bd_intf_pins ilmb_v10/LMB_Sl_0] [get_bd_intf_pins lmb_bram_if_cntlr/SLMB]

  # Create port connections
  connect_bd_net -net SYS_Rst_1 [get_bd_pins SYS_Rst] [get_bd_pins dlmb_v10/SYS_Rst] [get_bd_pins ilmb_v10/SYS_Rst] [get_bd_pins lmb_bram_if_cntlr/LMB_Rst]
  connect_bd_net -net microblaze_0_Clk [get_bd_pins LMB_Clk] [get_bd_pins dlmb_v10/LMB_Clk] [get_bd_pins ilmb_v10/LMB_Clk] [get_bd_pins lmb_bram_if_cntlr/LMB_Clk]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: lmb
proc create_hier_cell_lmb_1 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_lmb_1() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:bram_rtl:1.0 BRAM_PORTB

  create_bd_intf_pin -mode MirroredMaster -vlnv xilinx.com:interface:lmb_rtl:1.0 DLMB

  create_bd_intf_pin -mode MirroredMaster -vlnv xilinx.com:interface:lmb_rtl:1.0 ILMB


  # Create pins
  create_bd_pin -dir I -type clk LMB_Clk
  create_bd_pin -dir I -from 0 -to 0 -type rst SYS_Rst

  # Create instance: dlmb_v10, and set properties
  set dlmb_v10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_v10:3.0 dlmb_v10 ]

  # Create instance: ilmb_v10, and set properties
  set ilmb_v10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_v10:3.0 ilmb_v10 ]

  # Create instance: lmb_bram, and set properties
  set lmb_bram [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 lmb_bram ]
  set_property -dict [ list \
   CONFIG.Enable_B {Use_ENB_Pin} \
   CONFIG.Memory_Type {True_Dual_Port_RAM} \
   CONFIG.Port_B_Clock {100} \
   CONFIG.Port_B_Enable_Rate {100} \
   CONFIG.Port_B_Write_Rate {50} \
   CONFIG.Use_RSTB_Pin {true} \
   CONFIG.use_bram_block {BRAM_Controller} \
 ] $lmb_bram

  # Create instance: lmb_bram_if_cntlr, and set properties
  set lmb_bram_if_cntlr [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_bram_if_cntlr:4.0 lmb_bram_if_cntlr ]
  set_property -dict [ list \
   CONFIG.C_ECC {0} \
   CONFIG.C_NUM_LMB {2} \
 ] $lmb_bram_if_cntlr

  # Create interface connections
  connect_bd_intf_net -intf_net Conn [get_bd_intf_pins dlmb_v10/LMB_Sl_0] [get_bd_intf_pins lmb_bram_if_cntlr/SLMB1]
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins BRAM_PORTB] [get_bd_intf_pins lmb_bram/BRAM_PORTB]
  connect_bd_intf_net -intf_net lmb_bram_if_cntlr_BRAM_PORT [get_bd_intf_pins lmb_bram/BRAM_PORTA] [get_bd_intf_pins lmb_bram_if_cntlr/BRAM_PORT]
  connect_bd_intf_net -intf_net microblaze_0_dlmb [get_bd_intf_pins DLMB] [get_bd_intf_pins dlmb_v10/LMB_M]
  connect_bd_intf_net -intf_net microblaze_0_ilmb [get_bd_intf_pins ILMB] [get_bd_intf_pins ilmb_v10/LMB_M]
  connect_bd_intf_net -intf_net microblaze_0_ilmb_bus [get_bd_intf_pins ilmb_v10/LMB_Sl_0] [get_bd_intf_pins lmb_bram_if_cntlr/SLMB]

  # Create port connections
  connect_bd_net -net SYS_Rst_1 [get_bd_pins SYS_Rst] [get_bd_pins dlmb_v10/SYS_Rst] [get_bd_pins ilmb_v10/SYS_Rst] [get_bd_pins lmb_bram_if_cntlr/LMB_Rst]
  connect_bd_net -net microblaze_0_Clk [get_bd_pins LMB_Clk] [get_bd_pins dlmb_v10/LMB_Clk] [get_bd_pins ilmb_v10/LMB_Clk] [get_bd_pins lmb_bram_if_cntlr/LMB_Clk]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: lmb
proc create_hier_cell_lmb { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_lmb() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:bram_rtl:1.0 BRAM_PORTB

  create_bd_intf_pin -mode MirroredMaster -vlnv xilinx.com:interface:lmb_rtl:1.0 DLMB

  create_bd_intf_pin -mode MirroredMaster -vlnv xilinx.com:interface:lmb_rtl:1.0 ILMB


  # Create pins
  create_bd_pin -dir I -type clk LMB_Clk
  create_bd_pin -dir I -from 0 -to 0 -type rst SYS_Rst

  # Create instance: dlmb_v10, and set properties
  set dlmb_v10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_v10:3.0 dlmb_v10 ]

  # Create instance: ilmb_v10, and set properties
  set ilmb_v10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_v10:3.0 ilmb_v10 ]

  # Create instance: lmb_bram, and set properties
  set lmb_bram [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 lmb_bram ]
  set_property -dict [ list \
   CONFIG.Enable_B {Use_ENB_Pin} \
   CONFIG.Memory_Type {True_Dual_Port_RAM} \
   CONFIG.Port_B_Clock {100} \
   CONFIG.Port_B_Enable_Rate {100} \
   CONFIG.Port_B_Write_Rate {50} \
   CONFIG.Use_RSTB_Pin {true} \
   CONFIG.use_bram_block {BRAM_Controller} \
 ] $lmb_bram

  # Create instance: lmb_bram_if_cntlr, and set properties
  set lmb_bram_if_cntlr [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_bram_if_cntlr:4.0 lmb_bram_if_cntlr ]
  set_property -dict [ list \
   CONFIG.C_ECC {0} \
   CONFIG.C_NUM_LMB {2} \
 ] $lmb_bram_if_cntlr

  # Create interface connections
  connect_bd_intf_net -intf_net Conn [get_bd_intf_pins dlmb_v10/LMB_Sl_0] [get_bd_intf_pins lmb_bram_if_cntlr/SLMB1]
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins BRAM_PORTB] [get_bd_intf_pins lmb_bram/BRAM_PORTB]
  connect_bd_intf_net -intf_net lmb_bram_if_cntlr_BRAM_PORT [get_bd_intf_pins lmb_bram/BRAM_PORTA] [get_bd_intf_pins lmb_bram_if_cntlr/BRAM_PORT]
  connect_bd_intf_net -intf_net microblaze_0_dlmb [get_bd_intf_pins DLMB] [get_bd_intf_pins dlmb_v10/LMB_M]
  connect_bd_intf_net -intf_net microblaze_0_ilmb [get_bd_intf_pins ILMB] [get_bd_intf_pins ilmb_v10/LMB_M]
  connect_bd_intf_net -intf_net microblaze_0_ilmb_bus [get_bd_intf_pins ilmb_v10/LMB_Sl_0] [get_bd_intf_pins lmb_bram_if_cntlr/SLMB]

  # Create port connections
  connect_bd_net -net SYS_Rst_1 [get_bd_pins SYS_Rst] [get_bd_pins dlmb_v10/SYS_Rst] [get_bd_pins ilmb_v10/SYS_Rst] [get_bd_pins lmb_bram_if_cntlr/LMB_Rst]
  connect_bd_net -net microblaze_0_Clk [get_bd_pins LMB_Clk] [get_bd_pins dlmb_v10/LMB_Clk] [get_bd_pins ilmb_v10/LMB_Clk] [get_bd_pins lmb_bram_if_cntlr/LMB_Clk]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: video
proc create_hier_cell_video { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_video() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_MM2S

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_S2MM

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 RX_DDC_OUT

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_CPU_IN

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_CPU_IN1

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 TX_DDC_OUT

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_control

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_control1

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_control2

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_control3

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 vid_phy_axi4lite


  # Create pins
  create_bd_pin -dir I -type clk HDMI_RX_CLK_N_IN
  create_bd_pin -dir I -type clk HDMI_RX_CLK_P_IN
  create_bd_pin -dir I -from 2 -to 0 HDMI_RX_DAT_N_IN
  create_bd_pin -dir I -from 2 -to 0 HDMI_RX_DAT_P_IN
  create_bd_pin -dir I HDMI_SI5324_LOL_IN
  create_bd_pin -dir O -type clk HDMI_TX_CLK_N_OUT
  create_bd_pin -dir O -type clk HDMI_TX_CLK_P_OUT
  create_bd_pin -dir O -from 2 -to 0 HDMI_TX_DAT_N_OUT
  create_bd_pin -dir O -from 2 -to 0 HDMI_TX_DAT_P_OUT
  create_bd_pin -dir I RX_DET_IN
  create_bd_pin -dir O RX_HPD_OUT
  create_bd_pin -dir O -type clk RX_REFCLK_N_OUT
  create_bd_pin -dir O -type clk RX_REFCLK_P_OUT
  create_bd_pin -dir I -type rst TX_EN_OUT
  create_bd_pin -dir I TX_HPD_IN
  create_bd_pin -dir I -type clk TX_REFCLK_N_IN
  create_bd_pin -dir I -type clk TX_REFCLK_P_IN
  create_bd_pin -dir I -type clk aclk
  create_bd_pin -dir I -type rst aresetn
  create_bd_pin -dir O -type intr irq
  create_bd_pin -dir O -type intr irq1
  create_bd_pin -dir O -type intr irq2
  create_bd_pin -dir O -type intr mm2s_introut
  create_bd_pin -dir O -type intr s2mm_introut
  create_bd_pin -dir I -type clk s_axi_cpu_aclk
  create_bd_pin -dir I -type rst s_axi_cpu_aresetn

  # Create instance: axi_vdma, and set properties
  set axi_vdma [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vdma:6.3 axi_vdma ]
  set_property -dict [ list \
   CONFIG.c_addr_width {32} \
   CONFIG.c_m_axi_mm2s_data_width {128} \
   CONFIG.c_m_axi_s2mm_data_width {128} \
   CONFIG.c_m_axis_mm2s_tdata_width {64} \
   CONFIG.c_mm2s_linebuffer_depth {4096} \
   CONFIG.c_mm2s_max_burst_length {256} \
   CONFIG.c_num_fstores {4} \
   CONFIG.c_s2mm_linebuffer_depth {4096} \
   CONFIG.c_s2mm_max_burst_length {256} \
 ] $axi_vdma

  # Create instance: const_gnd, and set properties
  set const_gnd [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 const_gnd ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
 ] $const_gnd

  # Create instance: hdmi_in
  create_hier_cell_hdmi_in $hier_obj hdmi_in

  # Create instance: hdmi_out
  create_hier_cell_hdmi_out $hier_obj hdmi_out

  # Create instance: phy
  create_hier_cell_phy $hier_obj phy

  # Create interface connections
  connect_bd_intf_net -intf_net axi_interconnect_M07_AXI [get_bd_intf_pins s_axi_control] [get_bd_intf_pins hdmi_out/s_axi_control]
  connect_bd_intf_net -intf_net axi_interconnect_M08_AXI [get_bd_intf_pins s_axi_control1] [get_bd_intf_pins hdmi_in/s_axi_control]
  connect_bd_intf_net -intf_net axi_interconnect_M09_AXI [get_bd_intf_pins s_axi_control2] [get_bd_intf_pins hdmi_in/s_axi_control1]
  connect_bd_intf_net -intf_net axi_interconnect_M10_AXI [get_bd_intf_pins s_axi_control3] [get_bd_intf_pins hdmi_out/s_axi_control1]
  connect_bd_intf_net -intf_net axi_vdma_0_M_AXIS_MM2S [get_bd_intf_pins axi_vdma/M_AXIS_MM2S] [get_bd_intf_pins hdmi_out/stream_in_64]
  connect_bd_intf_net -intf_net axi_vdma_0_M_AXI_MM2S [get_bd_intf_pins M_AXI_MM2S] [get_bd_intf_pins axi_vdma/M_AXI_MM2S]
  connect_bd_intf_net -intf_net axi_vdma_0_M_AXI_S2MM [get_bd_intf_pins M_AXI_S2MM] [get_bd_intf_pins axi_vdma/M_AXI_S2MM]
  connect_bd_intf_net -intf_net intf_net_v_hdmi_rx_ss_DDC_OUT [get_bd_intf_pins RX_DDC_OUT] [get_bd_intf_pins hdmi_in/RX_DDC_OUT]
  connect_bd_intf_net -intf_net intf_net_v_hdmi_tx_ss_DDC_OUT [get_bd_intf_pins TX_DDC_OUT] [get_bd_intf_pins hdmi_out/TX_DDC_OUT]
  connect_bd_intf_net -intf_net intf_net_v_hdmi_tx_ss_LINK_DATA0_OUT [get_bd_intf_pins hdmi_out/LINK_DATA0_OUT] [get_bd_intf_pins phy/vid_phy_tx_axi4s_ch0]
  connect_bd_intf_net -intf_net intf_net_v_hdmi_tx_ss_LINK_DATA1_OUT [get_bd_intf_pins hdmi_out/LINK_DATA1_OUT] [get_bd_intf_pins phy/vid_phy_tx_axi4s_ch1]
  connect_bd_intf_net -intf_net intf_net_v_hdmi_tx_ss_LINK_DATA2_OUT [get_bd_intf_pins hdmi_out/LINK_DATA2_OUT] [get_bd_intf_pins phy/vid_phy_tx_axi4s_ch2]
  connect_bd_intf_net -intf_net intf_net_vid_phy_controller_vid_phy_rx_axi4s_ch0 [get_bd_intf_pins hdmi_in/LINK_DATA0_IN] [get_bd_intf_pins phy/vid_phy_rx_axi4s_ch0]
  connect_bd_intf_net -intf_net intf_net_vid_phy_controller_vid_phy_rx_axi4s_ch1 [get_bd_intf_pins hdmi_in/LINK_DATA1_IN] [get_bd_intf_pins phy/vid_phy_rx_axi4s_ch1]
  connect_bd_intf_net -intf_net intf_net_vid_phy_controller_vid_phy_rx_axi4s_ch2 [get_bd_intf_pins hdmi_in/LINK_DATA2_IN] [get_bd_intf_pins phy/vid_phy_rx_axi4s_ch2]
  connect_bd_intf_net -intf_net intf_net_vid_phy_controller_vid_phy_status_sb_rx [get_bd_intf_pins hdmi_in/SB_STATUS_IN] [get_bd_intf_pins phy/vid_phy_status_sb_rx]
  connect_bd_intf_net -intf_net intf_net_vid_phy_controller_vid_phy_status_sb_tx [get_bd_intf_pins hdmi_out/SB_STATUS_IN] [get_bd_intf_pins phy/vid_phy_status_sb_tx]
  connect_bd_intf_net -intf_net intf_net_zynq_us_ss_0_M00_AXI [get_bd_intf_pins vid_phy_axi4lite] [get_bd_intf_pins phy/vid_phy_axi4lite]
  connect_bd_intf_net -intf_net intf_net_zynq_us_ss_0_M01_AXI [get_bd_intf_pins S_AXI_CPU_IN] [get_bd_intf_pins hdmi_in/S_AXI_CPU_IN]
  connect_bd_intf_net -intf_net intf_net_zynq_us_ss_0_M02_AXI [get_bd_intf_pins S_AXI_CPU_IN1] [get_bd_intf_pins hdmi_out/S_AXI_CPU_IN]
  connect_bd_intf_net -intf_net pixel_pack_0_stream_out_64 [get_bd_intf_pins axi_vdma/S_AXIS_S2MM] [get_bd_intf_pins hdmi_in/stream_out_64]
  connect_bd_intf_net -intf_net zynq_us_ss_0_M03_AXI [get_bd_intf_pins S_AXI_LITE] [get_bd_intf_pins axi_vdma/S_AXI_LITE]

  # Create port connections
  connect_bd_net -net axi_vdma_0_mm2s_introut [get_bd_pins mm2s_introut] [get_bd_pins axi_vdma/mm2s_introut]
  connect_bd_net -net axi_vdma_0_s2mm_introut [get_bd_pins s2mm_introut] [get_bd_pins axi_vdma/s2mm_introut]
  connect_bd_net -net const_gnd_dout [get_bd_pins const_gnd/dout] [get_bd_pins hdmi_in/s_axis_audio_aclk] [get_bd_pins hdmi_in/s_axis_audio_aresetn] [get_bd_pins hdmi_out/acr_valid] [get_bd_pins hdmi_out/s_axis_audio_aclk] [get_bd_pins hdmi_out/s_axis_audio_aresetn]
  connect_bd_net -net net_bdry_in_HDMI_RX_CLK_N_IN [get_bd_pins HDMI_RX_CLK_N_IN] [get_bd_pins phy/HDMI_RX_CLK_N_IN]
  connect_bd_net -net net_bdry_in_HDMI_RX_CLK_P_IN [get_bd_pins HDMI_RX_CLK_P_IN] [get_bd_pins phy/HDMI_RX_CLK_P_IN]
  connect_bd_net -net net_bdry_in_HDMI_RX_DAT_N_IN [get_bd_pins HDMI_RX_DAT_N_IN] [get_bd_pins phy/HDMI_RX_DAT_N_IN]
  connect_bd_net -net net_bdry_in_HDMI_RX_DAT_P_IN [get_bd_pins HDMI_RX_DAT_P_IN] [get_bd_pins phy/HDMI_RX_DAT_P_IN]
  connect_bd_net -net net_bdry_in_HDMI_SI5324_LOL_IN [get_bd_pins HDMI_SI5324_LOL_IN] [get_bd_pins phy/HDMI_SI5324_LOL_IN]
  connect_bd_net -net net_bdry_in_RX_DET_IN [get_bd_pins RX_DET_IN] [get_bd_pins hdmi_in/RX_DET_IN]
  connect_bd_net -net net_bdry_in_TX_HPD_IN [get_bd_pins TX_HPD_IN] [get_bd_pins hdmi_out/TX_HPD_IN]
  connect_bd_net -net net_bdry_in_TX_REFCLK_N_IN [get_bd_pins TX_REFCLK_N_IN] [get_bd_pins phy/TX_REFCLK_N_IN]
  connect_bd_net -net net_bdry_in_TX_REFCLK_P_IN [get_bd_pins TX_REFCLK_P_IN] [get_bd_pins phy/TX_REFCLK_P_IN]
  connect_bd_net -net net_v_hdmi_rx_ss_hpd [get_bd_pins RX_HPD_OUT] [get_bd_pins hdmi_in/RX_HPD_OUT]
  connect_bd_net -net net_v_hdmi_rx_ss_irq [get_bd_pins irq] [get_bd_pins hdmi_in/irq]
  connect_bd_net -net net_v_hdmi_tx_ss_irq [get_bd_pins irq1] [get_bd_pins hdmi_out/irq1]
  connect_bd_net -net net_vcc_const_dout [get_bd_pins TX_EN_OUT] [get_bd_pins phy/TX_EN_OUT]
  connect_bd_net -net net_vid_phy_controller_irq [get_bd_pins irq2] [get_bd_pins phy/irq2]
  connect_bd_net -net net_vid_phy_controller_phy_txn_out [get_bd_pins HDMI_TX_DAT_N_OUT] [get_bd_pins phy/HDMI_TX_DAT_N_OUT]
  connect_bd_net -net net_vid_phy_controller_phy_txp_out [get_bd_pins HDMI_TX_DAT_P_OUT] [get_bd_pins phy/HDMI_TX_DAT_P_OUT]
  connect_bd_net -net net_vid_phy_controller_rx_tmds_clk_n [get_bd_pins RX_REFCLK_N_OUT] [get_bd_pins phy/RX_REFCLK_N_OUT]
  connect_bd_net -net net_vid_phy_controller_rx_tmds_clk_p [get_bd_pins RX_REFCLK_P_OUT] [get_bd_pins phy/RX_REFCLK_P_OUT]
  connect_bd_net -net net_vid_phy_controller_rx_video_clk [get_bd_pins hdmi_in/video_clk] [get_bd_pins phy/rx_video_clk]
  connect_bd_net -net net_vid_phy_controller_rxoutclk [get_bd_pins hdmi_in/link_clk] [get_bd_pins phy/vid_phy_rx_axi4s_aclk]
  connect_bd_net -net net_vid_phy_controller_tx_tmds_clk_n [get_bd_pins HDMI_TX_CLK_N_OUT] [get_bd_pins phy/HDMI_TX_CLK_N_OUT]
  connect_bd_net -net net_vid_phy_controller_tx_tmds_clk_p [get_bd_pins HDMI_TX_CLK_P_OUT] [get_bd_pins phy/HDMI_TX_CLK_P_OUT]
  connect_bd_net -net net_vid_phy_controller_tx_video_clk [get_bd_pins hdmi_out/video_clk] [get_bd_pins phy/tx_video_clk]
  connect_bd_net -net net_vid_phy_controller_txoutclk [get_bd_pins hdmi_out/link_clk] [get_bd_pins phy/vid_phy_tx_axi4s_aclk]
  connect_bd_net -net net_zynq_us_ss_0_clk_out2 [get_bd_pins aclk] [get_bd_pins axi_vdma/m_axi_mm2s_aclk] [get_bd_pins axi_vdma/m_axi_s2mm_aclk] [get_bd_pins axi_vdma/m_axis_mm2s_aclk] [get_bd_pins axi_vdma/s_axis_s2mm_aclk] [get_bd_pins hdmi_in/aclk] [get_bd_pins hdmi_out/aclk]
  connect_bd_net -net net_zynq_us_ss_0_dcm_locked [get_bd_pins aresetn] [get_bd_pins hdmi_in/aresetn] [get_bd_pins hdmi_out/aresetn]
  connect_bd_net -net net_zynq_us_ss_0_peripheral_aresetn [get_bd_pins s_axi_cpu_aresetn] [get_bd_pins axi_vdma/axi_resetn] [get_bd_pins hdmi_in/s_axi_cpu_aresetn] [get_bd_pins hdmi_out/s_axi_cpu_aresetn] [get_bd_pins phy/s_axi_cpu_aresetn]
  connect_bd_net -net net_zynq_us_ss_0_s_axi_aclk [get_bd_pins s_axi_cpu_aclk] [get_bd_pins axi_vdma/s_axi_lite_aclk] [get_bd_pins hdmi_in/s_axi_cpu_aclk] [get_bd_pins hdmi_out/s_axi_cpu_aclk] [get_bd_pins phy/s_axi_cpu_aclk]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: trace_analyzer_pmod1
proc create_hier_cell_trace_analyzer_pmod1 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_trace_analyzer_pmod1() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_S2MM

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_trace_cntrl


  # Create pins
  create_bd_pin -dir I -type clk ap_clk
  create_bd_pin -dir I -type rst axi_resetn
  create_bd_pin -dir I -from 31 -to 0 data
  create_bd_pin -dir O s2mm_introut
  create_bd_pin -dir I valid

  # Create instance: axi_dma_0, and set properties
  set axi_dma_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_0 ]
  set_property -dict [ list \
   CONFIG.c_include_mm2s {0} \
   CONFIG.c_include_sg {0} \
   CONFIG.c_s2mm_burst_size {64} \
   CONFIG.c_sg_include_stscntrl_strm {0} \
   CONFIG.c_sg_length_width {23} \
 ] $axi_dma_0

  # Create instance: axis_data_fifo_0, and set properties
  set axis_data_fifo_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 axis_data_fifo_0 ]
  set_property -dict [ list \
   CONFIG.FIFO_DEPTH {256} \
   CONFIG.HAS_TLAST {1} \
 ] $axis_data_fifo_0

  # Create instance: constant_tkeep_tstrb, and set properties
  set constant_tkeep_tstrb [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 constant_tkeep_tstrb ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {15} \
   CONFIG.CONST_WIDTH {4} \
 ] $constant_tkeep_tstrb

  # Create instance: dff_en_reset_vector_0, and set properties
  set dff_en_reset_vector_0 [ create_bd_cell -type ip -vlnv xilinx.com:user:dff_en_reset_vector:1.0 dff_en_reset_vector_0 ]
  set_property -dict [ list \
   CONFIG.SIZE {32} \
 ] $dff_en_reset_vector_0

  # Create instance: logic_0, and set properties
  set logic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 logic_0 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
 ] $logic_0

  # Create instance: logic_1, and set properties
  set logic_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 logic_1 ]

  # Create instance: trace_cntrl_32_0, and set properties
  set trace_cntrl_32_0 [ create_bd_cell -type ip -vlnv xilinx.com:hls:trace_cntrl_32:1.4 trace_cntrl_32_0 ]

  # Create interface connections
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins S_AXI_LITE] [get_bd_intf_pins axi_dma_0/S_AXI_LITE]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins M_AXI_S2MM] [get_bd_intf_pins axi_dma_0/M_AXI_S2MM]
  connect_bd_intf_net -intf_net axis_data_fifo_0_M_AXIS [get_bd_intf_pins axi_dma_0/S_AXIS_S2MM] [get_bd_intf_pins axis_data_fifo_0/M_AXIS]
  connect_bd_intf_net -intf_net s_axi_trace_cntrl_1 [get_bd_intf_pins s_axi_trace_cntrl] [get_bd_intf_pins trace_cntrl_32_0/s_axi_trace_cntrl]
  connect_bd_intf_net -intf_net trace_cntrl_32_0_capture_32 [get_bd_intf_pins axis_data_fifo_0/S_AXIS] [get_bd_intf_pins trace_cntrl_32_0/capture_32]

  # Create port connections
  connect_bd_net -net Net5 [get_bd_pins ap_clk] [get_bd_pins axi_dma_0/m_axi_s2mm_aclk] [get_bd_pins axi_dma_0/s_axi_lite_aclk] [get_bd_pins axis_data_fifo_0/s_axis_aclk] [get_bd_pins dff_en_reset_vector_0/clk] [get_bd_pins trace_cntrl_32_0/ap_clk]
  connect_bd_net -net axi_dma_0_s2mm_introut [get_bd_pins s2mm_introut] [get_bd_pins axi_dma_0/s2mm_introut]
  connect_bd_net -net axi_resetn_1 [get_bd_pins axi_resetn] [get_bd_pins axi_dma_0/axi_resetn] [get_bd_pins axis_data_fifo_0/s_axis_aresetn] [get_bd_pins trace_cntrl_32_0/ap_rst_n]
  connect_bd_net -net constant_tkeep_tstrb_dout [get_bd_pins constant_tkeep_tstrb/dout] [get_bd_pins trace_cntrl_32_0/trace_32_TKEEP] [get_bd_pins trace_cntrl_32_0/trace_32_TSTRB]
  connect_bd_net -net data_1 [get_bd_pins data] [get_bd_pins dff_en_reset_vector_0/d]
  connect_bd_net -net dff_en_reset_vector_0_q [get_bd_pins dff_en_reset_vector_0/q] [get_bd_pins trace_cntrl_32_0/trace_32_TDATA]
  connect_bd_net -net logic_0_dout [get_bd_pins dff_en_reset_vector_0/reset] [get_bd_pins logic_0/dout]
  connect_bd_net -net logic_1_dout [get_bd_pins dff_en_reset_vector_0/en] [get_bd_pins logic_1/dout]
  connect_bd_net -net valid_1 [get_bd_pins valid] [get_bd_pins trace_cntrl_32_0/trace_32_TVALID]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: trace_analyzer_pmod0
proc create_hier_cell_trace_analyzer_pmod0 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_trace_analyzer_pmod0() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_S2MM

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_trace_cntrl


  # Create pins
  create_bd_pin -dir I -type clk ap_clk
  create_bd_pin -dir I -type rst axi_resetn
  create_bd_pin -dir I -from 31 -to 0 data
  create_bd_pin -dir O s2mm_introut
  create_bd_pin -dir I valid

  # Create instance: axi_dma_0, and set properties
  set axi_dma_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_0 ]
  set_property -dict [ list \
   CONFIG.c_include_mm2s {0} \
   CONFIG.c_include_sg {0} \
   CONFIG.c_s2mm_burst_size {64} \
   CONFIG.c_sg_include_stscntrl_strm {0} \
   CONFIG.c_sg_length_width {23} \
 ] $axi_dma_0

  # Create instance: axis_data_fifo_0, and set properties
  set axis_data_fifo_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 axis_data_fifo_0 ]
  set_property -dict [ list \
   CONFIG.FIFO_DEPTH {256} \
   CONFIG.HAS_RD_DATA_COUNT {1} \
   CONFIG.HAS_TLAST {1} \
   CONFIG.HAS_WR_DATA_COUNT {1} \
 ] $axis_data_fifo_0

  # Create instance: constant_tkeep_tstrb, and set properties
  set constant_tkeep_tstrb [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 constant_tkeep_tstrb ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {15} \
   CONFIG.CONST_WIDTH {4} \
 ] $constant_tkeep_tstrb

  # Create instance: dff_en_reset_vector_0, and set properties
  set dff_en_reset_vector_0 [ create_bd_cell -type ip -vlnv xilinx.com:user:dff_en_reset_vector:1.0 dff_en_reset_vector_0 ]
  set_property -dict [ list \
   CONFIG.SIZE {32} \
 ] $dff_en_reset_vector_0

  # Create instance: logic_0, and set properties
  set logic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 logic_0 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
 ] $logic_0

  # Create instance: logic_1, and set properties
  set logic_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 logic_1 ]

  # Create instance: trace_cntrl_32_0, and set properties
  set trace_cntrl_32_0 [ create_bd_cell -type ip -vlnv xilinx.com:hls:trace_cntrl_32:1.4 trace_cntrl_32_0 ]

  # Create interface connections
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins S_AXI_LITE] [get_bd_intf_pins axi_dma_0/S_AXI_LITE]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins M_AXI_S2MM] [get_bd_intf_pins axi_dma_0/M_AXI_S2MM]
  connect_bd_intf_net -intf_net axis_data_fifo_0_M_AXIS [get_bd_intf_pins axi_dma_0/S_AXIS_S2MM] [get_bd_intf_pins axis_data_fifo_0/M_AXIS]
  connect_bd_intf_net -intf_net s_axi_trace_cntrl_1 [get_bd_intf_pins s_axi_trace_cntrl] [get_bd_intf_pins trace_cntrl_32_0/s_axi_trace_cntrl]
  connect_bd_intf_net -intf_net trace_cntrl_32_0_capture_32 [get_bd_intf_pins axis_data_fifo_0/S_AXIS] [get_bd_intf_pins trace_cntrl_32_0/capture_32]

  # Create port connections
  connect_bd_net -net Net5 [get_bd_pins ap_clk] [get_bd_pins axi_dma_0/m_axi_s2mm_aclk] [get_bd_pins axi_dma_0/s_axi_lite_aclk] [get_bd_pins axis_data_fifo_0/s_axis_aclk] [get_bd_pins dff_en_reset_vector_0/clk] [get_bd_pins trace_cntrl_32_0/ap_clk]
  connect_bd_net -net axi_dma_0_s2mm_introut [get_bd_pins s2mm_introut] [get_bd_pins axi_dma_0/s2mm_introut]
  connect_bd_net -net axi_resetn_1 [get_bd_pins axi_resetn] [get_bd_pins axi_dma_0/axi_resetn] [get_bd_pins axis_data_fifo_0/s_axis_aresetn] [get_bd_pins trace_cntrl_32_0/ap_rst_n]
  connect_bd_net -net constant_tkeep_tstrb_dout [get_bd_pins constant_tkeep_tstrb/dout] [get_bd_pins trace_cntrl_32_0/trace_32_TKEEP] [get_bd_pins trace_cntrl_32_0/trace_32_TSTRB]
  connect_bd_net -net data_1 [get_bd_pins data] [get_bd_pins dff_en_reset_vector_0/d]
  connect_bd_net -net dff_en_reset_vector_0_q [get_bd_pins dff_en_reset_vector_0/q] [get_bd_pins trace_cntrl_32_0/trace_32_TDATA]
  connect_bd_net -net logic_0_dout [get_bd_pins dff_en_reset_vector_0/reset] [get_bd_pins logic_0/dout]
  connect_bd_net -net valid_1 [get_bd_pins valid] [get_bd_pins trace_cntrl_32_0/trace_32_TVALID]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins dff_en_reset_vector_0/en] [get_bd_pins logic_1/dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: trace_analyzer_pi
proc create_hier_cell_trace_analyzer_pi { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_trace_analyzer_pi() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_S2MM

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_trace_cntrl


  # Create pins
  create_bd_pin -dir I -type clk ap_clk
  create_bd_pin -dir I -type rst axi_resetn
  create_bd_pin -dir I -from 63 -to 0 data
  create_bd_pin -dir O s2mm_introut
  create_bd_pin -dir I valid

  # Create instance: axi_dma_0, and set properties
  set axi_dma_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_0 ]
  set_property -dict [ list \
   CONFIG.c_include_mm2s {0} \
   CONFIG.c_include_sg {0} \
   CONFIG.c_s2mm_burst_size {64} \
   CONFIG.c_sg_include_stscntrl_strm {0} \
   CONFIG.c_sg_length_width {23} \
 ] $axi_dma_0

  # Create instance: axis_data_fifo_0, and set properties
  set axis_data_fifo_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 axis_data_fifo_0 ]
  set_property -dict [ list \
   CONFIG.FIFO_DEPTH {256} \
   CONFIG.HAS_TLAST {1} \
 ] $axis_data_fifo_0

  # Create instance: constant_tkeep_tstrb, and set properties
  set constant_tkeep_tstrb [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 constant_tkeep_tstrb ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {255} \
   CONFIG.CONST_WIDTH {8} \
 ] $constant_tkeep_tstrb

  # Create instance: dff_en_reset_vector_0, and set properties
  set dff_en_reset_vector_0 [ create_bd_cell -type ip -vlnv xilinx.com:user:dff_en_reset_vector:1.0 dff_en_reset_vector_0 ]
  set_property -dict [ list \
   CONFIG.SIZE {64} \
 ] $dff_en_reset_vector_0

  # Create instance: logic_0, and set properties
  set logic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 logic_0 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
 ] $logic_0

  # Create instance: logic_1, and set properties
  set logic_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 logic_1 ]

  # Create instance: trace_cntrl_64_0, and set properties
  set trace_cntrl_64_0 [ create_bd_cell -type ip -vlnv xilinx.com:hls:trace_cntrl_64:1.4 trace_cntrl_64_0 ]

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins s_axi_trace_cntrl] [get_bd_intf_pins trace_cntrl_64_0/s_axi_trace_cntrl]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins S_AXI_LITE] [get_bd_intf_pins axi_dma_0/S_AXI_LITE]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins M_AXI_S2MM] [get_bd_intf_pins axi_dma_0/M_AXI_S2MM]
  connect_bd_intf_net -intf_net axis_data_fifo_0_M_AXIS [get_bd_intf_pins axi_dma_0/S_AXIS_S2MM] [get_bd_intf_pins axis_data_fifo_0/M_AXIS]
  connect_bd_intf_net -intf_net trace_cntrl_64_0_capture_64 [get_bd_intf_pins axis_data_fifo_0/S_AXIS] [get_bd_intf_pins trace_cntrl_64_0/capture_64]

  # Create port connections
  connect_bd_net -net Net5 [get_bd_pins ap_clk] [get_bd_pins axi_dma_0/m_axi_s2mm_aclk] [get_bd_pins axi_dma_0/s_axi_lite_aclk] [get_bd_pins axis_data_fifo_0/s_axis_aclk] [get_bd_pins dff_en_reset_vector_0/clk] [get_bd_pins trace_cntrl_64_0/ap_clk]
  connect_bd_net -net axi_dma_0_s2mm_introut [get_bd_pins s2mm_introut] [get_bd_pins axi_dma_0/s2mm_introut]
  connect_bd_net -net axi_resetn_1 [get_bd_pins axi_resetn] [get_bd_pins axi_dma_0/axi_resetn] [get_bd_pins axis_data_fifo_0/s_axis_aresetn] [get_bd_pins trace_cntrl_64_0/ap_rst_n]
  connect_bd_net -net constant_tkeep_tstrb_dout [get_bd_pins constant_tkeep_tstrb/dout] [get_bd_pins trace_cntrl_64_0/trace_64_TKEEP] [get_bd_pins trace_cntrl_64_0/trace_64_TSTRB]
  connect_bd_net -net data_1 [get_bd_pins data] [get_bd_pins dff_en_reset_vector_0/d]
  connect_bd_net -net dff_en_reset_vector_0_q [get_bd_pins dff_en_reset_vector_0/q] [get_bd_pins trace_cntrl_64_0/trace_64_TDATA]
  connect_bd_net -net logic_0_dout [get_bd_pins dff_en_reset_vector_0/reset] [get_bd_pins logic_0/dout]
  connect_bd_net -net logic_1_dout [get_bd_pins dff_en_reset_vector_0/en] [get_bd_pins logic_1/dout]
  connect_bd_net -net valid_1 [get_bd_pins valid] [get_bd_pins trace_cntrl_64_0/trace_64_TVALID]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: mipi
proc create_hier_cell_mipi { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_mipi() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M00_AXI

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 cam_gpio

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 csirxss_s_axi

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:mipi_phy_rtl:1.0 mipi_phy_if_0

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_CTRL

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_CTRL1

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_ctrl2

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_ctrl3


  # Create pins
  create_bd_pin -dir O -type intr csirxss_csi_irq
  create_bd_pin -dir I -type clk dphy_clk_200M
  create_bd_pin -dir I -type clk lite_aclk
  create_bd_pin -dir I -type rst lite_aresetn
  create_bd_pin -dir O -type intr s2mm_introut
  create_bd_pin -dir I -type clk video_aclk
  create_bd_pin -dir I -type rst video_aresetn

  # Create instance: axi_interconnect, and set properties
  set axi_interconnect [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect ]
  set_property -dict [ list \
   CONFIG.NUM_MI {1} \
 ] $axi_interconnect

  # Create instance: axi_vdma, and set properties
  set axi_vdma [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vdma:6.3 axi_vdma ]
  set_property -dict [ list \
   CONFIG.c_include_mm2s {0} \
   CONFIG.c_include_mm2s_dre {0} \
   CONFIG.c_include_s2mm_dre {0} \
   CONFIG.c_m_axi_mm2s_data_width {128} \
   CONFIG.c_m_axi_s2mm_data_width {128} \
   CONFIG.c_m_axis_mm2s_tdata_width {64} \
   CONFIG.c_mm2s_genlock_mode {3} \
   CONFIG.c_mm2s_linebuffer_depth {4096} \
   CONFIG.c_mm2s_max_burst_length {256} \
   CONFIG.c_num_fstores {4} \
   CONFIG.c_s2mm_genlock_mode {2} \
   CONFIG.c_s2mm_linebuffer_depth {4096} \
   CONFIG.c_s2mm_max_burst_length {256} \
 ] $axi_vdma

  # Create instance: axis_subset_converter, and set properties
  set axis_subset_converter [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_subset_converter:1.1 axis_subset_converter ]
  set_property -dict [ list \
   CONFIG.M_HAS_TLAST {1} \
   CONFIG.M_TDATA_NUM_BYTES {2} \
   CONFIG.M_TDEST_WIDTH {10} \
   CONFIG.M_TUSER_WIDTH {1} \
   CONFIG.S_HAS_TLAST {1} \
   CONFIG.S_TDATA_NUM_BYTES {3} \
   CONFIG.S_TDEST_WIDTH {10} \
   CONFIG.S_TUSER_WIDTH {1} \
   CONFIG.TDATA_REMAP {tdata[19:12],tdata[9:2]} \
   CONFIG.TDEST_REMAP {tdest[9:0]} \
   CONFIG.TLAST_REMAP {tlast[0]} \
   CONFIG.TUSER_REMAP {tuser[0:0]} \
 ] $axis_subset_converter

  # Create instance: demosaic, and set properties
  set demosaic [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_demosaic:1.1 demosaic ]
  set_property -dict [ list \
   CONFIG.MAX_COLS {3840} \
   CONFIG.MAX_ROWS {2160} \
   CONFIG.SAMPLES_PER_CLOCK {2} \
   CONFIG.USE_URAM {1} \
 ] $demosaic

  # Create instance: gamma_lut, and set properties
  set gamma_lut [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_gamma_lut:1.1 gamma_lut ]
  set_property -dict [ list \
   CONFIG.MAX_COLS {3840} \
   CONFIG.MAX_ROWS {2160} \
   CONFIG.SAMPLES_PER_CLOCK {2} \
 ] $gamma_lut

  # Create instance: gpio_ip_reset, and set properties
  set gpio_ip_reset [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 gpio_ip_reset ]
  set_property -dict [ list \
   CONFIG.C_ALL_OUTPUTS {1} \
   CONFIG.C_ALL_OUTPUTS_2 {1} \
   CONFIG.C_GPIO2_WIDTH {1} \
   CONFIG.C_GPIO_WIDTH {1} \
   CONFIG.C_IS_DUAL {1} \
   CONFIG.C_DOUT_DEFAULT_2 {0x00000001} \
 ] $gpio_ip_reset

  # Create instance: mipi_csi2_rx_subsyst, and set properties
  set mipi_csi2_rx_subsyst [ create_bd_cell -type ip -vlnv xilinx.com:ip:mipi_csi2_rx_subsystem:6.0 mipi_csi2_rx_subsyst ]
  set_property -dict [ list \
   CONFIG.CLK_LANE_IO_LOC {D7} \
   CONFIG.CLK_LANE_IO_LOC_NAME {IO_L13P_T2L_N0_GC_QBC_66} \
   CONFIG.CMN_NUM_LANES {2} \
   CONFIG.CMN_NUM_PIXELS {2} \
   CONFIG.CMN_PXL_FORMAT {RAW10} \
   CONFIG.CSI_BUF_DEPTH {4096} \
   CONFIG.C_CLK_LANE_IO_POSITION {26} \
   CONFIG.C_CSI_FILTER_USERDATATYPE {true} \
   CONFIG.C_DATA_LANE0_IO_POSITION {28} \
   CONFIG.C_DATA_LANE1_IO_POSITION {30} \
   CONFIG.C_DPHY_LANES {2} \
   CONFIG.C_EN_BG0_PIN0 {false} \
   CONFIG.C_EN_BG1_PIN0 {false} \
   CONFIG.C_HS_LINE_RATE {672} \
   CONFIG.C_HS_SETTLE_NS {149} \
   CONFIG.DATA_LANE0_IO_LOC {E5} \
   CONFIG.DATA_LANE0_IO_LOC_NAME {IO_L14P_T2L_N2_GC_66} \
   CONFIG.DATA_LANE1_IO_LOC {G6} \
   CONFIG.DATA_LANE1_IO_LOC_NAME {IO_L15P_T2L_N4_AD11P_66} \
   CONFIG.DPY_EN_REG_IF {true} \
   CONFIG.DPY_LINE_RATE {672} \
   CONFIG.HP_IO_BANK_SELECTION {66} \
   CONFIG.SupportLevel {1} \
 ] $mipi_csi2_rx_subsyst

  # Create instance: v_proc_sys, and set properties
  set v_proc_sys [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_proc_ss:2.3 v_proc_sys ]
  set_property -dict [ list \
   CONFIG.C_COLORSPACE_SUPPORT {2} \
   CONFIG.C_CSC_ENABLE_WINDOW {false} \
   CONFIG.C_MAX_COLS {3840} \
   CONFIG.C_MAX_DATA_WIDTH {8} \
   CONFIG.C_MAX_ROWS {2160} \
   CONFIG.C_TOPOLOGY {3} \
 ] $v_proc_sys

  # Create instance: axis_channel_swap, and set properties
  set axis_channel_swap [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_subset_converter:1.1 axis_channel_swap ]
  set_property -dict [ list \
   CONFIG.M_HAS_TKEEP {0} \
   CONFIG.M_HAS_TLAST {1} \
   CONFIG.M_HAS_TREADY {1} \
   CONFIG.M_HAS_TSTRB {0} \
   CONFIG.M_TDATA_NUM_BYTES {6} \
   CONFIG.M_TUSER_WIDTH {1} \
   CONFIG.S_HAS_TKEEP {0} \
   CONFIG.S_HAS_TLAST {1} \
   CONFIG.S_HAS_TREADY {1} \
   CONFIG.S_HAS_TSTRB {0} \
   CONFIG.S_TDATA_NUM_BYTES {6} \
   CONFIG.S_TUSER_WIDTH {1} \
   CONFIG.TDATA_REMAP {tdata[39:24], tdata[47:40], tdata[15:0], tdata[23:16]} \
   CONFIG.TLAST_REMAP {tlast[0]} \
   CONFIG.TUSER_REMAP {tuser[0:0]} \
 ] $axis_channel_swap

  # Create instance: pixel_pack, and set properties
  set pixel_pack [ create_bd_cell -type ip -vlnv xilinx.com:hls:pixel_pack_2:1.0 pixel_pack ]

  # Create instance: proc_sys_reset, and set properties
  set proc_sys_reset [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset ]
  set_property -dict [ list \
   CONFIG.C_AUX_RESET_HIGH {0} \
 ] $proc_sys_reset

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins S_AXI_LITE] [get_bd_intf_pins axi_vdma/S_AXI_LITE]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins s_axi_CTRL] [get_bd_intf_pins demosaic/s_axi_CTRL]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins s_axi_CTRL1] [get_bd_intf_pins gamma_lut/s_axi_CTRL]
  connect_bd_intf_net -intf_net Conn4 [get_bd_intf_pins s_axi_ctrl2] [get_bd_intf_pins v_proc_sys/s_axi_ctrl]
  connect_bd_intf_net -intf_net Conn5 [get_bd_intf_pins S_AXI] [get_bd_intf_pins gpio_ip_reset/S_AXI]
  connect_bd_intf_net -intf_net gpio_ip_reset_GPIO2 [get_bd_intf_pins cam_gpio] [get_bd_intf_pins gpio_ip_reset/GPIO2]
  connect_bd_intf_net -intf_net Conn10 [get_bd_intf_pins s_axi_ctrl3] [get_bd_intf_pins pixel_pack/s_axi_control]
  connect_bd_intf_net -intf_net axi_interconnect_M00_AXI [get_bd_intf_pins M00_AXI] [get_bd_intf_pins axi_interconnect/M00_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_M26_AXI [get_bd_intf_pins csirxss_s_axi] [get_bd_intf_pins mipi_csi2_rx_subsyst/csirxss_s_axi]
  connect_bd_intf_net -intf_net axi_vdma_0_M_AXI_S2MM [get_bd_intf_pins axi_interconnect/S00_AXI] [get_bd_intf_pins axi_vdma/M_AXI_S2MM]
  connect_bd_intf_net -intf_net axis_subset_converter_0_M_AXIS [get_bd_intf_pins axis_subset_converter/M_AXIS] [get_bd_intf_pins demosaic/s_axis_video]
  connect_bd_intf_net -intf_net dm0_m_axis_video [get_bd_intf_pins demosaic/m_axis_video] [get_bd_intf_pins gamma_lut/s_axis_video]
  connect_bd_intf_net -intf_net mipi_csi2_rx_subsyst_0_video_out [get_bd_intf_pins axis_subset_converter/S_AXIS] [get_bd_intf_pins mipi_csi2_rx_subsyst/video_out]
  connect_bd_intf_net -intf_net mipi_phy_if_0_1 [get_bd_intf_pins mipi_phy_if_0] [get_bd_intf_pins mipi_csi2_rx_subsyst/mipi_phy_if]
  connect_bd_intf_net -intf_net gammalut_m_axis [get_bd_intf_pins gamma_lut/m_axis_video] [get_bd_intf_pins v_proc_sys/s_axis]
  connect_bd_intf_net -intf_net v_proc_sys_0_m_axis [get_bd_intf_pins v_proc_sys/m_axis] [get_bd_intf_pins axis_channel_swap/S_AXIS]
  connect_bd_intf_net -intf_net axis_channel_swap_m_axis [get_bd_intf_pins axis_channel_swap/M_AXIS] [get_bd_intf_pins pixel_pack/stream_in_48]
  connect_bd_intf_net -intf_net pixel_pack_m_axis [get_bd_intf_pins pixel_pack/stream_out_64] [get_bd_intf_pins axi_vdma/S_AXIS_S2MM]

  # Create port connections
  connect_bd_net -net axi_gpio_ip_reset_gpio_io_o [get_bd_pins gpio_ip_reset/gpio_io_o] [get_bd_pins proc_sys_reset/aux_reset_in]
  connect_bd_net -net soft_peripheral_aresetn [get_bd_pins proc_sys_reset/peripheral_aresetn] [get_bd_pins demosaic/ap_rst_n] [get_bd_pins gamma_lut/ap_rst_n]  [get_bd_pins v_proc_sys/aresetn] [get_bd_pins axis_channel_swap/aresetn] [get_bd_pins pixel_pack/ap_rst_n] [get_bd_pins pixel_pack/ap_rst_n_control]
  connect_bd_net -net axi_vdma_mipi_s2mm_introut [get_bd_pins s2mm_introut] [get_bd_pins axi_vdma/s2mm_introut]
  connect_bd_net -net clk_wiz_0_clk_out1 [get_bd_pins dphy_clk_200M] [get_bd_pins mipi_csi2_rx_subsyst/dphy_clk_200M]
  connect_bd_net -net mipi_csi2_rx_subsyst_0_csirxss_csi_irq [get_bd_pins csirxss_csi_irq] [get_bd_pins mipi_csi2_rx_subsyst/csirxss_csi_irq]
  connect_bd_net -net net_zynq_us_ss_0_clk_out2 [get_bd_pins video_aclk] [get_bd_pins axi_interconnect/ACLK] [get_bd_pins axi_interconnect/M00_ACLK] [get_bd_pins axi_interconnect/S00_ACLK] [get_bd_pins axi_vdma/m_axi_mm2s_aclk] [get_bd_pins axi_vdma/m_axi_s2mm_aclk] [get_bd_pins axi_vdma/m_axis_mm2s_aclk] [get_bd_pins axi_vdma/s_axis_s2mm_aclk] [get_bd_pins axis_subset_converter/aclk] [get_bd_pins demosaic/ap_clk] [get_bd_pins gamma_lut/ap_clk] [get_bd_pins gpio_ip_reset/s_axi_aclk] [get_bd_pins mipi_csi2_rx_subsyst/video_aclk] [get_bd_pins v_proc_sys/aclk] [get_bd_pins axis_channel_swap/aclk] [get_bd_pins pixel_pack/ap_clk] [get_bd_pins pixel_pack/control] [get_bd_pins proc_sys_reset/slowest_sync_clk]
  connect_bd_net -net net_zynq_us_ss_0_dcm_locked [get_bd_pins video_aresetn] [get_bd_pins axi_interconnect/ARESETN] [get_bd_pins axi_interconnect/M00_ARESETN] [get_bd_pins axi_interconnect/S00_ARESETN] [get_bd_pins axis_subset_converter/aresetn] [get_bd_pins gpio_ip_reset/s_axi_aresetn] [get_bd_pins mipi_csi2_rx_subsyst/video_aresetn] [get_bd_pins proc_sys_reset/ext_reset_in]
  connect_bd_net -net net_zynq_us_ss_0_peripheral_aresetn [get_bd_pins lite_aresetn] [get_bd_pins axi_vdma/axi_resetn] [get_bd_pins mipi_csi2_rx_subsyst/lite_aresetn]
  connect_bd_net -net net_zynq_us_ss_0_s_axi_aclk [get_bd_pins lite_aclk] [get_bd_pins axi_vdma/s_axi_lite_aclk] [get_bd_pins mipi_csi2_rx_subsyst/lite_aclk]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: iop_rpi
proc create_hier_cell_iop_rpi { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_iop_rpi() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:mbdebug_rtl:3.0 DEBUG

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI


  # Create pins
  create_bd_pin -dir I -from 0 -to 0 -type rst aux_reset_in
  create_bd_pin -dir I -type clk clk_100M
  create_bd_pin -dir I -from 27 -to 0 data_i
  create_bd_pin -dir O -from 27 -to 0 data_o
  create_bd_pin -dir I -from 0 -to 0 intr_ack
  create_bd_pin -dir O -from 0 -to 0 intr_req
  create_bd_pin -dir I -type rst mb_debug_sys_rst
  create_bd_pin -dir O -from 0 -to 0 -type rst peripheral_aresetn
  create_bd_pin -dir I -from 0 -to 0 -type rst s_axi_aresetn
  create_bd_pin -dir O -from 27 -to 0 tri_o

  # Create instance: dff_en_reset_vector_0, and set properties
  set dff_en_reset_vector_0 [ create_bd_cell -type ip -vlnv xilinx.com:user:dff_en_reset_vector:1.0 dff_en_reset_vector_0 ]
  set_property -dict [ list \
   CONFIG.SIZE {1} \
 ] $dff_en_reset_vector_0

  # Create instance: iic_subsystem
  create_hier_cell_iic_subsystem $hier_obj iic_subsystem

  # Create instance: intc, and set properties
  set intc [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_intc:4.1 intc ]

  # Create instance: intr, and set properties
  set intr [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 intr ]
  set_property -dict [ list \
   CONFIG.C_ALL_OUTPUTS {1} \
   CONFIG.C_GPIO_WIDTH {1} \
 ] $intr

  # Create instance: intr_concat, and set properties
  set intr_concat [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 intr_concat ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {7} \
 ] $intr_concat

  # Create instance: io_switch, and set properties
  set io_switch [ create_bd_cell -type ip -vlnv xilinx.com:user:io_switch:1.1 io_switch ]
  set_property -dict [ list \
   CONFIG.C_INTERFACE_TYPE {4} \
   CONFIG.C_IO_SWITCH_WIDTH {28} \
   CONFIG.C_NUM_PWMS {2} \
   CONFIG.C_NUM_SS {2} \
   CONFIG.C_NUM_TIMERS {3} \
   CONFIG.I2C0_Enable {true} \
   CONFIG.I2C1_Enable {true} \
   CONFIG.PWM_Enable {true} \
   CONFIG.SPI0_Enable {true} \
   CONFIG.SPI1_Enable {true} \
   CONFIG.Timer_Enable {false} \
   CONFIG.UART0_Enable {true} \
 ] $io_switch

  # Create instance: lmb
  create_hier_cell_lmb_3 $hier_obj lmb

  # Create instance: logic_1, and set properties
  set logic_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 logic_1 ]

  # Create instance: mb, and set properties
  set mb [ create_bd_cell -type ip -vlnv xilinx.com:ip:microblaze:11.0 mb ]
  set_property -dict [ list \
   CONFIG.C_DEBUG_ENABLED {1} \
   CONFIG.C_D_AXI {1} \
   CONFIG.C_D_LMB {1} \
   CONFIG.C_I_LMB {1} \
 ] $mb

  # Create instance: mb_bram_ctrl, and set properties
  set mb_bram_ctrl [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.1 mb_bram_ctrl ]
  set_property -dict [ list \
   CONFIG.SINGLE_PORT_BRAM {1} \
 ] $mb_bram_ctrl

  # Create instance: microblaze_0_axi_periph, and set properties
  set microblaze_0_axi_periph [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 microblaze_0_axi_periph ]
  set_property -dict [ list \
   CONFIG.M00_HAS_REGSLICE {1} \
   CONFIG.M01_HAS_REGSLICE {1} \
   CONFIG.M02_HAS_REGSLICE {1} \
   CONFIG.M03_HAS_REGSLICE {1} \
   CONFIG.M04_HAS_REGSLICE {1} \
   CONFIG.M05_HAS_REGSLICE {1} \
   CONFIG.M06_HAS_REGSLICE {1} \
   CONFIG.M07_HAS_REGSLICE {1} \
   CONFIG.NUM_MI {12} \
   CONFIG.S00_HAS_REGSLICE {1} \
 ] $microblaze_0_axi_periph

  # Create instance: rpi_gpio, and set properties
  set rpi_gpio [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 rpi_gpio ]
  set_property -dict [ list \
   CONFIG.C_ALL_OUTPUTS_2 {0} \
   CONFIG.C_GPIO2_WIDTH {32} \
   CONFIG.C_GPIO_WIDTH {28} \
   CONFIG.C_INTERRUPT_PRESENT {1} \
   CONFIG.C_IS_DUAL {0} \
 ] $rpi_gpio

  # Create instance: rst_clk_wiz_1_100M, and set properties
  set rst_clk_wiz_1_100M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_clk_wiz_1_100M ]
  set_property -dict [ list \
   CONFIG.C_AUX_RESET_HIGH {1} \
 ] $rst_clk_wiz_1_100M

  # Create instance: spi_subsystem
  create_hier_cell_spi_subsystem $hier_obj spi_subsystem

  # Create instance: timers_subsystem
  create_hier_cell_timers_subsystem $hier_obj timers_subsystem

  # Create instance: uartlite, and set properties
  set uartlite [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_uartlite:2.0 uartlite ]

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins M_AXI] [get_bd_intf_pins microblaze_0_axi_periph/M07_AXI]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins S_AXI] [get_bd_intf_pins mb_bram_ctrl/S_AXI]
  connect_bd_intf_net -intf_net axi_bram_ctrl_0_BRAM_PORTA [get_bd_intf_pins lmb/BRAM_PORTB] [get_bd_intf_pins mb_bram_ctrl/BRAM_PORTA]
  connect_bd_intf_net -intf_net gpio_GPIO [get_bd_intf_pins io_switch/gpio] [get_bd_intf_pins rpi_gpio/GPIO]
  connect_bd_intf_net -intf_net iic_IIC [get_bd_intf_pins iic_subsystem/IIC_0] [get_bd_intf_pins io_switch/iic0]
  connect_bd_intf_net -intf_net iic_subsystem_IIC [get_bd_intf_pins iic_subsystem/IIC] [get_bd_intf_pins io_switch/iic1]
  connect_bd_intf_net -intf_net mb1_intc_interrupt [get_bd_intf_pins intc/interrupt] [get_bd_intf_pins mb/INTERRUPT]
  connect_bd_intf_net -intf_net microblaze_0_M_AXI_DP [get_bd_intf_pins mb/M_AXI_DP] [get_bd_intf_pins microblaze_0_axi_periph/S00_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M00_AXI [get_bd_intf_pins microblaze_0_axi_periph/M00_AXI] [get_bd_intf_pins spi_subsystem/S01_AXILite]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M01_AXI [get_bd_intf_pins iic_subsystem/S00_AXILite] [get_bd_intf_pins microblaze_0_axi_periph/M01_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M02_AXI [get_bd_intf_pins io_switch/S_AXI] [get_bd_intf_pins microblaze_0_axi_periph/M02_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M03_AXI [get_bd_intf_pins microblaze_0_axi_periph/M03_AXI] [get_bd_intf_pins rpi_gpio/S_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M04_AXI [get_bd_intf_pins microblaze_0_axi_periph/M04_AXI] [get_bd_intf_pins timers_subsystem/S00_AXILite]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M05_AXI [get_bd_intf_pins intc/s_axi] [get_bd_intf_pins microblaze_0_axi_periph/M05_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M06_AXI [get_bd_intf_pins intr/S_AXI] [get_bd_intf_pins microblaze_0_axi_periph/M06_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M08_AXI [get_bd_intf_pins microblaze_0_axi_periph/M08_AXI] [get_bd_intf_pins uartlite/S_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M09_AXI [get_bd_intf_pins microblaze_0_axi_periph/M09_AXI] [get_bd_intf_pins timers_subsystem/S01_AXILite]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M10_AXI [get_bd_intf_pins iic_subsystem/S01_AXILite] [get_bd_intf_pins microblaze_0_axi_periph/M10_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M11_AXI [get_bd_intf_pins microblaze_0_axi_periph/M11_AXI] [get_bd_intf_pins spi_subsystem/S00_AXILite]
  connect_bd_intf_net -intf_net microblaze_0_debug [get_bd_intf_pins DEBUG] [get_bd_intf_pins mb/DEBUG]
  connect_bd_intf_net -intf_net microblaze_0_dlmb_1 [get_bd_intf_pins lmb/DLMB] [get_bd_intf_pins mb/DLMB]
  connect_bd_intf_net -intf_net microblaze_0_ilmb_1 [get_bd_intf_pins lmb/ILMB] [get_bd_intf_pins mb/ILMB]
  connect_bd_intf_net -intf_net spi_1_SPI_0 [get_bd_intf_pins io_switch/spi1] [get_bd_intf_pins spi_subsystem/SPI_0]
  connect_bd_intf_net -intf_net spi_SPI_0 [get_bd_intf_pins io_switch/spi0] [get_bd_intf_pins spi_subsystem/SPI_1]
  connect_bd_intf_net -intf_net uartlite_UART [get_bd_intf_pins io_switch/uart0] [get_bd_intf_pins uartlite/UART]

  # Create port connections
  connect_bd_net -net dff_en_reset_vector_0_q [get_bd_pins intr_req] [get_bd_pins dff_en_reset_vector_0/q]
  connect_bd_net -net iic_subsystem_iic2intc_irpt [get_bd_pins iic_subsystem/iic2intc_1_irpt] [get_bd_pins intr_concat/In1]
  connect_bd_net -net io_data_i_0_1 [get_bd_pins data_i] [get_bd_pins io_switch/io_data_i]
  connect_bd_net -net io_switch_io_data_o [get_bd_pins data_o] [get_bd_pins io_switch/io_data_o]
  connect_bd_net -net io_switch_io_tri_o [get_bd_pins tri_o] [get_bd_pins io_switch/io_tri_o]
  connect_bd_net -net iop_pmoda_intr_ack_1 [get_bd_pins intr_ack] [get_bd_pins dff_en_reset_vector_0/reset]
  connect_bd_net -net iop_pmoda_intr_gpio_io_o [get_bd_pins dff_en_reset_vector_0/en] [get_bd_pins intr/gpio_io_o]
  connect_bd_net -net logic_1_dout1 [get_bd_pins dff_en_reset_vector_0/d] [get_bd_pins logic_1/dout] [get_bd_pins rst_clk_wiz_1_100M/ext_reset_in]
  connect_bd_net -net mb1_iic_iic2intc_irpt [get_bd_pins iic_subsystem/iic2intc_0_irpt] [get_bd_pins intr_concat/In0]
  connect_bd_net -net mb1_interrupt_concat_dout [get_bd_pins intc/intr] [get_bd_pins intr_concat/dout]
  connect_bd_net -net mb_1_reset_Dout [get_bd_pins aux_reset_in] [get_bd_pins rst_clk_wiz_1_100M/aux_reset_in]
  connect_bd_net -net mdm_1_debug_sys_rst [get_bd_pins mb_debug_sys_rst] [get_bd_pins rst_clk_wiz_1_100M/mb_debug_sys_rst]
  connect_bd_net -net ps7_0_FCLK_CLK0 [get_bd_pins clk_100M] [get_bd_pins dff_en_reset_vector_0/clk] [get_bd_pins iic_subsystem/s_axi_aclk] [get_bd_pins intc/s_axi_aclk] [get_bd_pins intr/s_axi_aclk] [get_bd_pins io_switch/s_axi_aclk] [get_bd_pins lmb/LMB_Clk] [get_bd_pins mb/Clk] [get_bd_pins mb_bram_ctrl/s_axi_aclk] [get_bd_pins microblaze_0_axi_periph/ACLK] [get_bd_pins microblaze_0_axi_periph/M00_ACLK] [get_bd_pins microblaze_0_axi_periph/M01_ACLK] [get_bd_pins microblaze_0_axi_periph/M02_ACLK] [get_bd_pins microblaze_0_axi_periph/M03_ACLK] [get_bd_pins microblaze_0_axi_periph/M04_ACLK] [get_bd_pins microblaze_0_axi_periph/M05_ACLK] [get_bd_pins microblaze_0_axi_periph/M06_ACLK] [get_bd_pins microblaze_0_axi_periph/M07_ACLK] [get_bd_pins microblaze_0_axi_periph/M08_ACLK] [get_bd_pins microblaze_0_axi_periph/M09_ACLK] [get_bd_pins microblaze_0_axi_periph/M10_ACLK] [get_bd_pins microblaze_0_axi_periph/M11_ACLK] [get_bd_pins microblaze_0_axi_periph/S00_ACLK] [get_bd_pins rpi_gpio/s_axi_aclk] [get_bd_pins rst_clk_wiz_1_100M/slowest_sync_clk] [get_bd_pins spi_subsystem/s_axi_aclk] [get_bd_pins timers_subsystem/s_axi_aclk] [get_bd_pins uartlite/s_axi_aclk]
  connect_bd_net -net rpi_gpio_ip2intc_irpt [get_bd_pins intr_concat/In5] [get_bd_pins rpi_gpio/ip2intc_irpt]
  connect_bd_net -net rst_clk_wiz_1_100M_bus_struct_reset [get_bd_pins lmb/SYS_Rst] [get_bd_pins rst_clk_wiz_1_100M/bus_struct_reset]
  connect_bd_net -net rst_clk_wiz_1_100M_interconnect_aresetn [get_bd_pins microblaze_0_axi_periph/ARESETN] [get_bd_pins rst_clk_wiz_1_100M/interconnect_aresetn]
  connect_bd_net -net rst_clk_wiz_1_100M_mb_reset [get_bd_pins mb/Reset] [get_bd_pins rst_clk_wiz_1_100M/mb_reset]
  connect_bd_net -net rst_clk_wiz_1_100M_peripheral_aresetn [get_bd_pins peripheral_aresetn] [get_bd_pins iic_subsystem/s_axil_aresetn] [get_bd_pins intc/s_axi_aresetn] [get_bd_pins microblaze_0_axi_periph/M00_ARESETN] [get_bd_pins microblaze_0_axi_periph/M01_ARESETN] [get_bd_pins microblaze_0_axi_periph/M02_ARESETN] [get_bd_pins microblaze_0_axi_periph/M03_ARESETN] [get_bd_pins microblaze_0_axi_periph/M04_ARESETN] [get_bd_pins microblaze_0_axi_periph/M05_ARESETN] [get_bd_pins microblaze_0_axi_periph/M06_ARESETN] [get_bd_pins microblaze_0_axi_periph/M07_ARESETN] [get_bd_pins microblaze_0_axi_periph/M08_ARESETN] [get_bd_pins microblaze_0_axi_periph/M09_ARESETN] [get_bd_pins microblaze_0_axi_periph/M10_ARESETN] [get_bd_pins microblaze_0_axi_periph/M11_ARESETN] [get_bd_pins microblaze_0_axi_periph/S00_ARESETN] [get_bd_pins rpi_gpio/s_axi_aresetn] [get_bd_pins rst_clk_wiz_1_100M/peripheral_aresetn] [get_bd_pins spi_subsystem/s_axi_aresetn] [get_bd_pins timers_subsystem/s_axi_aresetn]
  connect_bd_net -net s_axi_aresetn_1 [get_bd_pins s_axi_aresetn] [get_bd_pins iic_subsystem/s_axi_aresetn1] [get_bd_pins intr/s_axi_aresetn] [get_bd_pins io_switch/s_axi_aresetn] [get_bd_pins mb_bram_ctrl/s_axi_aresetn] [get_bd_pins spi_subsystem/s_axi_aresetn1] [get_bd_pins timers_subsystem/s_axi_aresetn1] [get_bd_pins uartlite/s_axi_aresetn]
  connect_bd_net -net spi_subsystem_ip2intc_irpt [get_bd_pins intr_concat/In2] [get_bd_pins spi_subsystem/ip2intc_spi_0_irpt]
  connect_bd_net -net spi_subsystem_ip2intc_irpt1 [get_bd_pins intr_concat/In3] [get_bd_pins spi_subsystem/ip2intc_spi_1_irpt]
  connect_bd_net -net timers_subsystem_dout [get_bd_pins io_switch/pwm_o] [get_bd_pins timers_subsystem/dout]
  connect_bd_net -net timers_subsystem_dout1 [get_bd_pins intr_concat/In6] [get_bd_pins timers_subsystem/timers_interrupt]
  connect_bd_net -net uartlite_interrupt [get_bd_pins intr_concat/In4] [get_bd_pins uartlite/interrupt]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: iop_pmod1
proc create_hier_cell_iop_pmod1 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_iop_pmod1() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:mbdebug_rtl:3.0 DEBUG

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI


  # Create pins
  create_bd_pin -dir I -from 0 -to 0 -type rst aux_reset_in
  create_bd_pin -dir I -type clk clk_100M
  create_bd_pin -dir I -from 7 -to 0 data_i
  create_bd_pin -dir O -from 7 -to 0 data_o
  create_bd_pin -dir I -from 0 -to 0 intr_ack
  create_bd_pin -dir O -from 0 -to 0 intr_req
  create_bd_pin -dir I -type rst mb_debug_sys_rst
  create_bd_pin -dir O -from 0 -to 0 -type rst peripheral_aresetn
  create_bd_pin -dir I -from 0 -to 0 -type rst s_axi_aresetn
  create_bd_pin -dir O -from 7 -to 0 tri_o

  # Create instance: dff_en_reset_vector_0, and set properties
  set dff_en_reset_vector_0 [ create_bd_cell -type ip -vlnv xilinx.com:user:dff_en_reset_vector:1.0 dff_en_reset_vector_0 ]
  set_property -dict [ list \
   CONFIG.SIZE {1} \
 ] $dff_en_reset_vector_0

  # Create instance: gpio, and set properties
  set gpio [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 gpio ]
  set_property -dict [ list \
   CONFIG.C_ALL_OUTPUTS_2 {0} \
   CONFIG.C_GPIO2_WIDTH {32} \
   CONFIG.C_GPIO_WIDTH {8} \
   CONFIG.C_IS_DUAL {0} \
 ] $gpio

  # Create instance: iic, and set properties
  set iic [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_iic:2.1 iic ]

  # Create instance: intc, and set properties
  set intc [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_intc:4.1 intc ]

  # Create instance: intr, and set properties
  set intr [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 intr ]
  set_property -dict [ list \
   CONFIG.C_ALL_OUTPUTS {1} \
   CONFIG.C_GPIO_WIDTH {1} \
 ] $intr

  # Create instance: intr_concat, and set properties
  set intr_concat [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 intr_concat ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {3} \
 ] $intr_concat

  # Create instance: io_switch, and set properties
  set io_switch [ create_bd_cell -type ip -vlnv xilinx.com:user:io_switch:1.1 io_switch ]
  set_property -dict [ list \
   CONFIG.C_INTERFACE_TYPE {1} \
   CONFIG.C_IO_SWITCH_WIDTH {8} \
   CONFIG.C_NUM_PWMS {1} \
   CONFIG.C_NUM_TIMERS {1} \
   CONFIG.I2C0_Enable {true} \
   CONFIG.PWM_Enable {true} \
   CONFIG.SPI0_Enable {true} \
   CONFIG.Timer_Enable {true} \
 ] $io_switch

  # Create instance: lmb
  create_hier_cell_lmb_2 $hier_obj lmb

  # Create instance: logic_1, and set properties
  set logic_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 logic_1 ]

  # Create instance: mb, and set properties
  set mb [ create_bd_cell -type ip -vlnv xilinx.com:ip:microblaze:11.0 mb ]
  set_property -dict [ list \
   CONFIG.C_DEBUG_ENABLED {1} \
   CONFIG.C_D_AXI {1} \
   CONFIG.C_D_LMB {1} \
   CONFIG.C_I_LMB {1} \
 ] $mb

  # Create instance: mb_bram_ctrl, and set properties
  set mb_bram_ctrl [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.1 mb_bram_ctrl ]
  set_property -dict [ list \
   CONFIG.SINGLE_PORT_BRAM {1} \
 ] $mb_bram_ctrl

  # Create instance: microblaze_0_axi_periph, and set properties
  set microblaze_0_axi_periph [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 microblaze_0_axi_periph ]
  set_property -dict [ list \
   CONFIG.M00_HAS_REGSLICE {1} \
   CONFIG.M01_HAS_REGSLICE {1} \
   CONFIG.M02_HAS_REGSLICE {1} \
   CONFIG.M03_HAS_REGSLICE {1} \
   CONFIG.M04_HAS_REGSLICE {1} \
   CONFIG.M05_HAS_REGSLICE {1} \
   CONFIG.M06_HAS_REGSLICE {1} \
   CONFIG.M07_HAS_REGSLICE {1} \
   CONFIG.NUM_MI {8} \
   CONFIG.S00_HAS_REGSLICE {1} \
 ] $microblaze_0_axi_periph

  # Create instance: rst_clk_wiz_1_100M, and set properties
  set rst_clk_wiz_1_100M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_clk_wiz_1_100M ]
  set_property -dict [ list \
   CONFIG.C_AUX_RESET_HIGH {1} \
 ] $rst_clk_wiz_1_100M

  # Create instance: spi, and set properties
  set spi [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_quad_spi:3.2 spi ]
  set_property -dict [ list \
   CONFIG.C_USE_STARTUP {0} \
 ] $spi

  # Create instance: timer, and set properties
  set timer [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_timer:2.0 timer ]

  # Create interface connections
  connect_bd_intf_net -intf_net BRAM_PORTB_1 [get_bd_intf_pins lmb/BRAM_PORTB] [get_bd_intf_pins mb_bram_ctrl/BRAM_PORTA]
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins M_AXI] [get_bd_intf_pins microblaze_0_axi_periph/M07_AXI]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins S_AXI] [get_bd_intf_pins mb_bram_ctrl/S_AXI]
  connect_bd_intf_net -intf_net gpio_GPIO [get_bd_intf_pins gpio/GPIO] [get_bd_intf_pins io_switch/gpio]
  connect_bd_intf_net -intf_net iic_IIC [get_bd_intf_pins iic/IIC] [get_bd_intf_pins io_switch/iic0]
  connect_bd_intf_net -intf_net mb1_intc_interrupt [get_bd_intf_pins intc/interrupt] [get_bd_intf_pins mb/INTERRUPT]
  connect_bd_intf_net -intf_net microblaze_0_M_AXI_DP [get_bd_intf_pins mb/M_AXI_DP] [get_bd_intf_pins microblaze_0_axi_periph/S00_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M00_AXI [get_bd_intf_pins microblaze_0_axi_periph/M00_AXI] [get_bd_intf_pins spi/AXI_LITE]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M01_AXI [get_bd_intf_pins iic/S_AXI] [get_bd_intf_pins microblaze_0_axi_periph/M01_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M02_AXI [get_bd_intf_pins io_switch/S_AXI] [get_bd_intf_pins microblaze_0_axi_periph/M02_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M03_AXI [get_bd_intf_pins gpio/S_AXI] [get_bd_intf_pins microblaze_0_axi_periph/M03_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M04_AXI [get_bd_intf_pins microblaze_0_axi_periph/M04_AXI] [get_bd_intf_pins timer/S_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M05_AXI [get_bd_intf_pins intc/s_axi] [get_bd_intf_pins microblaze_0_axi_periph/M05_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M06_AXI [get_bd_intf_pins intr/S_AXI] [get_bd_intf_pins microblaze_0_axi_periph/M06_AXI]
  connect_bd_intf_net -intf_net microblaze_0_debug [get_bd_intf_pins DEBUG] [get_bd_intf_pins mb/DEBUG]
  connect_bd_intf_net -intf_net microblaze_0_dlmb_1 [get_bd_intf_pins lmb/DLMB] [get_bd_intf_pins mb/DLMB]
  connect_bd_intf_net -intf_net microblaze_0_ilmb_1 [get_bd_intf_pins lmb/ILMB] [get_bd_intf_pins mb/ILMB]
  connect_bd_intf_net -intf_net spi_SPI_0 [get_bd_intf_pins io_switch/spi0] [get_bd_intf_pins spi/SPI_0]

  # Create port connections
  connect_bd_net -net dff_en_reset_vector_0_q [get_bd_pins intr_req] [get_bd_pins dff_en_reset_vector_0/q]
  connect_bd_net -net io_data_i_0_1 [get_bd_pins data_i] [get_bd_pins io_switch/io_data_i]
  connect_bd_net -net io_switch_0_timer_i [get_bd_pins io_switch/timer_i] [get_bd_pins timer/capturetrig0]
  connect_bd_net -net io_switch_io_data_o [get_bd_pins data_o] [get_bd_pins io_switch/io_data_o]
  connect_bd_net -net io_switch_io_tri_o [get_bd_pins tri_o] [get_bd_pins io_switch/io_tri_o]
  connect_bd_net -net iop_pmoda_intr_ack_1 [get_bd_pins intr_ack] [get_bd_pins dff_en_reset_vector_0/reset]
  connect_bd_net -net iop_pmoda_intr_gpio_io_o [get_bd_pins dff_en_reset_vector_0/en] [get_bd_pins intr/gpio_io_o]
  connect_bd_net -net logic_1_dout1 [get_bd_pins dff_en_reset_vector_0/d] [get_bd_pins logic_1/dout] [get_bd_pins rst_clk_wiz_1_100M/ext_reset_in]
  connect_bd_net -net mb1_iic_iic2intc_irpt [get_bd_pins iic/iic2intc_irpt] [get_bd_pins intr_concat/In0]
  connect_bd_net -net mb1_interrupt_concat_dout [get_bd_pins intc/intr] [get_bd_pins intr_concat/dout]
  connect_bd_net -net mb1_spi_ip2intc_irpt [get_bd_pins intr_concat/In1] [get_bd_pins spi/ip2intc_irpt]
  connect_bd_net -net mb1_timer_generateout0 [get_bd_pins io_switch/timer_o] [get_bd_pins timer/generateout0]
  connect_bd_net -net mb1_timer_interrupt [get_bd_pins intr_concat/In2] [get_bd_pins timer/interrupt]
  connect_bd_net -net mb1_timer_pwm0 [get_bd_pins io_switch/pwm_o] [get_bd_pins timer/pwm0]
  connect_bd_net -net mb_1_reset_Dout [get_bd_pins aux_reset_in] [get_bd_pins rst_clk_wiz_1_100M/aux_reset_in]
  connect_bd_net -net mdm_1_debug_sys_rst [get_bd_pins mb_debug_sys_rst] [get_bd_pins rst_clk_wiz_1_100M/mb_debug_sys_rst]
  connect_bd_net -net ps7_0_FCLK_CLK0 [get_bd_pins clk_100M] [get_bd_pins dff_en_reset_vector_0/clk] [get_bd_pins gpio/s_axi_aclk] [get_bd_pins iic/s_axi_aclk] [get_bd_pins intc/s_axi_aclk] [get_bd_pins intr/s_axi_aclk] [get_bd_pins io_switch/s_axi_aclk] [get_bd_pins lmb/LMB_Clk] [get_bd_pins mb/Clk] [get_bd_pins mb_bram_ctrl/s_axi_aclk] [get_bd_pins microblaze_0_axi_periph/ACLK] [get_bd_pins microblaze_0_axi_periph/M00_ACLK] [get_bd_pins microblaze_0_axi_periph/M01_ACLK] [get_bd_pins microblaze_0_axi_periph/M02_ACLK] [get_bd_pins microblaze_0_axi_periph/M03_ACLK] [get_bd_pins microblaze_0_axi_periph/M04_ACLK] [get_bd_pins microblaze_0_axi_periph/M05_ACLK] [get_bd_pins microblaze_0_axi_periph/M06_ACLK] [get_bd_pins microblaze_0_axi_periph/M07_ACLK] [get_bd_pins microblaze_0_axi_periph/S00_ACLK] [get_bd_pins rst_clk_wiz_1_100M/slowest_sync_clk] [get_bd_pins spi/ext_spi_clk] [get_bd_pins spi/s_axi_aclk] [get_bd_pins timer/s_axi_aclk]
  connect_bd_net -net rst_clk_wiz_1_100M_bus_struct_reset [get_bd_pins lmb/SYS_Rst] [get_bd_pins rst_clk_wiz_1_100M/bus_struct_reset]
  connect_bd_net -net rst_clk_wiz_1_100M_interconnect_aresetn [get_bd_pins microblaze_0_axi_periph/ARESETN] [get_bd_pins rst_clk_wiz_1_100M/interconnect_aresetn]
  connect_bd_net -net rst_clk_wiz_1_100M_mb_reset [get_bd_pins mb/Reset] [get_bd_pins rst_clk_wiz_1_100M/mb_reset]
  connect_bd_net -net rst_clk_wiz_1_100M_peripheral_aresetn [get_bd_pins peripheral_aresetn] [get_bd_pins gpio/s_axi_aresetn] [get_bd_pins iic/s_axi_aresetn] [get_bd_pins intc/s_axi_aresetn] [get_bd_pins microblaze_0_axi_periph/M00_ARESETN] [get_bd_pins microblaze_0_axi_periph/M01_ARESETN] [get_bd_pins microblaze_0_axi_periph/M02_ARESETN] [get_bd_pins microblaze_0_axi_periph/M03_ARESETN] [get_bd_pins microblaze_0_axi_periph/M04_ARESETN] [get_bd_pins microblaze_0_axi_periph/M05_ARESETN] [get_bd_pins microblaze_0_axi_periph/M06_ARESETN] [get_bd_pins microblaze_0_axi_periph/M07_ARESETN] [get_bd_pins microblaze_0_axi_periph/S00_ARESETN] [get_bd_pins rst_clk_wiz_1_100M/peripheral_aresetn] [get_bd_pins spi/s_axi_aresetn] [get_bd_pins timer/s_axi_aresetn]
  connect_bd_net -net s_axi_aresetn_1 [get_bd_pins s_axi_aresetn] [get_bd_pins intr/s_axi_aresetn] [get_bd_pins io_switch/s_axi_aresetn] [get_bd_pins mb_bram_ctrl/s_axi_aresetn]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: iop_pmod0
proc create_hier_cell_iop_pmod0 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_iop_pmod0() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:mbdebug_rtl:3.0 DEBUG

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI


  # Create pins
  create_bd_pin -dir I -from 0 -to 0 -type rst aux_reset_in
  create_bd_pin -dir I -type clk clk_100M
  create_bd_pin -dir I -from 7 -to 0 data_i
  create_bd_pin -dir O -from 7 -to 0 data_o
  create_bd_pin -dir I -from 0 -to 0 intr_ack
  create_bd_pin -dir O -from 0 -to 0 intr_req
  create_bd_pin -dir I -type rst mb_debug_sys_rst
  create_bd_pin -dir O -from 0 -to 0 -type rst peripheral_aresetn
  create_bd_pin -dir I -from 0 -to 0 -type rst s_axi_aresetn
  create_bd_pin -dir O -from 7 -to 0 tri_o

  # Create instance: dff_en_reset_vector_0, and set properties
  set dff_en_reset_vector_0 [ create_bd_cell -type ip -vlnv xilinx.com:user:dff_en_reset_vector:1.0 dff_en_reset_vector_0 ]
  set_property -dict [ list \
   CONFIG.SIZE {1} \
 ] $dff_en_reset_vector_0

  # Create instance: gpio, and set properties
  set gpio [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 gpio ]
  set_property -dict [ list \
   CONFIG.C_ALL_OUTPUTS_2 {0} \
   CONFIG.C_GPIO2_WIDTH {32} \
   CONFIG.C_GPIO_WIDTH {8} \
   CONFIG.C_IS_DUAL {0} \
 ] $gpio

  # Create instance: iic, and set properties
  set iic [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_iic:2.1 iic ]

  # Create instance: intc, and set properties
  set intc [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_intc:4.1 intc ]

  # Create instance: intr, and set properties
  set intr [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 intr ]
  set_property -dict [ list \
   CONFIG.C_ALL_OUTPUTS {1} \
   CONFIG.C_GPIO_WIDTH {1} \
 ] $intr

  # Create instance: intr_concat, and set properties
  set intr_concat [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 intr_concat ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {3} \
 ] $intr_concat

  # Create instance: io_switch, and set properties
  set io_switch [ create_bd_cell -type ip -vlnv xilinx.com:user:io_switch:1.1 io_switch ]
  set_property -dict [ list \
   CONFIG.C_INTERFACE_TYPE {1} \
   CONFIG.C_IO_SWITCH_WIDTH {8} \
   CONFIG.C_NUM_PWMS {1} \
   CONFIG.C_NUM_TIMERS {1} \
   CONFIG.I2C0_Enable {true} \
   CONFIG.PWM_Enable {true} \
   CONFIG.SPI0_Enable {true} \
   CONFIG.Timer_Enable {true} \
 ] $io_switch

  # Create instance: lmb
  create_hier_cell_lmb_1 $hier_obj lmb

  # Create instance: logic_1, and set properties
  set logic_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 logic_1 ]

  # Create instance: mb, and set properties
  set mb [ create_bd_cell -type ip -vlnv xilinx.com:ip:microblaze:11.0 mb ]
  set_property -dict [ list \
   CONFIG.C_DEBUG_ENABLED {1} \
   CONFIG.C_D_AXI {1} \
   CONFIG.C_D_LMB {1} \
   CONFIG.C_I_LMB {1} \
 ] $mb

  # Create instance: mb_bram_ctrl, and set properties
  set mb_bram_ctrl [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.1 mb_bram_ctrl ]
  set_property -dict [ list \
   CONFIG.SINGLE_PORT_BRAM {1} \
 ] $mb_bram_ctrl

  # Create instance: microblaze_0_axi_periph, and set properties
  set microblaze_0_axi_periph [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 microblaze_0_axi_periph ]
  set_property -dict [ list \
   CONFIG.M00_HAS_REGSLICE {1} \
   CONFIG.M01_HAS_REGSLICE {1} \
   CONFIG.M02_HAS_REGSLICE {1} \
   CONFIG.M03_HAS_REGSLICE {1} \
   CONFIG.M04_HAS_REGSLICE {1} \
   CONFIG.M05_HAS_REGSLICE {1} \
   CONFIG.M06_HAS_REGSLICE {1} \
   CONFIG.M07_HAS_REGSLICE {1} \
   CONFIG.NUM_MI {8} \
   CONFIG.S00_HAS_REGSLICE {1} \
 ] $microblaze_0_axi_periph

  # Create instance: rst_clk_wiz_1_100M, and set properties
  set rst_clk_wiz_1_100M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_clk_wiz_1_100M ]
  set_property -dict [ list \
   CONFIG.C_AUX_RESET_HIGH {1} \
 ] $rst_clk_wiz_1_100M

  # Create instance: spi, and set properties
  set spi [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_quad_spi:3.2 spi ]
  set_property -dict [ list \
   CONFIG.C_USE_STARTUP {0} \
 ] $spi

  # Create instance: timer, and set properties
  set timer [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_timer:2.0 timer ]

  # Create interface connections
  connect_bd_intf_net -intf_net BRAM_PORTB_1 [get_bd_intf_pins lmb/BRAM_PORTB] [get_bd_intf_pins mb_bram_ctrl/BRAM_PORTA]
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins M_AXI] [get_bd_intf_pins microblaze_0_axi_periph/M07_AXI]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins S_AXI] [get_bd_intf_pins mb_bram_ctrl/S_AXI]
  connect_bd_intf_net -intf_net gpio_GPIO [get_bd_intf_pins gpio/GPIO] [get_bd_intf_pins io_switch/gpio]
  connect_bd_intf_net -intf_net iic_IIC [get_bd_intf_pins iic/IIC] [get_bd_intf_pins io_switch/iic0]
  connect_bd_intf_net -intf_net mb1_intc_interrupt [get_bd_intf_pins intc/interrupt] [get_bd_intf_pins mb/INTERRUPT]
  connect_bd_intf_net -intf_net microblaze_0_M_AXI_DP [get_bd_intf_pins mb/M_AXI_DP] [get_bd_intf_pins microblaze_0_axi_periph/S00_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M00_AXI [get_bd_intf_pins microblaze_0_axi_periph/M00_AXI] [get_bd_intf_pins spi/AXI_LITE]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M01_AXI [get_bd_intf_pins iic/S_AXI] [get_bd_intf_pins microblaze_0_axi_periph/M01_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M02_AXI [get_bd_intf_pins io_switch/S_AXI] [get_bd_intf_pins microblaze_0_axi_periph/M02_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M03_AXI [get_bd_intf_pins gpio/S_AXI] [get_bd_intf_pins microblaze_0_axi_periph/M03_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M04_AXI [get_bd_intf_pins microblaze_0_axi_periph/M04_AXI] [get_bd_intf_pins timer/S_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M05_AXI [get_bd_intf_pins intc/s_axi] [get_bd_intf_pins microblaze_0_axi_periph/M05_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M06_AXI [get_bd_intf_pins intr/S_AXI] [get_bd_intf_pins microblaze_0_axi_periph/M06_AXI]
  connect_bd_intf_net -intf_net microblaze_0_debug [get_bd_intf_pins DEBUG] [get_bd_intf_pins mb/DEBUG]
  connect_bd_intf_net -intf_net microblaze_0_dlmb_1 [get_bd_intf_pins lmb/DLMB] [get_bd_intf_pins mb/DLMB]
  connect_bd_intf_net -intf_net microblaze_0_ilmb_1 [get_bd_intf_pins lmb/ILMB] [get_bd_intf_pins mb/ILMB]
  connect_bd_intf_net -intf_net spi_SPI_0 [get_bd_intf_pins io_switch/spi0] [get_bd_intf_pins spi/SPI_0]

  # Create port connections
  connect_bd_net -net dff_en_reset_vector_0_q [get_bd_pins intr_req] [get_bd_pins dff_en_reset_vector_0/q]
  connect_bd_net -net io_data_i_0_1 [get_bd_pins data_i] [get_bd_pins io_switch/io_data_i]
  connect_bd_net -net io_switch_0_timer_i [get_bd_pins io_switch/timer_i] [get_bd_pins timer/capturetrig0]
  connect_bd_net -net io_switch_io_data_o [get_bd_pins data_o] [get_bd_pins io_switch/io_data_o]
  connect_bd_net -net io_switch_io_tri_o [get_bd_pins tri_o] [get_bd_pins io_switch/io_tri_o]
  connect_bd_net -net iop_pmoda_intr_ack_1 [get_bd_pins intr_ack] [get_bd_pins dff_en_reset_vector_0/reset]
  connect_bd_net -net iop_pmoda_intr_gpio_io_o [get_bd_pins dff_en_reset_vector_0/en] [get_bd_pins intr/gpio_io_o]
  connect_bd_net -net logic_1_dout1 [get_bd_pins dff_en_reset_vector_0/d] [get_bd_pins logic_1/dout] [get_bd_pins rst_clk_wiz_1_100M/ext_reset_in]
  connect_bd_net -net mb1_iic_iic2intc_irpt [get_bd_pins iic/iic2intc_irpt] [get_bd_pins intr_concat/In0]
  connect_bd_net -net mb1_interrupt_concat_dout [get_bd_pins intc/intr] [get_bd_pins intr_concat/dout]
  connect_bd_net -net mb1_spi_ip2intc_irpt [get_bd_pins intr_concat/In1] [get_bd_pins spi/ip2intc_irpt]
  connect_bd_net -net mb1_timer_generateout0 [get_bd_pins io_switch/timer_o] [get_bd_pins timer/generateout0]
  connect_bd_net -net mb1_timer_interrupt [get_bd_pins intr_concat/In2] [get_bd_pins timer/interrupt]
  connect_bd_net -net mb1_timer_pwm0 [get_bd_pins io_switch/pwm_o] [get_bd_pins timer/pwm0]
  connect_bd_net -net mb_1_reset_Dout [get_bd_pins aux_reset_in] [get_bd_pins rst_clk_wiz_1_100M/aux_reset_in]
  connect_bd_net -net mdm_1_debug_sys_rst [get_bd_pins mb_debug_sys_rst] [get_bd_pins rst_clk_wiz_1_100M/mb_debug_sys_rst]
  connect_bd_net -net ps7_0_FCLK_CLK0 [get_bd_pins clk_100M] [get_bd_pins dff_en_reset_vector_0/clk] [get_bd_pins gpio/s_axi_aclk] [get_bd_pins iic/s_axi_aclk] [get_bd_pins intc/s_axi_aclk] [get_bd_pins intr/s_axi_aclk] [get_bd_pins io_switch/s_axi_aclk] [get_bd_pins lmb/LMB_Clk] [get_bd_pins mb/Clk] [get_bd_pins mb_bram_ctrl/s_axi_aclk] [get_bd_pins microblaze_0_axi_periph/ACLK] [get_bd_pins microblaze_0_axi_periph/M00_ACLK] [get_bd_pins microblaze_0_axi_periph/M01_ACLK] [get_bd_pins microblaze_0_axi_periph/M02_ACLK] [get_bd_pins microblaze_0_axi_periph/M03_ACLK] [get_bd_pins microblaze_0_axi_periph/M04_ACLK] [get_bd_pins microblaze_0_axi_periph/M05_ACLK] [get_bd_pins microblaze_0_axi_periph/M06_ACLK] [get_bd_pins microblaze_0_axi_periph/M07_ACLK] [get_bd_pins microblaze_0_axi_periph/S00_ACLK] [get_bd_pins rst_clk_wiz_1_100M/slowest_sync_clk] [get_bd_pins spi/ext_spi_clk] [get_bd_pins spi/s_axi_aclk] [get_bd_pins timer/s_axi_aclk]
  connect_bd_net -net rst_clk_wiz_1_100M_bus_struct_reset [get_bd_pins lmb/SYS_Rst] [get_bd_pins rst_clk_wiz_1_100M/bus_struct_reset]
  connect_bd_net -net rst_clk_wiz_1_100M_interconnect_aresetn [get_bd_pins microblaze_0_axi_periph/ARESETN] [get_bd_pins rst_clk_wiz_1_100M/interconnect_aresetn]
  connect_bd_net -net rst_clk_wiz_1_100M_mb_reset [get_bd_pins mb/Reset] [get_bd_pins rst_clk_wiz_1_100M/mb_reset]
  connect_bd_net -net rst_clk_wiz_1_100M_peripheral_aresetn [get_bd_pins peripheral_aresetn] [get_bd_pins gpio/s_axi_aresetn] [get_bd_pins iic/s_axi_aresetn] [get_bd_pins intc/s_axi_aresetn] [get_bd_pins microblaze_0_axi_periph/M00_ARESETN] [get_bd_pins microblaze_0_axi_periph/M01_ARESETN] [get_bd_pins microblaze_0_axi_periph/M02_ARESETN] [get_bd_pins microblaze_0_axi_periph/M03_ARESETN] [get_bd_pins microblaze_0_axi_periph/M04_ARESETN] [get_bd_pins microblaze_0_axi_periph/M05_ARESETN] [get_bd_pins microblaze_0_axi_periph/M06_ARESETN] [get_bd_pins microblaze_0_axi_periph/M07_ARESETN] [get_bd_pins microblaze_0_axi_periph/S00_ARESETN] [get_bd_pins rst_clk_wiz_1_100M/peripheral_aresetn] [get_bd_pins spi/s_axi_aresetn] [get_bd_pins timer/s_axi_aresetn]
  connect_bd_net -net s_axi_aresetn_1 [get_bd_pins s_axi_aresetn] [get_bd_pins intr/s_axi_aresetn] [get_bd_pins io_switch/s_axi_aresetn] [get_bd_pins mb_bram_ctrl/s_axi_aresetn]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: iop_grove
proc create_hier_cell_iop_grove { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_iop_grove() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:mbdebug_rtl:3.0 DEBUG

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI


  # Create pins
  create_bd_pin -dir I -from 0 -to 0 -type rst aux_reset_in
  create_bd_pin -dir I -type clk clk_100M
  create_bd_pin -dir I -from 3 -to 0 data_i
  create_bd_pin -dir O -from 3 -to 0 data_o
  create_bd_pin -dir I -from 0 -to 0 intr_ack
  create_bd_pin -dir O -from 0 -to 0 intr_req
  create_bd_pin -dir I -type rst mb_debug_sys_rst
  create_bd_pin -dir O -from 0 -to 0 -type rst peripheral_aresetn
  create_bd_pin -dir I -from 0 -to 0 -type rst s_axi_aresetn
  create_bd_pin -dir O -from 3 -to 0 tri_o

  # Create instance: capture_0, and set properties
  set capture_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 capture_0 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {0} \
   CONFIG.DIN_TO {0} \
   CONFIG.DIN_WIDTH {2} \
 ] $capture_0

  # Create instance: capture_1, and set properties
  set capture_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 capture_1 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {1} \
   CONFIG.DIN_TO {1} \
   CONFIG.DIN_WIDTH {2} \
   CONFIG.DOUT_WIDTH {1} \
 ] $capture_1

  # Create instance: concat_pwm, and set properties
  set concat_pwm [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 concat_pwm ]

  # Create instance: concat_tmr_o, and set properties
  set concat_tmr_o [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 concat_tmr_o ]

  # Create instance: dff_en_reset_vector_0, and set properties
  set dff_en_reset_vector_0 [ create_bd_cell -type ip -vlnv xilinx.com:user:dff_en_reset_vector:1.0 dff_en_reset_vector_0 ]
  set_property -dict [ list \
   CONFIG.SIZE {1} \
 ] $dff_en_reset_vector_0

  # Create instance: gpio, and set properties
  set gpio [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 gpio ]
  set_property -dict [ list \
   CONFIG.C_ALL_OUTPUTS_2 {0} \
   CONFIG.C_GPIO2_WIDTH {32} \
   CONFIG.C_GPIO_WIDTH {4} \
   CONFIG.C_IS_DUAL {0} \
   CONFIG.C_TRI_DEFAULT {0xFFFFFF00} \
 ] $gpio

  # Create instance: iic0, and set properties
  set iic0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_iic:2.1 iic0 ]

  # Create instance: iic1, and set properties
  set iic1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_iic:2.1 iic1 ]

  # Create instance: intc, and set properties
  set intc [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_intc:4.1 intc ]

  # Create instance: intr, and set properties
  set intr [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 intr ]
  set_property -dict [ list \
   CONFIG.C_ALL_OUTPUTS {1} \
   CONFIG.C_GPIO_WIDTH {1} \
 ] $intr

  # Create instance: intr_concat, and set properties
  set intr_concat [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 intr_concat ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {2} \
 ] $intr_concat

  # Create instance: io_switch, and set properties
  set io_switch [ create_bd_cell -type ip -vlnv xilinx.com:user:io_switch:1.1 io_switch ]
  set_property -dict [ list \
   CONFIG.C_INTERFACE_TYPE {0} \
   CONFIG.C_IO_SWITCH_WIDTH {4} \
   CONFIG.C_NUM_PWMS {2} \
   CONFIG.C_NUM_TIMERS {2} \
   CONFIG.I2C0_Enable {true} \
   CONFIG.I2C1_Enable {true} \
   CONFIG.PWM_Enable {true} \
   CONFIG.SPI0_Enable {false} \
   CONFIG.Timer_Enable {true} \
 ] $io_switch

  # Create instance: lmb
  create_hier_cell_lmb $hier_obj lmb

  # Create instance: logic_1, and set properties
  set logic_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 logic_1 ]

  # Create instance: mb, and set properties
  set mb [ create_bd_cell -type ip -vlnv xilinx.com:ip:microblaze:11.0 mb ]
  set_property -dict [ list \
   CONFIG.C_DEBUG_ENABLED {1} \
   CONFIG.C_D_AXI {1} \
   CONFIG.C_D_LMB {1} \
   CONFIG.C_I_LMB {1} \
 ] $mb

  # Create instance: mb_bram_ctrl, and set properties
  set mb_bram_ctrl [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.1 mb_bram_ctrl ]
  set_property -dict [ list \
   CONFIG.SINGLE_PORT_BRAM {1} \
 ] $mb_bram_ctrl

  # Create instance: microblaze_0_axi_periph, and set properties
  set microblaze_0_axi_periph [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 microblaze_0_axi_periph ]
  set_property -dict [ list \
   CONFIG.M00_HAS_REGSLICE {1} \
   CONFIG.M01_HAS_REGSLICE {1} \
   CONFIG.M02_HAS_REGSLICE {1} \
   CONFIG.M03_HAS_REGSLICE {1} \
   CONFIG.M04_HAS_REGSLICE {1} \
   CONFIG.M05_HAS_REGSLICE {1} \
   CONFIG.M06_HAS_REGSLICE {1} \
   CONFIG.M07_HAS_REGSLICE {1} \
   CONFIG.NUM_MI {9} \
   CONFIG.S00_HAS_REGSLICE {1} \
 ] $microblaze_0_axi_periph

  # Create instance: rst_clk_wiz_1_100M, and set properties
  set rst_clk_wiz_1_100M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_clk_wiz_1_100M ]
  set_property -dict [ list \
   CONFIG.C_AUX_RESET_HIGH {1} \
 ] $rst_clk_wiz_1_100M

  # Create instance: timer0, and set properties
  set timer0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_timer:2.0 timer0 ]

  # Create instance: timer1, and set properties
  set timer1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_timer:2.0 timer1 ]

  # Create interface connections
  connect_bd_intf_net -intf_net BRAM_PORTB_1 [get_bd_intf_pins lmb/BRAM_PORTB] [get_bd_intf_pins mb_bram_ctrl/BRAM_PORTA]
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins M_AXI] [get_bd_intf_pins microblaze_0_axi_periph/M07_AXI]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins S_AXI] [get_bd_intf_pins mb_bram_ctrl/S_AXI]
  connect_bd_intf_net -intf_net gpio_GPIO [get_bd_intf_pins gpio/GPIO] [get_bd_intf_pins io_switch/gpio]
  connect_bd_intf_net -intf_net iic1_IIC [get_bd_intf_pins iic1/IIC] [get_bd_intf_pins io_switch/iic1]
  connect_bd_intf_net -intf_net iic_IIC [get_bd_intf_pins iic0/IIC] [get_bd_intf_pins io_switch/iic0]
  connect_bd_intf_net -intf_net mb1_intc_interrupt [get_bd_intf_pins intc/interrupt] [get_bd_intf_pins mb/INTERRUPT]
  connect_bd_intf_net -intf_net microblaze_0_M_AXI_DP [get_bd_intf_pins mb/M_AXI_DP] [get_bd_intf_pins microblaze_0_axi_periph/S00_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M00_AXI [get_bd_intf_pins iic1/S_AXI] [get_bd_intf_pins microblaze_0_axi_periph/M00_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M01_AXI [get_bd_intf_pins iic0/S_AXI] [get_bd_intf_pins microblaze_0_axi_periph/M01_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M02_AXI [get_bd_intf_pins io_switch/S_AXI] [get_bd_intf_pins microblaze_0_axi_periph/M02_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M03_AXI [get_bd_intf_pins gpio/S_AXI] [get_bd_intf_pins microblaze_0_axi_periph/M03_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M04_AXI [get_bd_intf_pins microblaze_0_axi_periph/M04_AXI] [get_bd_intf_pins timer0/S_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M05_AXI [get_bd_intf_pins intc/s_axi] [get_bd_intf_pins microblaze_0_axi_periph/M05_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M06_AXI [get_bd_intf_pins intr/S_AXI] [get_bd_intf_pins microblaze_0_axi_periph/M06_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M08_AXI [get_bd_intf_pins microblaze_0_axi_periph/M08_AXI] [get_bd_intf_pins timer1/S_AXI]
  connect_bd_intf_net -intf_net microblaze_0_debug [get_bd_intf_pins DEBUG] [get_bd_intf_pins mb/DEBUG]
  connect_bd_intf_net -intf_net microblaze_0_dlmb_1 [get_bd_intf_pins lmb/DLMB] [get_bd_intf_pins mb/DLMB]
  connect_bd_intf_net -intf_net microblaze_0_ilmb_1 [get_bd_intf_pins lmb/ILMB] [get_bd_intf_pins mb/ILMB]

  # Create port connections
  connect_bd_net -net capture_1_Dout [get_bd_pins capture_1/Dout] [get_bd_pins timer1/capturetrig0]
  connect_bd_net -net concat_pwm_dout [get_bd_pins concat_pwm/dout] [get_bd_pins io_switch/pwm_o]
  connect_bd_net -net concat_tmr_o_dout [get_bd_pins concat_tmr_o/dout] [get_bd_pins io_switch/timer_o]
  connect_bd_net -net dff_en_reset_vector_0_q [get_bd_pins intr_req] [get_bd_pins dff_en_reset_vector_0/q]
  connect_bd_net -net iic1_iic2intc_irpt [get_bd_pins iic1/iic2intc_irpt] [get_bd_pins intr_concat/In1]
  connect_bd_net -net io_data_i_0_1 [get_bd_pins data_i] [get_bd_pins io_switch/io_data_i]
  connect_bd_net -net io_switch_io_data_o [get_bd_pins data_o] [get_bd_pins io_switch/io_data_o]
  connect_bd_net -net io_switch_io_tri_o [get_bd_pins tri_o] [get_bd_pins io_switch/io_tri_o]
  connect_bd_net -net io_switch_timer_i [get_bd_pins capture_0/Din] [get_bd_pins capture_1/Din] [get_bd_pins io_switch/timer_i]
  connect_bd_net -net iop_pmoda_intr_ack_1 [get_bd_pins intr_ack] [get_bd_pins dff_en_reset_vector_0/reset]
  connect_bd_net -net iop_pmoda_intr_gpio_io_o [get_bd_pins dff_en_reset_vector_0/en] [get_bd_pins intr/gpio_io_o]
  connect_bd_net -net logic_1_dout1 [get_bd_pins dff_en_reset_vector_0/d] [get_bd_pins logic_1/dout] [get_bd_pins rst_clk_wiz_1_100M/ext_reset_in]
  connect_bd_net -net mb1_iic_iic2intc_irpt [get_bd_pins iic0/iic2intc_irpt] [get_bd_pins intr_concat/In0]
  connect_bd_net -net mb1_interrupt_concat_dout [get_bd_pins intc/intr] [get_bd_pins intr_concat/dout]
  connect_bd_net -net mb_1_reset_Dout [get_bd_pins aux_reset_in] [get_bd_pins rst_clk_wiz_1_100M/aux_reset_in]
  connect_bd_net -net mdm_1_debug_sys_rst [get_bd_pins mb_debug_sys_rst] [get_bd_pins rst_clk_wiz_1_100M/mb_debug_sys_rst]
  connect_bd_net -net ps7_0_FCLK_CLK0 [get_bd_pins clk_100M] [get_bd_pins dff_en_reset_vector_0/clk] [get_bd_pins gpio/s_axi_aclk] [get_bd_pins iic0/s_axi_aclk] [get_bd_pins iic1/s_axi_aclk] [get_bd_pins intc/s_axi_aclk] [get_bd_pins intr/s_axi_aclk] [get_bd_pins io_switch/s_axi_aclk] [get_bd_pins lmb/LMB_Clk] [get_bd_pins mb/Clk] [get_bd_pins mb_bram_ctrl/s_axi_aclk] [get_bd_pins microblaze_0_axi_periph/ACLK] [get_bd_pins microblaze_0_axi_periph/M00_ACLK] [get_bd_pins microblaze_0_axi_periph/M01_ACLK] [get_bd_pins microblaze_0_axi_periph/M02_ACLK] [get_bd_pins microblaze_0_axi_periph/M03_ACLK] [get_bd_pins microblaze_0_axi_periph/M04_ACLK] [get_bd_pins microblaze_0_axi_periph/M05_ACLK] [get_bd_pins microblaze_0_axi_periph/M06_ACLK] [get_bd_pins microblaze_0_axi_periph/M07_ACLK] [get_bd_pins microblaze_0_axi_periph/M08_ACLK] [get_bd_pins microblaze_0_axi_periph/S00_ACLK] [get_bd_pins rst_clk_wiz_1_100M/slowest_sync_clk] [get_bd_pins timer0/s_axi_aclk] [get_bd_pins timer1/s_axi_aclk]
  connect_bd_net -net rst_clk_wiz_1_100M_bus_struct_reset [get_bd_pins lmb/SYS_Rst] [get_bd_pins rst_clk_wiz_1_100M/bus_struct_reset]
  connect_bd_net -net rst_clk_wiz_1_100M_interconnect_aresetn [get_bd_pins microblaze_0_axi_periph/ARESETN] [get_bd_pins rst_clk_wiz_1_100M/interconnect_aresetn]
  connect_bd_net -net rst_clk_wiz_1_100M_mb_reset [get_bd_pins mb/Reset] [get_bd_pins rst_clk_wiz_1_100M/mb_reset]
  connect_bd_net -net rst_clk_wiz_1_100M_peripheral_aresetn [get_bd_pins peripheral_aresetn] [get_bd_pins gpio/s_axi_aresetn] [get_bd_pins iic0/s_axi_aresetn] [get_bd_pins iic1/s_axi_aresetn] [get_bd_pins intc/s_axi_aresetn] [get_bd_pins microblaze_0_axi_periph/M00_ARESETN] [get_bd_pins microblaze_0_axi_periph/M01_ARESETN] [get_bd_pins microblaze_0_axi_periph/M02_ARESETN] [get_bd_pins microblaze_0_axi_periph/M03_ARESETN] [get_bd_pins microblaze_0_axi_periph/M04_ARESETN] [get_bd_pins microblaze_0_axi_periph/M05_ARESETN] [get_bd_pins microblaze_0_axi_periph/M06_ARESETN] [get_bd_pins microblaze_0_axi_periph/M07_ARESETN] [get_bd_pins microblaze_0_axi_periph/M08_ARESETN] [get_bd_pins microblaze_0_axi_periph/S00_ARESETN] [get_bd_pins rst_clk_wiz_1_100M/peripheral_aresetn] [get_bd_pins timer0/s_axi_aresetn] [get_bd_pins timer1/s_axi_aresetn]
  connect_bd_net -net s_axi_aresetn_1 [get_bd_pins s_axi_aresetn] [get_bd_pins intr/s_axi_aresetn] [get_bd_pins io_switch/s_axi_aresetn] [get_bd_pins mb_bram_ctrl/s_axi_aresetn]
  connect_bd_net -net timer0_generateout0 [get_bd_pins concat_tmr_o/In0] [get_bd_pins timer0/generateout0]
  connect_bd_net -net timer0_pwm0 [get_bd_pins concat_pwm/In0] [get_bd_pins timer0/pwm0]
  connect_bd_net -net timer1_generateout0 [get_bd_pins concat_tmr_o/In1] [get_bd_pins timer1/generateout0]
  connect_bd_net -net timer1_pwm0 [get_bd_pins concat_pwm/In1] [get_bd_pins timer1/pwm0]
  connect_bd_net -net xlslice_0_Dout [get_bd_pins capture_0/Dout] [get_bd_pins timer0/capturetrig0]

  # Restore current instance
  current_bd_instance $oldCurInst
}


# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set HDMI_CTL_iic [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 HDMI_CTL_iic ]

  set RX_DDC_OUT [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 RX_DDC_OUT ]

  set TX_DDC_OUT [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 TX_DDC_OUT ]

  set Vaux14 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 Vaux14 ]

  set Vaux15 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 Vaux15 ]

  set Vp_Vn [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 Vp_Vn ]

  set cam_gpio [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 cam_gpio ]

  set dip_switch_4bits [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 dip_switch_4bits ]

  set led_4bits [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 led_4bits ]

  set mipi_phy_if_0 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:mipi_phy_rtl:1.0 mipi_phy_if_0 ]

  set push_button_4bits [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 push_button_4bits ]

  set rgbleds [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 rgbleds ]


  # Create ports
  set HDMI_RX_CLK_N_IN [ create_bd_port -dir I HDMI_RX_CLK_N_IN ]
  set HDMI_RX_CLK_P_IN [ create_bd_port -dir I HDMI_RX_CLK_P_IN ]
  set HDMI_RX_DAT_N_IN [ create_bd_port -dir I -from 2 -to 0 HDMI_RX_DAT_N_IN ]
  set HDMI_RX_DAT_P_IN [ create_bd_port -dir I -from 2 -to 0 HDMI_RX_DAT_P_IN ]
  set HDMI_SI5324_LOL_IN [ create_bd_port -dir I HDMI_SI5324_LOL_IN ]
  set HDMI_SI5324_RST_OUT [ create_bd_port -dir O -from 0 -to 0 HDMI_SI5324_RST_OUT ]
  set HDMI_TX_CLK_N_OUT [ create_bd_port -dir O HDMI_TX_CLK_N_OUT ]
  set HDMI_TX_CLK_P_OUT [ create_bd_port -dir O HDMI_TX_CLK_P_OUT ]
  set HDMI_TX_DAT_N_OUT [ create_bd_port -dir O -from 2 -to 0 HDMI_TX_DAT_N_OUT ]
  set HDMI_TX_DAT_P_OUT [ create_bd_port -dir O -from 2 -to 0 HDMI_TX_DAT_P_OUT ]
  set HDMI_TX_LS_OE [ create_bd_port -dir O -from 0 -to 0 HDMI_TX_LS_OE ]
  set RX_DET_IN [ create_bd_port -dir I RX_DET_IN ]
  set RX_HPD_OUT [ create_bd_port -dir O RX_HPD_OUT ]
  set RX_REFCLK_N_OUT [ create_bd_port -dir O RX_REFCLK_N_OUT ]
  set RX_REFCLK_P_OUT [ create_bd_port -dir O RX_REFCLK_P_OUT ]
  set TX_EN_OUT [ create_bd_port -dir O -from 0 -to 0 TX_EN_OUT ]
  set TX_HPD_IN [ create_bd_port -dir I TX_HPD_IN ]
  set TX_REFCLK_N_IN [ create_bd_port -dir I TX_REFCLK_N_IN ]
  set TX_REFCLK_P_IN [ create_bd_port -dir I TX_REFCLK_P_IN ]
  set audio_codec_bclk [ create_bd_port -dir O audio_codec_bclk ]
  set audio_codec_clk_10MHz [ create_bd_port -dir O -type clk audio_codec_clk_10MHz ]
  set audio_codec_lrclk [ create_bd_port -dir O audio_codec_lrclk ]
  set audio_codec_sdata_i [ create_bd_port -dir I audio_codec_sdata_i ]
  set audio_codec_sdata_o [ create_bd_port -dir O audio_codec_sdata_o ]
  set codec_addr [ create_bd_port -dir O -from 1 -to 0 codec_addr ]
  set pl_groves [ create_bd_port -dir IO -from 3 -to 0 pl_groves ]
  set pmod0 [ create_bd_port -dir IO -from 7 -to 0 pmod0 ]
  set pmod1 [ create_bd_port -dir IO -from 7 -to 0 pmod1 ]
  set rpi [ create_bd_port -dir IO -from 27 -to 0 rpi ]
  set syzygy_pg [ create_bd_port -dir I syzygy_pg ]

  # Create instance: HDMI_CTL_axi_iic, and set properties
  set HDMI_CTL_axi_iic [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_iic:2.1 HDMI_CTL_axi_iic ]
  set_property -dict [ list \
   CONFIG.C_SCL_INERTIAL_DELAY {10} \
   CONFIG.C_SDA_INERTIAL_DELAY {10} \
   CONFIG.IIC_BOARD_INTERFACE {Custom} \
   CONFIG.USE_BOARD_FLOW {true} \
 ] $HDMI_CTL_axi_iic

  # Create instance: address_remap_0, and set properties
  set address_remap_0 [ create_bd_cell -type ip -vlnv user.org:user:address_remap:1.0 address_remap_0 ]
  set_property -dict [ list \
   CONFIG.C_M_AXI_out_ADDR_WIDTH {31} \
   CONFIG.C_M_AXI_out_DATA_WIDTH {128} \
   CONFIG.C_S_AXI_in_ADDR_WIDTH {31} \
   CONFIG.C_S_AXI_in_DATA_WIDTH {128} \
 ] $address_remap_0

  # Create instance: audio_codec_ctrl_0, and set properties
  set audio_codec_ctrl_0 [ create_bd_cell -type ip -vlnv xilinx.com:user:audio_codec_ctrl:1.0 audio_codec_ctrl_0 ]

  # Create instance: axi_intc_0, and set properties
  set axi_intc_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_intc:4.1 axi_intc_0 ]
  set_property -dict [ list \
   CONFIG.C_IRQ_CONNECTION {1} \
 ] $axi_intc_0

  # Create instance: axi_interconnect, and set properties
  set axi_interconnect [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect ]
  set_property -dict [ list \
   CONFIG.NUM_MI {27} \
 ] $axi_interconnect

  # Create instance: axi_interconnect_0, and set properties
  set axi_interconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_0 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {1} \
   CONFIG.NUM_SI {4} \
 ] $axi_interconnect_0

  # Create instance: axi_interconnect_1, and set properties
  set axi_interconnect_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_1 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {4} \
 ] $axi_interconnect_1

  # Create instance: axi_mem_intercon, and set properties
  set axi_mem_intercon [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_mem_intercon ]
  set_property -dict [ list \
   CONFIG.NUM_MI {1} \
   CONFIG.NUM_SI {1} \
 ] $axi_mem_intercon

  # Create instance: axi_mem_intercon_1, and set properties
  set axi_mem_intercon_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_mem_intercon_1 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {1} \
   CONFIG.NUM_SI {1} \
 ] $axi_mem_intercon_1

  # Create instance: axi_register_slice_0, and set properties
  set axi_register_slice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_0 ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {31} \
 ] $axi_register_slice_0

  # Create instance: axi_smc, and set properties
  set axi_smc [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 axi_smc ]
  set_property -dict [ list \
   CONFIG.NUM_SI {3} \
 ] $axi_smc

  # Create instance: clk_wiz_0, and set properties
  set clk_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz_0 ]
  set_property -dict [ list \
   CONFIG.CLKOUT1_JITTER {102.086} \
   CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {200.000} \
   CONFIG.MMCM_CLKOUT0_DIVIDE_F {6.000} \
   CONFIG.PRIM_SOURCE {No_buffer} \
   CONFIG.USE_RESET {false} \
 ] $clk_wiz_0

  # Create instance: clk_wiz_10MHz, and set properties
  set clk_wiz_10MHz [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz_10MHz ]
  set_property -dict [ list \
   CONFIG.CLKOUT1_JITTER {460.700} \
   CONFIG.CLKOUT1_PHASE_ERROR {523.418} \
   CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {10.000} \
   CONFIG.MMCM_CLKFBOUT_MULT_F {92.375} \
   CONFIG.MMCM_CLKOUT0_DIVIDE_F {92.375} \
   CONFIG.MMCM_DIVCLK_DIVIDE {10} \
   CONFIG.RESET_PORT {resetn} \
   CONFIG.RESET_TYPE {ACTIVE_LOW} \
 ] $clk_wiz_10MHz

  # Create instance: concat_pmod0, and set properties
  set concat_pmod0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 concat_pmod0 ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {4} \
 ] $concat_pmod0

  # Create instance: concat_pmod1, and set properties
  set concat_pmod1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 concat_pmod1 ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {4} \
 ] $concat_pmod1

  # Create instance: concat_rp, and set properties
  set concat_rp [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 concat_rp ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {3} \
 ] $concat_rp

  # Create instance: constant_10bit_0, and set properties
  set constant_10bit_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 constant_10bit_0 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {10} \
 ] $constant_10bit_0

  # Create instance: constant_8bit_0, and set properties
  set constant_8bit_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 constant_8bit_0 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {8} \
 ] $constant_8bit_0

  # Create instance: gpio_btns, and set properties
  set gpio_btns [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 gpio_btns ]
  set_property -dict [ list \
   CONFIG.C_INTERRUPT_PRESENT {1} \
   CONFIG.GPIO_BOARD_INTERFACE {push_button_4bits} \
   CONFIG.USE_BOARD_FLOW {true} \
 ] $gpio_btns

  # Create instance: gpio_leds, and set properties
  set gpio_leds [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 gpio_leds ]
  set_property -dict [ list \
   CONFIG.C_INTERRUPT_PRESENT {0} \
   CONFIG.GPIO_BOARD_INTERFACE {led_4bits} \
   CONFIG.USE_BOARD_FLOW {true} \
 ] $gpio_leds

  # Create instance: gpio_sws, and set properties
  set gpio_sws [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 gpio_sws ]
  set_property -dict [ list \
   CONFIG.C_INTERRUPT_PRESENT {1} \
   CONFIG.GPIO_BOARD_INTERFACE {dip_switch_4bits} \
   CONFIG.USE_BOARD_FLOW {true} \
 ] $gpio_sws

  # Create instance: grove0_buf, and set properties
  set grove0_buf [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.2 grove0_buf ]
  set_property -dict [ list \
   CONFIG.C_BUF_TYPE {IOBUF} \
   CONFIG.C_SIZE {4} \
 ] $grove0_buf

  # Create instance: iop_grove
  create_hier_cell_iop_grove [current_bd_instance .] iop_grove

  # Create instance: iop_pmod0
  create_hier_cell_iop_pmod0 [current_bd_instance .] iop_pmod0

  # Create instance: iop_pmod1
  create_hier_cell_iop_pmod1 [current_bd_instance .] iop_pmod1

  # Create instance: iop_rpi
  create_hier_cell_iop_rpi [current_bd_instance .] iop_rpi

  # Create instance: logic_1, and set properties
  set logic_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 logic_1 ]

  # Create instance: mb_iop_grove_intr_ack, and set properties
  set mb_iop_grove_intr_ack [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 mb_iop_grove_intr_ack ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {7} \
   CONFIG.DIN_TO {7} \
   CONFIG.DIN_WIDTH {11} \
   CONFIG.DOUT_WIDTH {1} \
 ] $mb_iop_grove_intr_ack

  # Create instance: mb_iop_grove_reset, and set properties
  set mb_iop_grove_reset [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 mb_iop_grove_reset ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {6} \
   CONFIG.DIN_TO {6} \
   CONFIG.DIN_WIDTH {11} \
   CONFIG.DOUT_WIDTH {1} \
 ] $mb_iop_grove_reset

  # Create instance: mb_iop_pmod0_intr_ack, and set properties
  set mb_iop_pmod0_intr_ack [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 mb_iop_pmod0_intr_ack ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {1} \
   CONFIG.DIN_TO {1} \
   CONFIG.DIN_WIDTH {11} \
   CONFIG.DOUT_WIDTH {1} \
 ] $mb_iop_pmod0_intr_ack

  # Create instance: mb_iop_pmod0_reset, and set properties
  set mb_iop_pmod0_reset [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 mb_iop_pmod0_reset ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {0} \
   CONFIG.DIN_TO {0} \
   CONFIG.DIN_WIDTH {11} \
 ] $mb_iop_pmod0_reset

  # Create instance: mb_iop_pmod1_intr_ack, and set properties
  set mb_iop_pmod1_intr_ack [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 mb_iop_pmod1_intr_ack ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {3} \
   CONFIG.DIN_TO {3} \
   CONFIG.DIN_WIDTH {11} \
   CONFIG.DOUT_WIDTH {1} \
 ] $mb_iop_pmod1_intr_ack

  # Create instance: mb_iop_pmod1_reset, and set properties
  set mb_iop_pmod1_reset [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 mb_iop_pmod1_reset ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {2} \
   CONFIG.DIN_TO {2} \
   CONFIG.DIN_WIDTH {11} \
   CONFIG.DOUT_WIDTH {1} \
 ] $mb_iop_pmod1_reset

  # Create instance: mb_iop_rpi_intr_ack, and set properties
  set mb_iop_rpi_intr_ack [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 mb_iop_rpi_intr_ack ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {5} \
   CONFIG.DIN_TO {5} \
   CONFIG.DIN_WIDTH {11} \
   CONFIG.DOUT_WIDTH {1} \
 ] $mb_iop_rpi_intr_ack

  # Create instance: mb_iop_rpi_reset, and set properties
  set mb_iop_rpi_reset [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 mb_iop_rpi_reset ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {4} \
   CONFIG.DIN_TO {4} \
   CONFIG.DIN_WIDTH {11} \
 ] $mb_iop_rpi_reset

  # Create instance: mdm, and set properties
  set mdm [ create_bd_cell -type ip -vlnv xilinx.com:ip:mdm:3.2 mdm ]
  set_property -dict [ list \
   CONFIG.C_ADDR_SIZE {32} \
   CONFIG.C_MB_DBG_PORTS {5} \
   CONFIG.C_M_AXI_ADDR_WIDTH {32} \
 ] $mdm

  # Create instance: mipi
  create_hier_cell_mipi [current_bd_instance .] mipi

  # Create instance: pmod0_buf, and set properties
  set pmod0_buf [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.2 pmod0_buf ]
  set_property -dict [ list \
   CONFIG.C_BUF_TYPE {IOBUF} \
   CONFIG.C_SIZE {8} \
 ] $pmod0_buf

  # Create instance: pmod1_buf, and set properties
  set pmod1_buf [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.2 pmod1_buf ]
  set_property -dict [ list \
   CONFIG.C_BUF_TYPE {IOBUF} \
   CONFIG.C_SIZE {8} \
 ] $pmod1_buf

  # Create instance: proc_sys_reset_0, and set properties
  set proc_sys_reset_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_0 ]

  # Create instance: proc_sys_reset_1, and set properties
  set proc_sys_reset_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_1 ]

  # Create instance: proc_sys_reset_2, and set properties
  set proc_sys_reset_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_2 ]

  # Create instance: proc_sys_reset_3, and set properties
  set proc_sys_reset_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_3 ]

  # Create instance: ps_e_0, and set properties
  set ps_e_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:zynq_ultra_ps_e:3.5 ps_e_0 ]
  set_property -dict [ list \
   CONFIG.PSU_BANK_0_IO_STANDARD {LVCMOS18} \
   CONFIG.PSU_BANK_1_IO_STANDARD {LVCMOS33} \
   CONFIG.PSU_BANK_2_IO_STANDARD {LVCMOS18} \
   CONFIG.PSU_DDR_RAM_HIGHADDR {0xFFFFFFFF} \
   CONFIG.PSU_DDR_RAM_HIGHADDR_OFFSET {0x800000000} \
   CONFIG.PSU_DDR_RAM_LOWADDR_OFFSET {0x80000000} \
   CONFIG.PSU_DYNAMIC_DDR_CONFIG_EN {0} \
   CONFIG.PSU_MIO_0_DIRECTION {inout} \
   CONFIG.PSU_MIO_0_POLARITY {Default} \
   CONFIG.PSU_MIO_10_DIRECTION {inout} \
   CONFIG.PSU_MIO_10_POLARITY {Default} \
   CONFIG.PSU_MIO_11_DIRECTION {inout} \
   CONFIG.PSU_MIO_11_POLARITY {Default} \
   CONFIG.PSU_MIO_12_DIRECTION {inout} \
   CONFIG.PSU_MIO_12_POLARITY {Default} \
   CONFIG.PSU_MIO_13_DIRECTION {inout} \
   CONFIG.PSU_MIO_13_POLARITY {Default} \
   CONFIG.PSU_MIO_14_DIRECTION {inout} \
   CONFIG.PSU_MIO_14_POLARITY {Default} \
   CONFIG.PSU_MIO_15_DIRECTION {inout} \
   CONFIG.PSU_MIO_15_POLARITY {Default} \
   CONFIG.PSU_MIO_16_DIRECTION {inout} \
   CONFIG.PSU_MIO_16_POLARITY {Default} \
   CONFIG.PSU_MIO_17_DIRECTION {inout} \
   CONFIG.PSU_MIO_17_POLARITY {Default} \
   CONFIG.PSU_MIO_18_DIRECTION {inout} \
   CONFIG.PSU_MIO_18_POLARITY {Default} \
   CONFIG.PSU_MIO_19_DIRECTION {inout} \
   CONFIG.PSU_MIO_19_POLARITY {Default} \
   CONFIG.PSU_MIO_1_DIRECTION {inout} \
   CONFIG.PSU_MIO_1_POLARITY {Default} \
   CONFIG.PSU_MIO_20_DIRECTION {inout} \
   CONFIG.PSU_MIO_20_POLARITY {Default} \
   CONFIG.PSU_MIO_21_DIRECTION {inout} \
   CONFIG.PSU_MIO_21_POLARITY {Default} \
   CONFIG.PSU_MIO_22_DIRECTION {out} \
   CONFIG.PSU_MIO_22_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_22_POLARITY {Default} \
   CONFIG.PSU_MIO_23_DIRECTION {inout} \
   CONFIG.PSU_MIO_23_POLARITY {Default} \
   CONFIG.PSU_MIO_24_DIRECTION {in} \
   CONFIG.PSU_MIO_24_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_24_POLARITY {Default} \
   CONFIG.PSU_MIO_24_SLEW {fast} \
   CONFIG.PSU_MIO_25_POLARITY {Default} \
   CONFIG.PSU_MIO_26_DIRECTION {inout} \
   CONFIG.PSU_MIO_26_POLARITY {Default} \
   CONFIG.PSU_MIO_27_DIRECTION {out} \
   CONFIG.PSU_MIO_27_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_27_POLARITY {Default} \
   CONFIG.PSU_MIO_28_DIRECTION {in} \
   CONFIG.PSU_MIO_28_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_28_POLARITY {Default} \
   CONFIG.PSU_MIO_28_SLEW {fast} \
   CONFIG.PSU_MIO_29_DIRECTION {out} \
   CONFIG.PSU_MIO_29_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_29_POLARITY {Default} \
   CONFIG.PSU_MIO_2_DIRECTION {inout} \
   CONFIG.PSU_MIO_2_POLARITY {Default} \
   CONFIG.PSU_MIO_30_DIRECTION {in} \
   CONFIG.PSU_MIO_30_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_30_POLARITY {Default} \
   CONFIG.PSU_MIO_30_SLEW {fast} \
   CONFIG.PSU_MIO_31_DIRECTION {inout} \
   CONFIG.PSU_MIO_31_POLARITY {Default} \
   CONFIG.PSU_MIO_32_DIRECTION {inout} \
   CONFIG.PSU_MIO_32_POLARITY {Default} \
   CONFIG.PSU_MIO_33_DIRECTION {inout} \
   CONFIG.PSU_MIO_33_POLARITY {Default} \
   CONFIG.PSU_MIO_34_DIRECTION {in} \
   CONFIG.PSU_MIO_34_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_34_POLARITY {Default} \
   CONFIG.PSU_MIO_34_SLEW {fast} \
   CONFIG.PSU_MIO_35_DIRECTION {out} \
   CONFIG.PSU_MIO_35_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_35_POLARITY {Default} \
   CONFIG.PSU_MIO_36_DIRECTION {inout} \
   CONFIG.PSU_MIO_36_POLARITY {Default} \
   CONFIG.PSU_MIO_37_DIRECTION {inout} \
   CONFIG.PSU_MIO_37_POLARITY {Default} \
   CONFIG.PSU_MIO_38_DIRECTION {inout} \
   CONFIG.PSU_MIO_38_POLARITY {Default} \
   CONFIG.PSU_MIO_39_DIRECTION {inout} \
   CONFIG.PSU_MIO_39_POLARITY {Default} \
   CONFIG.PSU_MIO_3_DIRECTION {inout} \
   CONFIG.PSU_MIO_3_POLARITY {Default} \
   CONFIG.PSU_MIO_40_DIRECTION {inout} \
   CONFIG.PSU_MIO_40_POLARITY {Default} \
   CONFIG.PSU_MIO_41_DIRECTION {inout} \
   CONFIG.PSU_MIO_41_POLARITY {Default} \
   CONFIG.PSU_MIO_42_DIRECTION {inout} \
   CONFIG.PSU_MIO_42_POLARITY {Default} \
   CONFIG.PSU_MIO_43_DIRECTION {inout} \
   CONFIG.PSU_MIO_43_POLARITY {Default} \
   CONFIG.PSU_MIO_44_DIRECTION {inout} \
   CONFIG.PSU_MIO_44_POLARITY {Default} \
   CONFIG.PSU_MIO_45_DIRECTION {inout} \
   CONFIG.PSU_MIO_45_POLARITY {Default} \
   CONFIG.PSU_MIO_46_DIRECTION {inout} \
   CONFIG.PSU_MIO_46_POLARITY {Default} \
   CONFIG.PSU_MIO_47_DIRECTION {inout} \
   CONFIG.PSU_MIO_47_POLARITY {Default} \
   CONFIG.PSU_MIO_48_DIRECTION {inout} \
   CONFIG.PSU_MIO_48_POLARITY {Default} \
   CONFIG.PSU_MIO_49_DIRECTION {inout} \
   CONFIG.PSU_MIO_49_POLARITY {Default} \
   CONFIG.PSU_MIO_4_DIRECTION {inout} \
   CONFIG.PSU_MIO_4_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_4_POLARITY {Default} \
   CONFIG.PSU_MIO_50_DIRECTION {inout} \
   CONFIG.PSU_MIO_50_POLARITY {Default} \
   CONFIG.PSU_MIO_51_DIRECTION {out} \
   CONFIG.PSU_MIO_51_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_51_POLARITY {Default} \
   CONFIG.PSU_MIO_52_DIRECTION {in} \
   CONFIG.PSU_MIO_52_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_52_POLARITY {Default} \
   CONFIG.PSU_MIO_52_SLEW {fast} \
   CONFIG.PSU_MIO_53_DIRECTION {in} \
   CONFIG.PSU_MIO_53_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_53_POLARITY {Default} \
   CONFIG.PSU_MIO_53_SLEW {fast} \
   CONFIG.PSU_MIO_54_DIRECTION {inout} \
   CONFIG.PSU_MIO_54_POLARITY {Default} \
   CONFIG.PSU_MIO_55_DIRECTION {in} \
   CONFIG.PSU_MIO_55_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_55_POLARITY {Default} \
   CONFIG.PSU_MIO_55_SLEW {fast} \
   CONFIG.PSU_MIO_56_DIRECTION {inout} \
   CONFIG.PSU_MIO_56_POLARITY {Default} \
   CONFIG.PSU_MIO_57_DIRECTION {inout} \
   CONFIG.PSU_MIO_57_POLARITY {Default} \
   CONFIG.PSU_MIO_58_DIRECTION {out} \
   CONFIG.PSU_MIO_58_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_58_POLARITY {Default} \
   CONFIG.PSU_MIO_59_DIRECTION {inout} \
   CONFIG.PSU_MIO_59_POLARITY {Default} \
   CONFIG.PSU_MIO_5_DIRECTION {inout} \
   CONFIG.PSU_MIO_5_POLARITY {Default} \
   CONFIG.PSU_MIO_60_DIRECTION {inout} \
   CONFIG.PSU_MIO_60_POLARITY {Default} \
   CONFIG.PSU_MIO_61_DIRECTION {inout} \
   CONFIG.PSU_MIO_61_POLARITY {Default} \
   CONFIG.PSU_MIO_62_DIRECTION {inout} \
   CONFIG.PSU_MIO_62_POLARITY {Default} \
   CONFIG.PSU_MIO_63_DIRECTION {inout} \
   CONFIG.PSU_MIO_63_POLARITY {Default} \
   CONFIG.PSU_MIO_64_DIRECTION {in} \
   CONFIG.PSU_MIO_64_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_64_POLARITY {Default} \
   CONFIG.PSU_MIO_64_SLEW {fast} \
   CONFIG.PSU_MIO_65_DIRECTION {in} \
   CONFIG.PSU_MIO_65_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_65_POLARITY {Default} \
   CONFIG.PSU_MIO_65_SLEW {fast} \
   CONFIG.PSU_MIO_66_DIRECTION {inout} \
   CONFIG.PSU_MIO_66_POLARITY {Default} \
   CONFIG.PSU_MIO_67_DIRECTION {in} \
   CONFIG.PSU_MIO_67_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_67_POLARITY {Default} \
   CONFIG.PSU_MIO_67_SLEW {fast} \
   CONFIG.PSU_MIO_68_DIRECTION {inout} \
   CONFIG.PSU_MIO_68_POLARITY {Default} \
   CONFIG.PSU_MIO_69_DIRECTION {inout} \
   CONFIG.PSU_MIO_69_POLARITY {Default} \
   CONFIG.PSU_MIO_6_DIRECTION {inout} \
   CONFIG.PSU_MIO_6_POLARITY {Default} \
   CONFIG.PSU_MIO_70_DIRECTION {out} \
   CONFIG.PSU_MIO_70_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_70_POLARITY {Default} \
   CONFIG.PSU_MIO_71_DIRECTION {inout} \
   CONFIG.PSU_MIO_71_POLARITY {Default} \
   CONFIG.PSU_MIO_72_DIRECTION {inout} \
   CONFIG.PSU_MIO_72_POLARITY {Default} \
   CONFIG.PSU_MIO_73_DIRECTION {inout} \
   CONFIG.PSU_MIO_73_POLARITY {Default} \
   CONFIG.PSU_MIO_74_DIRECTION {inout} \
   CONFIG.PSU_MIO_74_POLARITY {Default} \
   CONFIG.PSU_MIO_75_DIRECTION {inout} \
   CONFIG.PSU_MIO_75_POLARITY {Default} \
   CONFIG.PSU_MIO_76_DIRECTION {inout} \
   CONFIG.PSU_MIO_76_POLARITY {Default} \
   CONFIG.PSU_MIO_77_DIRECTION {inout} \
   CONFIG.PSU_MIO_77_POLARITY {Default} \
   CONFIG.PSU_MIO_7_DIRECTION {inout} \
   CONFIG.PSU_MIO_7_POLARITY {Default} \
   CONFIG.PSU_MIO_8_DIRECTION {out} \
   CONFIG.PSU_MIO_8_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_8_POLARITY {Default} \
   CONFIG.PSU_MIO_9_DIRECTION {in} \
   CONFIG.PSU_MIO_9_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_9_POLARITY {Default} \
   CONFIG.PSU_MIO_9_SLEW {fast} \
   CONFIG.PSU_MIO_TREE_PERIPHERALS {I2C 1#I2C 1#GPIO0 MIO#GPIO0 MIO#GPIO0 MIO#GPIO0 MIO#GPIO0 MIO#GPIO0 MIO#UART 1#UART 1#GPIO0 MIO#GPIO0 MIO#GPIO0 MIO#SD 0#SD 0#SD 0#SD 0#GPIO0 MIO#I2C 0#I2C 0#GPIO0 MIO#SD 0#SD 0#GPIO0 MIO#SD 0#USB0 Reset#GPIO1 MIO#DPAUX#DPAUX#DPAUX#DPAUX#GPIO1 MIO#GPIO1 MIO#GPIO1 MIO#UART 0#UART 0#GPIO1 MIO#GPIO1 MIO#SPI 0#GPIO1 MIO#GPIO1 MIO#SPI 0#SPI 0#SPI 0#GPIO1 MIO#GPIO1 MIO#SD 1#SD 1#SD 1#SD 1#SD 1#SD 1#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 1#USB 1#USB 1#USB 1#USB 1#USB 1#USB 1#USB 1#USB 1#USB 1#USB 1#USB 1#GPIO2 MIO#GPIO2 MIO} \
   CONFIG.PSU_MIO_TREE_SIGNALS {scl_out#sda_out#gpio0[2]#gpio0[3]#gpio0[4]#gpio0[5]#gpio0[6]#gpio0[7]#txd#rxd#gpio0[10]#gpio0[11]#gpio0[12]#sdio0_data_out[0]#sdio0_data_out[1]#sdio0_data_out[2]#sdio0_data_out[3]#gpio0[17]#scl_out#sda_out#gpio0[20]#sdio0_cmd_out#sdio0_clk_out#gpio0[23]#sdio0_cd_n#reset#gpio1[26]#dp_aux_data_out#dp_hot_plug_detect#dp_aux_data_oe#dp_aux_data_in#gpio1[31]#gpio1[32]#gpio1[33]#rxd#txd#gpio1[36]#gpio1[37]#sclk_out#gpio1[39]#gpio1[40]#n_ss_out[0]#miso#mosi#gpio1[44]#gpio1[45]#sdio1_data_out[0]#sdio1_data_out[1]#sdio1_data_out[2]#sdio1_data_out[3]#sdio1_cmd_out#sdio1_clk_out#ulpi_clk_in#ulpi_dir#ulpi_tx_data[2]#ulpi_nxt#ulpi_tx_data[0]#ulpi_tx_data[1]#ulpi_stp#ulpi_tx_data[3]#ulpi_tx_data[4]#ulpi_tx_data[5]#ulpi_tx_data[6]#ulpi_tx_data[7]#ulpi_clk_in#ulpi_dir#ulpi_tx_data[2]#ulpi_nxt#ulpi_tx_data[0]#ulpi_tx_data[1]#ulpi_stp#ulpi_tx_data[3]#ulpi_tx_data[4]#ulpi_tx_data[5]#ulpi_tx_data[6]#ulpi_tx_data[7]#gpio2[76]#gpio2[77]} \
   CONFIG.PSU_SD0_INTERNAL_BUS_WIDTH {4} \
   CONFIG.PSU_SD1_INTERNAL_BUS_WIDTH {4} \
   CONFIG.PSU_USB3__DUAL_CLOCK_ENABLE {1} \
   CONFIG.PSU__ACT_DDR_FREQ_MHZ {1200.000000} \
   CONFIG.PSU__AFI0_COHERENCY {0} \
   CONFIG.PSU__CRF_APB__ACPU_CTRL__ACT_FREQMHZ {1200.000000} \
   CONFIG.PSU__CRF_APB__ACPU_CTRL__DIVISOR0 {1} \
   CONFIG.PSU__CRF_APB__ACPU_CTRL__FREQMHZ {1200} \
   CONFIG.PSU__CRF_APB__ACPU_CTRL__SRCSEL {APLL} \
   CONFIG.PSU__CRF_APB__APLL_CTRL__DIV2 {1} \
   CONFIG.PSU__CRF_APB__APLL_CTRL__FBDIV {72} \
   CONFIG.PSU__CRF_APB__APLL_CTRL__FRACDATA {0.000000} \
   CONFIG.PSU__CRF_APB__APLL_CTRL__SRCSEL {PSS_REF_CLK} \
   CONFIG.PSU__CRF_APB__APLL_FRAC_CFG__ENABLED {0} \
   CONFIG.PSU__CRF_APB__APLL_TO_LPD_CTRL__DIVISOR0 {3} \
   CONFIG.PSU__CRF_APB__DBG_FPD_CTRL__ACT_FREQMHZ {250.000000} \
   CONFIG.PSU__CRF_APB__DBG_FPD_CTRL__DIVISOR0 {2} \
   CONFIG.PSU__CRF_APB__DBG_FPD_CTRL__FREQMHZ {250} \
   CONFIG.PSU__CRF_APB__DBG_FPD_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRF_APB__DBG_TRACE_CTRL__DIVISOR0 {5} \
   CONFIG.PSU__CRF_APB__DBG_TSTMP_CTRL__ACT_FREQMHZ {250.000000} \
   CONFIG.PSU__CRF_APB__DBG_TSTMP_CTRL__DIVISOR0 {2} \
   CONFIG.PSU__CRF_APB__DBG_TSTMP_CTRL__FREQMHZ {250} \
   CONFIG.PSU__CRF_APB__DBG_TSTMP_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRF_APB__DDR_CTRL__ACT_FREQMHZ {600.000000} \
   CONFIG.PSU__CRF_APB__DDR_CTRL__DIVISOR0 {2} \
   CONFIG.PSU__CRF_APB__DDR_CTRL__FREQMHZ {1200} \
   CONFIG.PSU__CRF_APB__DDR_CTRL__SRCSEL {DPLL} \
   CONFIG.PSU__CRF_APB__DPDMA_REF_CTRL__ACT_FREQMHZ {600.000000} \
   CONFIG.PSU__CRF_APB__DPDMA_REF_CTRL__DIVISOR0 {2} \
   CONFIG.PSU__CRF_APB__DPDMA_REF_CTRL__FREQMHZ {600} \
   CONFIG.PSU__CRF_APB__DPDMA_REF_CTRL__SRCSEL {APLL} \
   CONFIG.PSU__CRF_APB__DPLL_CTRL__DIV2 {1} \
   CONFIG.PSU__CRF_APB__DPLL_CTRL__FBDIV {72} \
   CONFIG.PSU__CRF_APB__DPLL_CTRL__FRACDATA {0.000000} \
   CONFIG.PSU__CRF_APB__DPLL_CTRL__SRCSEL {PSS_REF_CLK} \
   CONFIG.PSU__CRF_APB__DPLL_FRAC_CFG__ENABLED {0} \
   CONFIG.PSU__CRF_APB__DPLL_TO_LPD_CTRL__DIVISOR0 {3} \
   CONFIG.PSU__CRF_APB__DP_AUDIO_REF_CTRL__ACT_FREQMHZ {25.000000} \
   CONFIG.PSU__CRF_APB__DP_AUDIO_REF_CTRL__DIVISOR0 {20} \
   CONFIG.PSU__CRF_APB__DP_AUDIO_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRF_APB__DP_AUDIO_REF_CTRL__SRCSEL {RPLL} \
   CONFIG.PSU__CRF_APB__DP_AUDIO__FRAC_ENABLED {0} \
   CONFIG.PSU__CRF_APB__DP_STC_REF_CTRL__ACT_FREQMHZ {26.315790} \
   CONFIG.PSU__CRF_APB__DP_STC_REF_CTRL__DIVISOR0 {19} \
   CONFIG.PSU__CRF_APB__DP_STC_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRF_APB__DP_STC_REF_CTRL__SRCSEL {RPLL} \
   CONFIG.PSU__CRF_APB__DP_VIDEO_REF_CTRL__ACT_FREQMHZ {300.000000} \
   CONFIG.PSU__CRF_APB__DP_VIDEO_REF_CTRL__DIVISOR0 {5} \
   CONFIG.PSU__CRF_APB__DP_VIDEO_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRF_APB__DP_VIDEO_REF_CTRL__SRCSEL {VPLL} \
   CONFIG.PSU__CRF_APB__DP_VIDEO__FRAC_ENABLED {0} \
   CONFIG.PSU__CRF_APB__GDMA_REF_CTRL__ACT_FREQMHZ {600.000000} \
   CONFIG.PSU__CRF_APB__GDMA_REF_CTRL__DIVISOR0 {2} \
   CONFIG.PSU__CRF_APB__GDMA_REF_CTRL__FREQMHZ {600} \
   CONFIG.PSU__CRF_APB__GDMA_REF_CTRL__SRCSEL {DPLL} \
   CONFIG.PSU__CRF_APB__GPU_REF_CTRL__ACT_FREQMHZ {500.000000} \
   CONFIG.PSU__CRF_APB__GPU_REF_CTRL__DIVISOR0 {1} \
   CONFIG.PSU__CRF_APB__GPU_REF_CTRL__FREQMHZ {500} \
   CONFIG.PSU__CRF_APB__GPU_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRF_APB__PCIE_REF_CTRL__DIVISOR0 {6} \
   CONFIG.PSU__CRF_APB__SATA_REF_CTRL__DIVISOR0 {5} \
   CONFIG.PSU__CRF_APB__SATA_REF_CTRL__FREQMHZ {250} \
   CONFIG.PSU__CRF_APB__SATA_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRF_APB__TOPSW_LSBUS_CTRL__ACT_FREQMHZ {100.000000} \
   CONFIG.PSU__CRF_APB__TOPSW_LSBUS_CTRL__DIVISOR0 {5} \
   CONFIG.PSU__CRF_APB__TOPSW_LSBUS_CTRL__FREQMHZ {100} \
   CONFIG.PSU__CRF_APB__TOPSW_LSBUS_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRF_APB__TOPSW_MAIN_CTRL__ACT_FREQMHZ {400.000000} \
   CONFIG.PSU__CRF_APB__TOPSW_MAIN_CTRL__DIVISOR0 {3} \
   CONFIG.PSU__CRF_APB__TOPSW_MAIN_CTRL__FREQMHZ {400} \
   CONFIG.PSU__CRF_APB__TOPSW_MAIN_CTRL__SRCSEL {DPLL} \
   CONFIG.PSU__CRF_APB__VPLL_CTRL__DIV2 {1} \
   CONFIG.PSU__CRF_APB__VPLL_CTRL__FBDIV {90} \
   CONFIG.PSU__CRF_APB__VPLL_CTRL__FRACDATA {0.000000} \
   CONFIG.PSU__CRF_APB__VPLL_CTRL__SRCSEL {PSS_REF_CLK} \
   CONFIG.PSU__CRF_APB__VPLL_FRAC_CFG__ENABLED {0} \
   CONFIG.PSU__CRF_APB__VPLL_TO_LPD_CTRL__DIVISOR0 {3} \
   CONFIG.PSU__CRL_APB__ADMA_REF_CTRL__ACT_FREQMHZ {500.000000} \
   CONFIG.PSU__CRL_APB__ADMA_REF_CTRL__DIVISOR0 {3} \
   CONFIG.PSU__CRL_APB__ADMA_REF_CTRL__FREQMHZ {500} \
   CONFIG.PSU__CRL_APB__ADMA_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__AFI6_REF_CTRL__DIVISOR0 {3} \
   CONFIG.PSU__CRL_APB__AMS_REF_CTRL__ACT_FREQMHZ {50.000000} \
   CONFIG.PSU__CRL_APB__AMS_REF_CTRL__DIVISOR0 {30} \
   CONFIG.PSU__CRL_APB__AMS_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__CAN0_REF_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRL_APB__CAN0_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__CAN1_REF_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRL_APB__CAN1_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__CPU_R5_CTRL__ACT_FREQMHZ {500.000000} \
   CONFIG.PSU__CRL_APB__CPU_R5_CTRL__DIVISOR0 {3} \
   CONFIG.PSU__CRL_APB__CPU_R5_CTRL__FREQMHZ {500} \
   CONFIG.PSU__CRL_APB__CPU_R5_CTRL__SRCSEL {RPLL} \
   CONFIG.PSU__CRL_APB__DBG_LPD_CTRL__ACT_FREQMHZ {250.000000} \
   CONFIG.PSU__CRL_APB__DBG_LPD_CTRL__DIVISOR0 {6} \
   CONFIG.PSU__CRL_APB__DBG_LPD_CTRL__FREQMHZ {250} \
   CONFIG.PSU__CRL_APB__DBG_LPD_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__DLL_REF_CTRL__ACT_FREQMHZ {1500.000000} \
   CONFIG.PSU__CRL_APB__GEM0_REF_CTRL__DIVISOR0 {12} \
   CONFIG.PSU__CRL_APB__GEM0_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__GEM1_REF_CTRL__DIVISOR0 {12} \
   CONFIG.PSU__CRL_APB__GEM1_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__GEM2_REF_CTRL__DIVISOR0 {12} \
   CONFIG.PSU__CRL_APB__GEM2_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__GEM3_REF_CTRL__DIVISOR0 {12} \
   CONFIG.PSU__CRL_APB__GEM3_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__GEM_TSU_REF_CTRL__DIVISOR0 {4} \
   CONFIG.PSU__CRL_APB__GEM_TSU_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__I2C0_REF_CTRL__ACT_FREQMHZ {100.000000} \
   CONFIG.PSU__CRL_APB__I2C0_REF_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRL_APB__I2C0_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__I2C0_REF_CTRL__FREQMHZ {100} \
   CONFIG.PSU__CRL_APB__I2C0_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__I2C1_REF_CTRL__ACT_FREQMHZ {100.000000} \
   CONFIG.PSU__CRL_APB__I2C1_REF_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRL_APB__I2C1_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__IOPLL_CTRL__DIV2 {1} \
   CONFIG.PSU__CRL_APB__IOPLL_CTRL__FBDIV {90} \
   CONFIG.PSU__CRL_APB__IOPLL_CTRL__FRACDATA {0.000000} \
   CONFIG.PSU__CRL_APB__IOPLL_CTRL__SRCSEL {PSS_REF_CLK} \
   CONFIG.PSU__CRL_APB__IOPLL_FRAC_CFG__ENABLED {0} \
   CONFIG.PSU__CRL_APB__IOPLL_TO_FPD_CTRL__DIVISOR0 {3} \
   CONFIG.PSU__CRL_APB__IOU_SWITCH_CTRL__ACT_FREQMHZ {250.000000} \
   CONFIG.PSU__CRL_APB__IOU_SWITCH_CTRL__DIVISOR0 {6} \
   CONFIG.PSU__CRL_APB__IOU_SWITCH_CTRL__FREQMHZ {250} \
   CONFIG.PSU__CRL_APB__IOU_SWITCH_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__LPD_LSBUS_CTRL__ACT_FREQMHZ {100.000000} \
   CONFIG.PSU__CRL_APB__LPD_LSBUS_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRL_APB__LPD_LSBUS_CTRL__FREQMHZ {100} \
   CONFIG.PSU__CRL_APB__LPD_LSBUS_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__LPD_SWITCH_CTRL__ACT_FREQMHZ {500.000000} \
   CONFIG.PSU__CRL_APB__LPD_SWITCH_CTRL__DIVISOR0 {3} \
   CONFIG.PSU__CRL_APB__LPD_SWITCH_CTRL__FREQMHZ {500} \
   CONFIG.PSU__CRL_APB__LPD_SWITCH_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__NAND_REF_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRL_APB__NAND_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__PCAP_CTRL__ACT_FREQMHZ {187.500000} \
   CONFIG.PSU__CRL_APB__PCAP_CTRL__DIVISOR0 {8} \
   CONFIG.PSU__CRL_APB__PCAP_CTRL__FREQMHZ {200} \
   CONFIG.PSU__CRL_APB__PCAP_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__PL0_REF_CTRL__ACT_FREQMHZ {100.000000} \
   CONFIG.PSU__CRL_APB__PL0_REF_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRL_APB__PL0_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__PL0_REF_CTRL__FREQMHZ {100} \
   CONFIG.PSU__CRL_APB__PL0_REF_CTRL__SRCSEL {RPLL} \
   CONFIG.PSU__CRL_APB__PL1_REF_CTRL__ACT_FREQMHZ {300.000000} \
   CONFIG.PSU__CRL_APB__PL1_REF_CTRL__DIVISOR0 {5} \
   CONFIG.PSU__CRL_APB__PL1_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__PL1_REF_CTRL__FREQMHZ {300} \
   CONFIG.PSU__CRL_APB__PL1_REF_CTRL__SRCSEL {RPLL} \
   CONFIG.PSU__CRL_APB__PL2_REF_CTRL__ACT_FREQMHZ {150.000000} \
   CONFIG.PSU__CRL_APB__PL2_REF_CTRL__DIVISOR0 {10} \
   CONFIG.PSU__CRL_APB__PL2_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__PL2_REF_CTRL__FREQMHZ {150} \
   CONFIG.PSU__CRL_APB__PL2_REF_CTRL__SRCSEL {RPLL} \
   CONFIG.PSU__CRL_APB__PL3_REF_CTRL__ACT_FREQMHZ {250.000000} \
   CONFIG.PSU__CRL_APB__PL3_REF_CTRL__DIVISOR0 {6} \
   CONFIG.PSU__CRL_APB__PL3_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__PL3_REF_CTRL__FREQMHZ {250} \
   CONFIG.PSU__CRL_APB__PL3_REF_CTRL__SRCSEL {RPLL} \
   CONFIG.PSU__CRL_APB__QSPI_REF_CTRL__DIVISOR0 {5} \
   CONFIG.PSU__CRL_APB__QSPI_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__RPLL_CTRL__DIV2 {1} \
   CONFIG.PSU__CRL_APB__RPLL_CTRL__FBDIV {90} \
   CONFIG.PSU__CRL_APB__RPLL_CTRL__FRACDATA {0.000000} \
   CONFIG.PSU__CRL_APB__RPLL_CTRL__SRCSEL {PSS_REF_CLK} \
   CONFIG.PSU__CRL_APB__RPLL_FRAC_CFG__ENABLED {0} \
   CONFIG.PSU__CRL_APB__RPLL_TO_FPD_CTRL__DIVISOR0 {3} \
   CONFIG.PSU__CRL_APB__SDIO0_REF_CTRL__ACT_FREQMHZ {187.500000} \
   CONFIG.PSU__CRL_APB__SDIO0_REF_CTRL__DIVISOR0 {8} \
   CONFIG.PSU__CRL_APB__SDIO0_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__SDIO0_REF_CTRL__FREQMHZ {200} \
   CONFIG.PSU__CRL_APB__SDIO0_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__SDIO1_REF_CTRL__ACT_FREQMHZ {187.500000} \
   CONFIG.PSU__CRL_APB__SDIO1_REF_CTRL__DIVISOR0 {8} \
   CONFIG.PSU__CRL_APB__SDIO1_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__SDIO1_REF_CTRL__FREQMHZ {200} \
   CONFIG.PSU__CRL_APB__SDIO1_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__SPI0_REF_CTRL__ACT_FREQMHZ {100.000000} \
   CONFIG.PSU__CRL_APB__SPI0_REF_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRL_APB__SPI0_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__SPI0_REF_CTRL__FREQMHZ {100} \
   CONFIG.PSU__CRL_APB__SPI0_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__SPI1_REF_CTRL__DIVISOR0 {7} \
   CONFIG.PSU__CRL_APB__SPI1_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__TIMESTAMP_REF_CTRL__ACT_FREQMHZ {100.000000} \
   CONFIG.PSU__CRL_APB__TIMESTAMP_REF_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRL_APB__TIMESTAMP_REF_CTRL__FREQMHZ {100} \
   CONFIG.PSU__CRL_APB__TIMESTAMP_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__UART0_REF_CTRL__ACT_FREQMHZ {100.000000} \
   CONFIG.PSU__CRL_APB__UART0_REF_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRL_APB__UART0_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__UART0_REF_CTRL__FREQMHZ {100} \
   CONFIG.PSU__CRL_APB__UART0_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__UART1_REF_CTRL__ACT_FREQMHZ {100.000000} \
   CONFIG.PSU__CRL_APB__UART1_REF_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRL_APB__UART1_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__UART1_REF_CTRL__FREQMHZ {100} \
   CONFIG.PSU__CRL_APB__UART1_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__USB0_BUS_REF_CTRL__ACT_FREQMHZ {250.000000} \
   CONFIG.PSU__CRL_APB__USB0_BUS_REF_CTRL__DIVISOR0 {6} \
   CONFIG.PSU__CRL_APB__USB0_BUS_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__USB0_BUS_REF_CTRL__FREQMHZ {250} \
   CONFIG.PSU__CRL_APB__USB0_BUS_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__USB1_BUS_REF_CTRL__ACT_FREQMHZ {250.000000} \
   CONFIG.PSU__CRL_APB__USB1_BUS_REF_CTRL__DIVISOR0 {6} \
   CONFIG.PSU__CRL_APB__USB1_BUS_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__USB1_BUS_REF_CTRL__FREQMHZ {250} \
   CONFIG.PSU__CRL_APB__USB1_BUS_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__USB3_DUAL_REF_CTRL__ACT_FREQMHZ {20.000000} \
   CONFIG.PSU__CRL_APB__USB3_DUAL_REF_CTRL__DIVISOR0 {25} \
   CONFIG.PSU__CRL_APB__USB3_DUAL_REF_CTRL__DIVISOR1 {3} \
   CONFIG.PSU__CRL_APB__USB3_DUAL_REF_CTRL__FREQMHZ {20} \
   CONFIG.PSU__CRL_APB__USB3_DUAL_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__USB3__ENABLE {1} \
   CONFIG.PSU__DDRC__ADDR_MIRROR {0} \
   CONFIG.PSU__DDRC__BANK_ADDR_COUNT {2} \
   CONFIG.PSU__DDRC__BG_ADDR_COUNT {1} \
   CONFIG.PSU__DDRC__BRC_MAPPING {ROW_BANK_COL} \
   CONFIG.PSU__DDRC__BUS_WIDTH {64 Bit} \
   CONFIG.PSU__DDRC__CL {16} \
   CONFIG.PSU__DDRC__CLOCK_STOP_EN {0} \
   CONFIG.PSU__DDRC__COL_ADDR_COUNT {10} \
   CONFIG.PSU__DDRC__COMPONENTS {Components} \
   CONFIG.PSU__DDRC__CWL {16} \
   CONFIG.PSU__DDRC__DDR3L_T_REF_RANGE {NA} \
   CONFIG.PSU__DDRC__DDR3_T_REF_RANGE {NA} \
   CONFIG.PSU__DDRC__DDR4_ADDR_MAPPING {0} \
   CONFIG.PSU__DDRC__DDR4_CAL_MODE_ENABLE {0} \
   CONFIG.PSU__DDRC__DDR4_CRC_CONTROL {0} \
   CONFIG.PSU__DDRC__DDR4_T_REF_MODE {0} \
   CONFIG.PSU__DDRC__DDR4_T_REF_RANGE {Normal (0-85)} \
   CONFIG.PSU__DDRC__DEEP_PWR_DOWN_EN {0} \
   CONFIG.PSU__DDRC__DEVICE_CAPACITY {8192 MBits} \
   CONFIG.PSU__DDRC__DIMM_ADDR_MIRROR {0} \
   CONFIG.PSU__DDRC__DM_DBI {DM_NO_DBI} \
   CONFIG.PSU__DDRC__DQMAP_0_3 {0} \
   CONFIG.PSU__DDRC__DQMAP_12_15 {0} \
   CONFIG.PSU__DDRC__DQMAP_16_19 {0} \
   CONFIG.PSU__DDRC__DQMAP_20_23 {0} \
   CONFIG.PSU__DDRC__DQMAP_24_27 {0} \
   CONFIG.PSU__DDRC__DQMAP_28_31 {0} \
   CONFIG.PSU__DDRC__DQMAP_32_35 {0} \
   CONFIG.PSU__DDRC__DQMAP_36_39 {0} \
   CONFIG.PSU__DDRC__DQMAP_40_43 {0} \
   CONFIG.PSU__DDRC__DQMAP_44_47 {0} \
   CONFIG.PSU__DDRC__DQMAP_48_51 {0} \
   CONFIG.PSU__DDRC__DQMAP_4_7 {0} \
   CONFIG.PSU__DDRC__DQMAP_52_55 {0} \
   CONFIG.PSU__DDRC__DQMAP_56_59 {0} \
   CONFIG.PSU__DDRC__DQMAP_60_63 {0} \
   CONFIG.PSU__DDRC__DQMAP_64_67 {0} \
   CONFIG.PSU__DDRC__DQMAP_68_71 {0} \
   CONFIG.PSU__DDRC__DQMAP_8_11 {0} \
   CONFIG.PSU__DDRC__DRAM_WIDTH {16 Bits} \
   CONFIG.PSU__DDRC__ECC {Disabled} \
   CONFIG.PSU__DDRC__ENABLE_LP4_HAS_ECC_COMP {0} \
   CONFIG.PSU__DDRC__ENABLE_LP4_SLOWBOOT {0} \
   CONFIG.PSU__DDRC__FGRM {1X} \
   CONFIG.PSU__DDRC__LPDDR3_T_REF_RANGE {NA} \
   CONFIG.PSU__DDRC__LPDDR4_T_REF_RANGE {NA} \
   CONFIG.PSU__DDRC__LP_ASR {manual normal} \
   CONFIG.PSU__DDRC__MEMORY_TYPE {DDR 4} \
   CONFIG.PSU__DDRC__PARITY_ENABLE {0} \
   CONFIG.PSU__DDRC__PER_BANK_REFRESH {0} \
   CONFIG.PSU__DDRC__PHY_DBI_MODE {0} \
   CONFIG.PSU__DDRC__ROW_ADDR_COUNT {16} \
   CONFIG.PSU__DDRC__SB_TARGET {16-16-16} \
   CONFIG.PSU__DDRC__SELF_REF_ABORT {0} \
   CONFIG.PSU__DDRC__SPEED_BIN {DDR4_2400R} \
   CONFIG.PSU__DDRC__STATIC_RD_MODE {0} \
   CONFIG.PSU__DDRC__TRAIN_DATA_EYE {1} \
   CONFIG.PSU__DDRC__TRAIN_READ_GATE {1} \
   CONFIG.PSU__DDRC__TRAIN_WRITE_LEVEL {1} \
   CONFIG.PSU__DDRC__T_FAW {30.0} \
   CONFIG.PSU__DDRC__T_RAS_MIN {32} \
   CONFIG.PSU__DDRC__T_RC {45.32} \
   CONFIG.PSU__DDRC__T_RCD {16} \
   CONFIG.PSU__DDRC__T_RP {16} \
   CONFIG.PSU__DDRC__VENDOR_PART {OTHERS} \
   CONFIG.PSU__DDRC__VREF {1} \
   CONFIG.PSU__DDR_HIGH_ADDRESS_GUI_ENABLE {1} \
   CONFIG.PSU__DDR__INTERFACE__FREQMHZ {600.000} \
   CONFIG.PSU__DISPLAYPORT__LANE0__ENABLE {1} \
   CONFIG.PSU__DISPLAYPORT__LANE0__IO {GT Lane1} \
   CONFIG.PSU__DISPLAYPORT__LANE1__ENABLE {1} \
   CONFIG.PSU__DISPLAYPORT__LANE1__IO {GT Lane0} \
   CONFIG.PSU__DISPLAYPORT__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__DLL__ISUSED {1} \
   CONFIG.PSU__DPAUX__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__DPAUX__PERIPHERAL__IO {MIO 27 .. 30} \
   CONFIG.PSU__DP__LANE_SEL {Dual Lower} \
   CONFIG.PSU__DP__REF_CLK_FREQ {27} \
   CONFIG.PSU__DP__REF_CLK_SEL {Ref Clk1} \
   CONFIG.PSU__FPD_SLCR__WDT1__ACT_FREQMHZ {100.000000} \
   CONFIG.PSU__FPD_SLCR__WDT1__FREQMHZ {100.000000} \
   CONFIG.PSU__FPD_SLCR__WDT_CLK_SEL__SELECT {APB} \
   CONFIG.PSU__FPGA_PL0_ENABLE {1} \
   CONFIG.PSU__FPGA_PL1_ENABLE {1} \
   CONFIG.PSU__FPGA_PL2_ENABLE {1} \
   CONFIG.PSU__FPGA_PL3_ENABLE {1} \
   CONFIG.PSU__GPIO0_MIO__IO {MIO 0 .. 25} \
   CONFIG.PSU__GPIO0_MIO__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__GPIO1_MIO__IO {MIO 26 .. 51} \
   CONFIG.PSU__GPIO1_MIO__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__GPIO2_MIO__IO {MIO 52 .. 77} \
   CONFIG.PSU__GPIO2_MIO__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__GPIO_EMIO_WIDTH {11} \
   CONFIG.PSU__GPIO_EMIO__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__GPIO_EMIO__PERIPHERAL__IO {11} \
   CONFIG.PSU__GT__LINK_SPEED {HBR} \
   CONFIG.PSU__GT__PRE_EMPH_LVL_4 {0} \
   CONFIG.PSU__GT__VLT_SWNG_LVL_4 {0} \
   CONFIG.PSU__HIGH_ADDRESS__ENABLE {1} \
   CONFIG.PSU__I2C0__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__I2C0__PERIPHERAL__IO {MIO 18 .. 19} \
   CONFIG.PSU__I2C1__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__I2C1__PERIPHERAL__IO {MIO 0 .. 1} \
   CONFIG.PSU__IOU_SLCR__IOU_TTC_APB_CLK__TTC0_SEL {APB} \
   CONFIG.PSU__IOU_SLCR__IOU_TTC_APB_CLK__TTC1_SEL {APB} \
   CONFIG.PSU__IOU_SLCR__IOU_TTC_APB_CLK__TTC2_SEL {APB} \
   CONFIG.PSU__IOU_SLCR__IOU_TTC_APB_CLK__TTC3_SEL {APB} \
   CONFIG.PSU__IOU_SLCR__TTC0__ACT_FREQMHZ {100.000000} \
   CONFIG.PSU__IOU_SLCR__TTC0__FREQMHZ {100.000000} \
   CONFIG.PSU__IOU_SLCR__TTC1__ACT_FREQMHZ {100.000000} \
   CONFIG.PSU__IOU_SLCR__TTC1__FREQMHZ {100.000000} \
   CONFIG.PSU__IOU_SLCR__TTC2__ACT_FREQMHZ {100.000000} \
   CONFIG.PSU__IOU_SLCR__TTC2__FREQMHZ {100.000000} \
   CONFIG.PSU__IOU_SLCR__TTC3__ACT_FREQMHZ {100.000000} \
   CONFIG.PSU__IOU_SLCR__TTC3__FREQMHZ {100.000000} \
   CONFIG.PSU__IOU_SLCR__WDT0__ACT_FREQMHZ {100.000000} \
   CONFIG.PSU__IOU_SLCR__WDT0__FREQMHZ {100.000000} \
   CONFIG.PSU__IOU_SLCR__WDT_CLK_SEL__SELECT {APB} \
   CONFIG.PSU__MAXIGP0__DATA_WIDTH {128} \
   CONFIG.PSU__MAXIGP1__DATA_WIDTH {128} \
   CONFIG.PSU__MAXIGP2__DATA_WIDTH {32} \
   CONFIG.PSU__OVERRIDE__BASIC_CLOCK {0} \
   CONFIG.PSU__PL_CLK0_BUF {TRUE} \
   CONFIG.PSU__PL_CLK1_BUF {TRUE} \
   CONFIG.PSU__PL_CLK2_BUF {TRUE} \
   CONFIG.PSU__PL_CLK3_BUF {TRUE} \
   CONFIG.PSU__PRESET_APPLIED {1} \
   CONFIG.PSU__PROTECTION__MASTERS {USB1:NonSecure;1|USB0:NonSecure;1|S_AXI_LPD:NA;1|S_AXI_HPC1_FPD:NA;0|S_AXI_HPC0_FPD:NA;0|S_AXI_HP3_FPD:NA;1|S_AXI_HP2_FPD:NA;1|S_AXI_HP1_FPD:NA;1|S_AXI_HP0_FPD:NA;1|S_AXI_ACP:NA;0|S_AXI_ACE:NA;0|SD1:NonSecure;1|SD0:NonSecure;1|SATA1:NonSecure;0|SATA0:NonSecure;0|RPU1:Secure;1|RPU0:Secure;1|QSPI:NonSecure;0|PMU:NA;1|PCIe:NonSecure;0|NAND:NonSecure;0|LDMA:NonSecure;1|GPU:NonSecure;1|GEM3:NonSecure;0|GEM2:NonSecure;0|GEM1:NonSecure;0|GEM0:NonSecure;0|FDMA:NonSecure;1|DP:NonSecure;1|DAP:NA;1|Coresight:NA;1|CSU:NA;1|APU:NA;1} \
   CONFIG.PSU__PROTECTION__SLAVES {LPD;USB3_1_XHCI;FE300000;FE3FFFFF;1|LPD;USB3_1;FF9E0000;FF9EFFFF;1|LPD;USB3_0_XHCI;FE200000;FE2FFFFF;1|LPD;USB3_0;FF9D0000;FF9DFFFF;1|LPD;UART1;FF010000;FF01FFFF;1|LPD;UART0;FF000000;FF00FFFF;1|LPD;TTC3;FF140000;FF14FFFF;1|LPD;TTC2;FF130000;FF13FFFF;1|LPD;TTC1;FF120000;FF12FFFF;1|LPD;TTC0;FF110000;FF11FFFF;1|FPD;SWDT1;FD4D0000;FD4DFFFF;1|LPD;SWDT0;FF150000;FF15FFFF;1|LPD;SPI1;FF050000;FF05FFFF;0|LPD;SPI0;FF040000;FF04FFFF;1|FPD;SMMU_REG;FD5F0000;FD5FFFFF;1|FPD;SMMU;FD800000;FDFFFFFF;1|FPD;SIOU;FD3D0000;FD3DFFFF;1|FPD;SERDES;FD400000;FD47FFFF;1|LPD;SD1;FF170000;FF17FFFF;1|LPD;SD0;FF160000;FF16FFFF;1|FPD;SATA;FD0C0000;FD0CFFFF;0|LPD;RTC;FFA60000;FFA6FFFF;1|LPD;RSA_CORE;FFCE0000;FFCEFFFF;1|LPD;RPU;FF9A0000;FF9AFFFF;1|LPD;R5_TCM_RAM_GLOBAL;FFE00000;FFE3FFFF;1|LPD;R5_1_Instruction_Cache;FFEC0000;FFECFFFF;1|LPD;R5_1_Data_Cache;FFED0000;FFEDFFFF;1|LPD;R5_1_BTCM_GLOBAL;FFEB0000;FFEBFFFF;1|LPD;R5_1_ATCM_GLOBAL;FFE90000;FFE9FFFF;1|LPD;R5_0_Instruction_Cache;FFE40000;FFE4FFFF;1|LPD;R5_0_Data_Cache;FFE50000;FFE5FFFF;1|LPD;R5_0_BTCM_GLOBAL;FFE20000;FFE2FFFF;1|LPD;R5_0_ATCM_GLOBAL;FFE00000;FFE0FFFF;1|LPD;QSPI_Linear_Address;C0000000;DFFFFFFF;1|LPD;QSPI;FF0F0000;FF0FFFFF;0|LPD;PMU_RAM;FFDC0000;FFDDFFFF;1|LPD;PMU_GLOBAL;FFD80000;FFDBFFFF;1|FPD;PCIE_MAIN;FD0E0000;FD0EFFFF;0|FPD;PCIE_LOW;E0000000;EFFFFFFF;0|FPD;PCIE_HIGH2;8000000000;BFFFFFFFFF;0|FPD;PCIE_HIGH1;600000000;7FFFFFFFF;0|FPD;PCIE_DMA;FD0F0000;FD0FFFFF;0|FPD;PCIE_ATTRIB;FD480000;FD48FFFF;0|LPD;OCM_XMPU_CFG;FFA70000;FFA7FFFF;1|LPD;OCM_SLCR;FF960000;FF96FFFF;1|OCM;OCM;FFFC0000;FFFFFFFF;1|LPD;NAND;FF100000;FF10FFFF;0|LPD;MBISTJTAG;FFCF0000;FFCFFFFF;1|LPD;LPD_XPPU_SINK;FF9C0000;FF9CFFFF;1|LPD;LPD_XPPU;FF980000;FF98FFFF;1|LPD;LPD_SLCR_SECURE;FF4B0000;FF4DFFFF;1|LPD;LPD_SLCR;FF410000;FF4AFFFF;1|LPD;LPD_GPV;FE100000;FE1FFFFF;1|LPD;LPD_DMA_7;FFAF0000;FFAFFFFF;1|LPD;LPD_DMA_6;FFAE0000;FFAEFFFF;1|LPD;LPD_DMA_5;FFAD0000;FFADFFFF;1|LPD;LPD_DMA_4;FFAC0000;FFACFFFF;1|LPD;LPD_DMA_3;FFAB0000;FFABFFFF;1|LPD;LPD_DMA_2;FFAA0000;FFAAFFFF;1|LPD;LPD_DMA_1;FFA90000;FFA9FFFF;1|LPD;LPD_DMA_0;FFA80000;FFA8FFFF;1|LPD;IPI_CTRL;FF380000;FF3FFFFF;1|LPD;IOU_SLCR;FF180000;FF23FFFF;1|LPD;IOU_SECURE_SLCR;FF240000;FF24FFFF;1|LPD;IOU_SCNTRS;FF260000;FF26FFFF;1|LPD;IOU_SCNTR;FF250000;FF25FFFF;1|LPD;IOU_GPV;FE000000;FE0FFFFF;1|LPD;I2C1;FF030000;FF03FFFF;1|LPD;I2C0;FF020000;FF02FFFF;1|FPD;GPU;FD4B0000;FD4BFFFF;1|LPD;GPIO;FF0A0000;FF0AFFFF;1|LPD;GEM3;FF0E0000;FF0EFFFF;0|LPD;GEM2;FF0D0000;FF0DFFFF;0|LPD;GEM1;FF0C0000;FF0CFFFF;0|LPD;GEM0;FF0B0000;FF0BFFFF;0|FPD;FPD_XMPU_SINK;FD4F0000;FD4FFFFF;1|FPD;FPD_XMPU_CFG;FD5D0000;FD5DFFFF;1|FPD;FPD_SLCR_SECURE;FD690000;FD6CFFFF;1|FPD;FPD_SLCR;FD610000;FD68FFFF;1|FPD;FPD_GPV;FD700000;FD7FFFFF;1|FPD;FPD_DMA_CH7;FD570000;FD57FFFF;1|FPD;FPD_DMA_CH6;FD560000;FD56FFFF;1|FPD;FPD_DMA_CH5;FD550000;FD55FFFF;1|FPD;FPD_DMA_CH4;FD540000;FD54FFFF;1|FPD;FPD_DMA_CH3;FD530000;FD53FFFF;1|FPD;FPD_DMA_CH2;FD520000;FD52FFFF;1|FPD;FPD_DMA_CH1;FD510000;FD51FFFF;1|FPD;FPD_DMA_CH0;FD500000;FD50FFFF;1|LPD;EFUSE;FFCC0000;FFCCFFFF;1|FPD;Display Port;FD4A0000;FD4AFFFF;1|FPD;DPDMA;FD4C0000;FD4CFFFF;1|FPD;DDR_XMPU5_CFG;FD050000;FD05FFFF;1|FPD;DDR_XMPU4_CFG;FD040000;FD04FFFF;1|FPD;DDR_XMPU3_CFG;FD030000;FD03FFFF;1|FPD;DDR_XMPU2_CFG;FD020000;FD02FFFF;1|FPD;DDR_XMPU1_CFG;FD010000;FD01FFFF;1|FPD;DDR_XMPU0_CFG;FD000000;FD00FFFF;1|FPD;DDR_QOS_CTRL;FD090000;FD09FFFF;1|FPD;DDR_PHY;FD080000;FD08FFFF;1|DDR;DDR_LOW;0;7FFFFFFF;1|DDR;DDR_HIGH;800000000;87FFFFFFF;1|FPD;DDDR_CTRL;FD070000;FD070FFF;1|LPD;Coresight;FE800000;FEFFFFFF;1|LPD;CSU_DMA;FFC80000;FFC9FFFF;1|LPD;CSU;FFCA0000;FFCAFFFF;1|LPD;CRL_APB;FF5E0000;FF85FFFF;1|FPD;CRF_APB;FD1A0000;FD2DFFFF;1|FPD;CCI_REG;FD5E0000;FD5EFFFF;1|FPD;CCI_GPV;FD6E0000;FD6EFFFF;1|LPD;CAN1;FF070000;FF07FFFF;0|LPD;CAN0;FF060000;FF06FFFF;0|FPD;APU;FD5C0000;FD5CFFFF;1|LPD;APM_INTC_IOU;FFA20000;FFA2FFFF;1|LPD;APM_FPD_LPD;FFA30000;FFA3FFFF;1|FPD;APM_5;FD490000;FD49FFFF;1|FPD;APM_0;FD0B0000;FD0BFFFF;1|LPD;APM2;FFA10000;FFA1FFFF;1|LPD;APM1;FFA00000;FFA0FFFF;1|LPD;AMS;FFA50000;FFA5FFFF;1|FPD;AFI_5;FD3B0000;FD3BFFFF;1|FPD;AFI_4;FD3A0000;FD3AFFFF;1|FPD;AFI_3;FD390000;FD39FFFF;1|FPD;AFI_2;FD380000;FD38FFFF;1|FPD;AFI_1;FD370000;FD37FFFF;1|FPD;AFI_0;FD360000;FD36FFFF;1|LPD;AFIFM6;FF9B0000;FF9BFFFF;1|FPD;ACPU_GIC;F9010000;F907FFFF;1} \
   CONFIG.PSU__PSS_REF_CLK__FREQMHZ {33.333333} \
   CONFIG.PSU__QSPI_COHERENCY {0} \
   CONFIG.PSU__QSPI_ROUTE_THROUGH_FPD {0} \
   CONFIG.PSU__QSPI__GRP_FBCLK__ENABLE {0} \
   CONFIG.PSU__QSPI__PERIPHERAL__ENABLE {0} \
   CONFIG.PSU__SATA__LANE0__ENABLE {0} \
   CONFIG.PSU__SATA__LANE1__ENABLE {0} \
   CONFIG.PSU__SATA__PERIPHERAL__ENABLE {0} \
   CONFIG.PSU__SAXIGP0__DATA_WIDTH {64} \
   CONFIG.PSU__SAXIGP2__DATA_WIDTH {128} \
   CONFIG.PSU__SAXIGP3__DATA_WIDTH {128} \
   CONFIG.PSU__SAXIGP4__DATA_WIDTH {128} \
   CONFIG.PSU__SAXIGP5__DATA_WIDTH {128} \
   CONFIG.PSU__SAXIGP6__DATA_WIDTH {128} \
   CONFIG.PSU__SD0_COHERENCY {0} \
   CONFIG.PSU__SD0_ROUTE_THROUGH_FPD {0} \
   CONFIG.PSU__SD0__DATA_TRANSFER_MODE {4Bit} \
   CONFIG.PSU__SD0__GRP_CD__ENABLE {1} \
   CONFIG.PSU__SD0__GRP_CD__IO {MIO 24} \
   CONFIG.PSU__SD0__GRP_POW__ENABLE {0} \
   CONFIG.PSU__SD0__GRP_WP__ENABLE {0} \
   CONFIG.PSU__SD0__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__SD0__PERIPHERAL__IO {MIO 13 .. 16 21 22} \
   CONFIG.PSU__SD0__RESET__ENABLE {0} \
   CONFIG.PSU__SD0__SLOT_TYPE {SD 2.0} \
   CONFIG.PSU__SD1_COHERENCY {0} \
   CONFIG.PSU__SD1_ROUTE_THROUGH_FPD {0} \
   CONFIG.PSU__SD1__DATA_TRANSFER_MODE {4Bit} \
   CONFIG.PSU__SD1__GRP_CD__ENABLE {0} \
   CONFIG.PSU__SD1__GRP_POW__ENABLE {0} \
   CONFIG.PSU__SD1__GRP_WP__ENABLE {0} \
   CONFIG.PSU__SD1__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__SD1__PERIPHERAL__IO {MIO 46 .. 51} \
   CONFIG.PSU__SD1__RESET__ENABLE {0} \
   CONFIG.PSU__SD1__SLOT_TYPE {SD 2.0} \
   CONFIG.PSU__SPI0__GRP_SS0__ENABLE {1} \
   CONFIG.PSU__SPI0__GRP_SS0__IO {MIO 41} \
   CONFIG.PSU__SPI0__GRP_SS1__ENABLE {0} \
   CONFIG.PSU__SPI0__GRP_SS2__ENABLE {0} \
   CONFIG.PSU__SPI0__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__SPI0__PERIPHERAL__IO {MIO 38 .. 43} \
   CONFIG.PSU__SWDT0__CLOCK__ENABLE {0} \
   CONFIG.PSU__SWDT0__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__SWDT0__RESET__ENABLE {0} \
   CONFIG.PSU__SWDT1__CLOCK__ENABLE {0} \
   CONFIG.PSU__SWDT1__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__SWDT1__RESET__ENABLE {0} \
   CONFIG.PSU__TTC0__CLOCK__ENABLE {0} \
   CONFIG.PSU__TTC0__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__TTC0__WAVEOUT__ENABLE {0} \
   CONFIG.PSU__TTC1__CLOCK__ENABLE {0} \
   CONFIG.PSU__TTC1__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__TTC1__WAVEOUT__ENABLE {0} \
   CONFIG.PSU__TTC2__CLOCK__ENABLE {0} \
   CONFIG.PSU__TTC2__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__TTC2__WAVEOUT__ENABLE {0} \
   CONFIG.PSU__TTC3__CLOCK__ENABLE {0} \
   CONFIG.PSU__TTC3__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__TTC3__WAVEOUT__ENABLE {0} \
   CONFIG.PSU__UART0__BAUD_RATE {115200} \
   CONFIG.PSU__UART0__MODEM__ENABLE {0} \
   CONFIG.PSU__UART0__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__UART0__PERIPHERAL__IO {MIO 34 .. 35} \
   CONFIG.PSU__UART1__BAUD_RATE {115200} \
   CONFIG.PSU__UART1__MODEM__ENABLE {1} \
   CONFIG.PSU__UART1__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__UART1__PERIPHERAL__IO {MIO 8 .. 9} \
   CONFIG.PSU__USB0_COHERENCY {0} \
   CONFIG.PSU__USB0__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__USB0__PERIPHERAL__IO {MIO 52 .. 63} \
   CONFIG.PSU__USB0__REF_CLK_FREQ {26} \
   CONFIG.PSU__USB0__REF_CLK_SEL {Ref Clk0} \
   CONFIG.PSU__USB0__RESET__ENABLE {1} \
   CONFIG.PSU__USB0__RESET__IO {MIO 25} \
   CONFIG.PSU__USB1_COHERENCY {0} \
   CONFIG.PSU__USB1__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__USB1__PERIPHERAL__IO {MIO 64 .. 75} \
   CONFIG.PSU__USB1__REF_CLK_FREQ {26} \
   CONFIG.PSU__USB1__REF_CLK_SEL {Ref Clk0} \
   CONFIG.PSU__USB1__RESET__ENABLE {0} \
   CONFIG.PSU__USB2_0__EMIO__ENABLE {0} \
   CONFIG.PSU__USB2_1__EMIO__ENABLE {0} \
   CONFIG.PSU__USB3_0__EMIO__ENABLE {0} \
   CONFIG.PSU__USB3_0__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__USB3_0__PERIPHERAL__IO {GT Lane2} \
   CONFIG.PSU__USB3_1__EMIO__ENABLE {0} \
   CONFIG.PSU__USB3_1__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__USB3_1__PERIPHERAL__IO {GT Lane3} \
   CONFIG.PSU__USB__RESET__MODE {Shared MIO Pin} \
   CONFIG.PSU__USB__RESET__POLARITY {Active Low} \
   CONFIG.PSU__USE__IRQ0 {1} \
   CONFIG.PSU__USE__M_AXI_GP0 {1} \
   CONFIG.PSU__USE__M_AXI_GP1 {0} \
   CONFIG.PSU__USE__M_AXI_GP2 {1} \
   CONFIG.PSU__USE__S_AXI_GP0 {0} \
   CONFIG.PSU__USE__S_AXI_GP2 {1} \
   CONFIG.PSU__USE__S_AXI_GP3 {1} \
   CONFIG.PSU__USE__S_AXI_GP4 {1} \
   CONFIG.PSU__USE__S_AXI_GP5 {1} \
   CONFIG.PSU__USE__S_AXI_GP6 {1} \
   CONFIG.SUBPRESET1 {Custom} \
 ] $ps_e_0

  # Create instance: ps_e_0_axi_periph, and set properties
  set ps_e_0_axi_periph [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 ps_e_0_axi_periph ]
  set_property -dict [ list \
   CONFIG.NUM_MI {8} \
 ] $ps_e_0_axi_periph

  # Create instance: rgbleds, and set properties
  set rgbleds [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 rgbleds ]
  set_property -dict [ list \
   CONFIG.C_ALL_OUTPUTS {1} \
   CONFIG.GPIO_BOARD_INTERFACE {rgbleds} \
   CONFIG.USE_BOARD_FLOW {true} \
 ] $rgbleds

  # Create instance: rpi_buf, and set properties
  set rpi_buf [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.2 rpi_buf ]
  set_property -dict [ list \
   CONFIG.C_BUF_TYPE {IOBUF} \
   CONFIG.C_SIZE {28} \
 ] $rpi_buf

  # Create instance: rst_clk_wiz_1_200M, and set properties
  set rst_clk_wiz_1_200M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_clk_wiz_1_200M ]
  set_property -dict [ list \
   CONFIG.C_AUX_RESET_HIGH {0} \
 ] $rst_clk_wiz_1_200M

  # Create instance: shutdown_HP0_FPD, and set properties
  set shutdown_HP0_FPD [ create_bd_cell -type ip -vlnv xilinx.com:ip:dfx_axi_shutdown_manager:1.0 shutdown_HP0_FPD ]
  set_property -dict [ list \
   CONFIG.CTRL_INTERFACE_TYPE {1} \
   CONFIG.DP_AXI_DATA_WIDTH {128} \
 ] $shutdown_HP0_FPD

   # Create instance: shutdown_HP1_FPD, and set properties
  set shutdown_HP1_FPD [ create_bd_cell -type ip -vlnv xilinx.com:ip:dfx_axi_shutdown_manager:1.0 shutdown_HP1_FPD ]
  set_property -dict [ list \
   CONFIG.CTRL_INTERFACE_TYPE {1} \
   CONFIG.DP_AXI_DATA_WIDTH {128} \
 ] $shutdown_HP1_FPD

  # Create instance: shutdown_HP2_FPD, and set properties
  set shutdown_HP2_FPD [ create_bd_cell -type ip -vlnv xilinx.com:ip:dfx_axi_shutdown_manager:1.0 shutdown_HP2_FPD ]
  set_property -dict [ list \
   CONFIG.CTRL_INTERFACE_TYPE {1} \
   CONFIG.DP_AXI_DATA_WIDTH {128} \
 ] $shutdown_HP2_FPD

  # Create instance: shutdown_LPD, and set properties
  set shutdown_LPD [ create_bd_cell -type ip -vlnv xilinx.com:ip:dfx_axi_shutdown_manager:1.0 shutdown_LPD ]
  set_property -dict [ list \
   CONFIG.CTRL_INTERFACE_TYPE {1} \
   CONFIG.DP_AXI_DATA_WIDTH {128} \
 ] $shutdown_LPD

  # Create instance: system_management_wiz_0, and set properties
  set system_management_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:system_management_wiz:1.3 system_management_wiz_0 ]
  set_property -dict [ list \
   CONFIG.AVERAGE_ENABLE_VAUXP14_VAUXN14 {true} \
   CONFIG.AVERAGE_ENABLE_VAUXP15_VAUXN15 {true} \
   CONFIG.CHANNEL_AVERAGING {16} \
   CONFIG.CHANNEL_ENABLE_VAUXP14_VAUXN14 {true} \
   CONFIG.CHANNEL_ENABLE_VAUXP15_VAUXN15 {true} \
   CONFIG.COMMON_N_SOURCE {Vaux15} \
 ] $system_management_wiz_0

  # Create instance: trace_analyzer_pi
  create_hier_cell_trace_analyzer_pi [current_bd_instance .] trace_analyzer_pi

  # Create instance: trace_analyzer_pmod0
  create_hier_cell_trace_analyzer_pmod0 [current_bd_instance .] trace_analyzer_pmod0

  # Create instance: trace_analyzer_pmod1
  create_hier_cell_trace_analyzer_pmod1 [current_bd_instance .] trace_analyzer_pmod1

  # Create instance: hdmi_tx_control, and set properties
  set hdmi_tx_control [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 hdmi_tx_control ]
  set_property -dict [ list \
   CONFIG.C_ALL_OUTPUTS {1} \
   CONFIG.C_GPIO_WIDTH {1} \
   CONFIG.C_GPIO2_WIDTH {2} \
   CONFIG.C_IS_DUAL {1} \
   CONFIG.C_ALL_OUTPUTS_2 {1} \
 ] $hdmi_tx_control

  # Create instance: video
  create_hier_cell_video [current_bd_instance .] video

  # Create instance: xlconcat0, and set properties
  set xlconcat0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat0 ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {17} \
 ] $xlconcat0

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {1} \
 ] $xlconcat_0

  # Create instance: xlconcat_1, and set properties
  set xlconcat_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_1 ]

  # Create instance: xlslice_0, and set properties
  set xlslice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_0 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {0} \
   CONFIG.DIN_TO {0} \
   CONFIG.DIN_WIDTH {2} \
 ] $xlslice_0

  # Create instance: xlslice_1, and set properties
  set xlslice_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_1 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {1} \
   CONFIG.DIN_TO {1} \
   CONFIG.DIN_WIDTH {2} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_1

  # Create interface connections
  connect_bd_intf_net -intf_net Vaux14_0_1 [get_bd_intf_ports Vaux14] [get_bd_intf_pins system_management_wiz_0/Vaux14]
  connect_bd_intf_net -intf_net Vaux15_0_1 [get_bd_intf_ports Vaux15] [get_bd_intf_pins system_management_wiz_0/Vaux15]
  connect_bd_intf_net -intf_net Vp_Vn_0_1 [get_bd_intf_ports Vp_Vn] [get_bd_intf_pins system_management_wiz_0/Vp_Vn]
  connect_bd_intf_net -intf_net address_remap_0_M_AXI_out [get_bd_intf_pins address_remap_0/M_AXI_out] [get_bd_intf_pins axi_register_slice_0/S_AXI]
  connect_bd_intf_net -intf_net axi_gpio_0_GPIO [get_bd_intf_ports dip_switch_4bits] [get_bd_intf_pins gpio_sws/GPIO]
  connect_bd_intf_net -intf_net axi_gpio_0_GPIO1 [get_bd_intf_ports led_4bits] [get_bd_intf_pins gpio_leds/GPIO]
  connect_bd_intf_net -intf_net axi_gpio_0_GPIO2 [get_bd_intf_ports push_button_4bits] [get_bd_intf_pins gpio_btns/GPIO]
  connect_bd_intf_net -intf_net axi_interconnect_0_M00_AXI [get_bd_intf_pins address_remap_0/S_AXI_in] [get_bd_intf_pins axi_interconnect_0/M00_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_1_M00_AXI [get_bd_intf_pins axi_interconnect_1/M00_AXI] [get_bd_intf_pins mipi/s_axi_CTRL1]
  connect_bd_intf_net -intf_net axi_interconnect_1_M01_AXI [get_bd_intf_pins axi_interconnect_1/M01_AXI] [get_bd_intf_pins mipi/s_axi_ctrl2]
  connect_bd_intf_net -intf_net axi_interconnect_1_M02_AXI [get_bd_intf_pins axi_interconnect_1/M02_AXI] [get_bd_intf_pins mipi/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_1_M03_AXI [get_bd_intf_pins axi_interconnect_1/M03_AXI] [get_bd_intf_pins mipi/s_axi_ctrl3]
  connect_bd_intf_net -intf_net axi_interconnect_M05_AXI [get_bd_intf_pins axi_intc_0/s_axi] [get_bd_intf_pins axi_interconnect/M05_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_M06_AXI [get_bd_intf_pins axi_interconnect/M06_AXI] [get_bd_intf_pins mipi/csirxss_s_axi]
  connect_bd_intf_net -intf_net axi_interconnect_M07_AXI [get_bd_intf_pins axi_interconnect/M07_AXI] [get_bd_intf_pins video/s_axi_control]
  connect_bd_intf_net -intf_net axi_interconnect_M08_AXI [get_bd_intf_pins axi_interconnect/M08_AXI] [get_bd_intf_pins video/s_axi_control1]
  connect_bd_intf_net -intf_net axi_interconnect_M09_AXI [get_bd_intf_pins axi_interconnect/M09_AXI] [get_bd_intf_pins video/s_axi_control2]
  connect_bd_intf_net -intf_net axi_interconnect_M10_AXI [get_bd_intf_pins axi_interconnect/M10_AXI] [get_bd_intf_pins video/s_axi_control3]
  connect_bd_intf_net -intf_net axi_interconnect_M11_AXI [get_bd_intf_pins axi_interconnect/M11_AXI] [get_bd_intf_pins iop_pmod0/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_M12_AXI [get_bd_intf_pins axi_interconnect/M12_AXI] [get_bd_intf_pins iop_pmod1/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_M13_AXI [get_bd_intf_pins axi_interconnect/M13_AXI] [get_bd_intf_pins gpio_sws/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_M14_AXI [get_bd_intf_pins axi_interconnect/M14_AXI] [get_bd_intf_pins gpio_btns/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_M15_AXI [get_bd_intf_pins axi_interconnect/M15_AXI] [get_bd_intf_pins gpio_leds/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_M16_AXI [get_bd_intf_pins axi_interconnect/M16_AXI] [get_bd_intf_pins shutdown_HP0_FPD/S_AXI_CTRL]
  connect_bd_intf_net -intf_net axi_interconnect_M17_AXI [get_bd_intf_pins axi_interconnect/M17_AXI] [get_bd_intf_pins shutdown_LPD/S_AXI_CTRL]
  connect_bd_intf_net -intf_net axi_interconnect_M18_AXI [get_bd_intf_pins axi_interconnect/M18_AXI] [get_bd_intf_pins shutdown_HP2_FPD/S_AXI_CTRL]
  connect_bd_intf_net -intf_net axi_interconnect_M19_AXI [get_bd_intf_pins axi_interconnect/M19_AXI] [get_bd_intf_pins rgbleds/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_M20_AXI [get_bd_intf_pins axi_interconnect/M20_AXI] [get_bd_intf_pins iop_grove/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_M21_AXI [get_bd_intf_pins audio_codec_ctrl_0/S_AXI] [get_bd_intf_pins axi_interconnect/M21_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_M22_AXI [get_bd_intf_pins axi_interconnect/M22_AXI] [get_bd_intf_pins iop_rpi/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_M23_AXI [get_bd_intf_pins axi_interconnect/M23_AXI] [get_bd_intf_pins system_management_wiz_0/S_AXI_LITE]
  connect_bd_intf_net -intf_net axi_interconnect_M24_AXI [get_bd_intf_pins axi_interconnect/M24_AXI] [get_bd_intf_pins hdmi_tx_control/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_M25_AXI [get_bd_intf_pins axi_interconnect/M25_AXI] [get_bd_intf_pins mipi/S_AXI_LITE]
  connect_bd_intf_net -intf_net axi_interconnect_M26_AXI [get_bd_intf_pins axi_interconnect/M26_AXI] [get_bd_intf_pins shutdown_HP1_FPD/S_AXI_CTRL]
  connect_bd_intf_net -intf_net axi_mem_intercon_1_M00_AXI [get_bd_intf_pins axi_mem_intercon_1/M00_AXI] [get_bd_intf_pins shutdown_HP2_FPD/S_AXI]
  connect_bd_intf_net -intf_net axi_mem_intercon_M00_AXI [get_bd_intf_pins axi_mem_intercon/M00_AXI] [get_bd_intf_pins shutdown_HP0_FPD/S_AXI]
  connect_bd_intf_net -intf_net mipi_M00_AXI [get_bd_intf_pins mipi/M00_AXI] [get_bd_intf_pins shutdown_HP1_FPD/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_0_M_AXI [get_bd_intf_pins axi_register_slice_0/M_AXI] [get_bd_intf_pins shutdown_LPD/S_AXI]
  connect_bd_intf_net -intf_net axi_smc_M00_AXI [get_bd_intf_pins axi_smc/M00_AXI] [get_bd_intf_pins ps_e_0/S_AXI_HP3_FPD]
  connect_bd_intf_net -intf_net axi_vdma_0_M_AXI_MM2S [get_bd_intf_pins axi_mem_intercon/S00_AXI] [get_bd_intf_pins video/M_AXI_MM2S]
  connect_bd_intf_net -intf_net axi_vdma_0_M_AXI_S2MM [get_bd_intf_pins axi_mem_intercon_1/S00_AXI] [get_bd_intf_pins video/M_AXI_S2MM]
  connect_bd_intf_net -intf_net intf_net_axi_interconnect_M04_AXI [get_bd_intf_pins HDMI_CTL_axi_iic/S_AXI] [get_bd_intf_pins axi_interconnect/M04_AXI]
  connect_bd_intf_net -intf_net intf_net_v_hdmi_rx_ss_DDC_OUT [get_bd_intf_ports RX_DDC_OUT] [get_bd_intf_pins video/RX_DDC_OUT]
  connect_bd_intf_net -intf_net intf_net_v_hdmi_tx_ss_DDC_OUT [get_bd_intf_ports TX_DDC_OUT] [get_bd_intf_pins video/TX_DDC_OUT]
  connect_bd_intf_net -intf_net intf_net_zynq_us_M_AXI_HPM0_LPD [get_bd_intf_pins axi_interconnect/S00_AXI] [get_bd_intf_pins ps_e_0/M_AXI_HPM0_LPD]
  connect_bd_intf_net -intf_net intf_net_zynq_us_ss_0_IIC [get_bd_intf_ports HDMI_CTL_iic] [get_bd_intf_pins HDMI_CTL_axi_iic/IIC]
  connect_bd_intf_net -intf_net intf_net_zynq_us_ss_0_M00_AXI [get_bd_intf_pins axi_interconnect/M00_AXI] [get_bd_intf_pins video/vid_phy_axi4lite]
  connect_bd_intf_net -intf_net intf_net_zynq_us_ss_0_M01_AXI [get_bd_intf_pins axi_interconnect/M01_AXI] [get_bd_intf_pins video/S_AXI_CPU_IN]
  connect_bd_intf_net -intf_net intf_net_zynq_us_ss_0_M02_AXI [get_bd_intf_pins axi_interconnect/M02_AXI] [get_bd_intf_pins video/S_AXI_CPU_IN1]
  connect_bd_intf_net -intf_net iop_pl_grove0_M_AXI [get_bd_intf_pins axi_interconnect_0/S03_AXI] [get_bd_intf_pins iop_grove/M_AXI]
  connect_bd_intf_net -intf_net iop_rpi_M_AXI [get_bd_intf_pins axi_interconnect_0/S02_AXI] [get_bd_intf_pins iop_rpi/M_AXI]
  connect_bd_intf_net -intf_net mdm_0_MBDEBUG_0 [get_bd_intf_pins iop_pmod0/DEBUG] [get_bd_intf_pins mdm/MBDEBUG_0]
  connect_bd_intf_net -intf_net mdm_0_MBDEBUG_1 [get_bd_intf_pins iop_pmod1/DEBUG] [get_bd_intf_pins mdm/MBDEBUG_1]
  connect_bd_intf_net -intf_net mdm_MBDEBUG_2 [get_bd_intf_pins iop_rpi/DEBUG] [get_bd_intf_pins mdm/MBDEBUG_2]
  connect_bd_intf_net -intf_net mdm_MBDEBUG_3 [get_bd_intf_pins iop_grove/DEBUG] [get_bd_intf_pins mdm/MBDEBUG_3]
  connect_bd_intf_net -intf_net mipi_cam_gpio [get_bd_intf_ports cam_gpio] [get_bd_intf_pins mipi/cam_gpio]
  connect_bd_intf_net -intf_net mipi_phy_if_0_1 [get_bd_intf_ports mipi_phy_if_0] [get_bd_intf_pins mipi/mipi_phy_if_0]
  connect_bd_intf_net -intf_net pmod0_M_AXI [get_bd_intf_pins axi_interconnect_0/S00_AXI] [get_bd_intf_pins iop_pmod0/M_AXI]
  connect_bd_intf_net -intf_net pmod1_M_AXI [get_bd_intf_pins axi_interconnect_0/S01_AXI] [get_bd_intf_pins iop_pmod1/M_AXI]
  connect_bd_intf_net -intf_net pr_axi_shutdown_mana_0_M_AXI [get_bd_intf_pins ps_e_0/S_AXI_LPD] [get_bd_intf_pins shutdown_LPD/M_AXI]
  connect_bd_intf_net -intf_net ps_e_0_M_AXI_HPM0_FPD [get_bd_intf_pins ps_e_0/M_AXI_HPM0_FPD] [get_bd_intf_pins ps_e_0_axi_periph/S00_AXI]
  connect_bd_intf_net -intf_net ps_e_0_axi_periph_M00_AXI [get_bd_intf_pins ps_e_0_axi_periph/M00_AXI] [get_bd_intf_pins trace_analyzer_pi/s_axi_trace_cntrl]
  connect_bd_intf_net -intf_net ps_e_0_axi_periph_M01_AXI [get_bd_intf_pins ps_e_0_axi_periph/M01_AXI] [get_bd_intf_pins trace_analyzer_pi/S_AXI_LITE]
  connect_bd_intf_net -intf_net ps_e_0_axi_periph_M02_AXI [get_bd_intf_pins ps_e_0_axi_periph/M02_AXI] [get_bd_intf_pins trace_analyzer_pmod0/S_AXI_LITE]
  connect_bd_intf_net -intf_net ps_e_0_axi_periph_M03_AXI [get_bd_intf_pins ps_e_0_axi_periph/M03_AXI] [get_bd_intf_pins trace_analyzer_pmod1/S_AXI_LITE]
  connect_bd_intf_net -intf_net ps_e_0_axi_periph_M04_AXI [get_bd_intf_pins ps_e_0_axi_periph/M04_AXI] [get_bd_intf_pins trace_analyzer_pmod0/s_axi_trace_cntrl]
  connect_bd_intf_net -intf_net ps_e_0_axi_periph_M05_AXI [get_bd_intf_pins ps_e_0_axi_periph/M05_AXI] [get_bd_intf_pins trace_analyzer_pmod1/s_axi_trace_cntrl]
  connect_bd_intf_net -intf_net ps_e_0_axi_periph_M06_AXI [get_bd_intf_pins mipi/s_axi_CTRL] [get_bd_intf_pins ps_e_0_axi_periph/M06_AXI]
  connect_bd_intf_net -intf_net ps_e_0_axi_periph_M07_AXI [get_bd_intf_pins axi_interconnect_1/S00_AXI] [get_bd_intf_pins ps_e_0_axi_periph/M07_AXI]
  connect_bd_intf_net -intf_net rgbleds_GPIO [get_bd_intf_ports rgbleds] [get_bd_intf_pins rgbleds/GPIO]
  connect_bd_intf_net -intf_net shutdown_HP0_M_AXI [get_bd_intf_pins ps_e_0/S_AXI_HP0_FPD] [get_bd_intf_pins shutdown_HP0_FPD/M_AXI]
  connect_bd_intf_net -intf_net shutdown_HP1_M_AXI [get_bd_intf_pins ps_e_0/S_AXI_HP1_FPD] [get_bd_intf_pins shutdown_HP1_FPD/M_AXI]
  connect_bd_intf_net -intf_net shutdown_HP2_M_AXI [get_bd_intf_pins ps_e_0/S_AXI_HP2_FPD] [get_bd_intf_pins shutdown_HP2_FPD/M_AXI]
  connect_bd_intf_net -intf_net trace_analyzer_pi_M_AXI_S2MM [get_bd_intf_pins axi_smc/S00_AXI] [get_bd_intf_pins trace_analyzer_pi/M_AXI_S2MM]
  connect_bd_intf_net -intf_net trace_analyzer_pmod0_M_AXI_S2MM [get_bd_intf_pins axi_smc/S01_AXI] [get_bd_intf_pins trace_analyzer_pmod0/M_AXI_S2MM]
  connect_bd_intf_net -intf_net trace_analyzer_pmod1_M_AXI_S2MM [get_bd_intf_pins axi_smc/S02_AXI] [get_bd_intf_pins trace_analyzer_pmod1/M_AXI_S2MM]
  connect_bd_intf_net -intf_net zynq_us_ss_0_M03_AXI [get_bd_intf_pins axi_interconnect/M03_AXI] [get_bd_intf_pins video/S_AXI_LITE]

  # Create port connections
  connect_bd_net -net ARESETN_1 [get_bd_pins axi_interconnect_1/ARESETN] [get_bd_pins axi_mem_intercon/ARESETN] [get_bd_pins axi_mem_intercon_1/ARESETN] [get_bd_pins proc_sys_reset_1/interconnect_aresetn]
  connect_bd_net -net Net [get_bd_ports pmod0] [get_bd_pins pmod0_buf/IOBUF_IO_IO]
  connect_bd_net -net Net1 [get_bd_ports pmod1] [get_bd_pins pmod1_buf/IOBUF_IO_IO]
  connect_bd_net -net Net2 [get_bd_ports rpi] [get_bd_pins rpi_buf/IOBUF_IO_IO]
  connect_bd_net -net Net3 [get_bd_ports pl_groves] [get_bd_pins grove0_buf/IOBUF_IO_IO]
  connect_bd_net -net audio_codec_ctrl_0_audio_codec_bclk [get_bd_ports audio_codec_bclk] [get_bd_pins audio_codec_ctrl_0/bclk]
  connect_bd_net -net audio_codec_ctrl_0_audio_codec_lrclk [get_bd_ports audio_codec_lrclk] [get_bd_pins audio_codec_ctrl_0/lrclk]
  connect_bd_net -net audio_codec_ctrl_0_audio_codec_sdata_o [get_bd_ports audio_codec_sdata_o] [get_bd_pins audio_codec_ctrl_0/sdata_o]
  connect_bd_net -net audio_codec_ctrl_0_codec_address [get_bd_ports codec_addr] [get_bd_pins audio_codec_ctrl_0/codec_address]
  connect_bd_net -net audio_codec_sdata_i_0 [get_bd_ports audio_codec_sdata_i] [get_bd_pins audio_codec_ctrl_0/sdata_i]
  connect_bd_net -net axi_gpio_0_gpio_io_o [get_bd_pins hdmi_tx_control/gpio2_io_o] [get_bd_pins xlslice_0/Din] [get_bd_pins xlslice_1/Din]
  connect_bd_net -net axi_intc_0_irq [get_bd_pins axi_intc_0/irq] [get_bd_pins xlconcat_0/In0]
  connect_bd_net -net axi_vdma_0_mm2s_introut [get_bd_pins video/mm2s_introut] [get_bd_pins xlconcat0/In4]
  connect_bd_net -net axi_vdma_0_s2mm_introut [get_bd_pins video/s2mm_introut] [get_bd_pins xlconcat0/In3]
  connect_bd_net -net clk_wiz_0_clk_out1 [get_bd_pins clk_wiz_0/clk_out1] [get_bd_pins mipi/dphy_clk_200M] [get_bd_pins rst_clk_wiz_1_200M/slowest_sync_clk]
  connect_bd_net -net clk_wiz_0_locked [get_bd_pins clk_wiz_0/locked] [get_bd_pins mipi/aresetn] [get_bd_pins rst_clk_wiz_1_200M/aux_reset_in] [get_bd_pins rst_clk_wiz_1_200M/dcm_locked] [get_bd_pins rst_clk_wiz_1_200M/ext_reset_in]
  connect_bd_net -net clk_wiz_10MHz_clk_out1 [get_bd_ports audio_codec_clk_10MHz] [get_bd_pins clk_wiz_10MHz/clk_out1]
  connect_bd_net -net concat_pmod0_dout [get_bd_pins concat_pmod0/dout] [get_bd_pins trace_analyzer_pmod0/data]
  connect_bd_net -net concat_pmod1_dout [get_bd_pins concat_pmod1/dout] [get_bd_pins trace_analyzer_pmod1/data]
  connect_bd_net -net concat_rp_dout [get_bd_pins concat_rp/dout] [get_bd_pins trace_analyzer_pi/data]
  connect_bd_net -net constant_10bit_0_dout [get_bd_pins constant_10bit_0/dout] [get_bd_pins xlconcat_1/In0]
  connect_bd_net -net constant_8bit_0_dout [get_bd_pins concat_pmod0/In2] [get_bd_pins concat_pmod0/In3] [get_bd_pins concat_pmod1/In2] [get_bd_pins concat_pmod1/In3] [get_bd_pins concat_rp/In2] [get_bd_pins constant_8bit_0/dout]
  connect_bd_net -net data_i_1 [get_bd_pins concat_pmod0/In0] [get_bd_pins iop_pmod0/data_i] [get_bd_pins pmod0_buf/IOBUF_IO_O]
  connect_bd_net -net data_i_2 [get_bd_pins concat_pmod1/In0] [get_bd_pins iop_pmod1/data_i] [get_bd_pins pmod1_buf/IOBUF_IO_O]
  connect_bd_net -net data_i_3 [get_bd_pins grove0_buf/IOBUF_IO_O] [get_bd_pins iop_grove/data_i]
  connect_bd_net -net gpio_btns_ip2intc_irpt [get_bd_pins gpio_btns/ip2intc_irpt] [get_bd_pins xlconcat0/In8]
  connect_bd_net -net gpio_sws_ip2intc_irpt [get_bd_pins gpio_sws/ip2intc_irpt] [get_bd_pins xlconcat0/In7]
  connect_bd_net -net iop_grove0_data_o [get_bd_pins grove0_buf/IOBUF_IO_I] [get_bd_pins iop_grove/data_o]
  connect_bd_net -net iop_grove0_tri_o [get_bd_pins grove0_buf/IOBUF_IO_T] [get_bd_pins iop_grove/tri_o]
  connect_bd_net -net iop_pl_grove0_intr_req [get_bd_pins iop_grove/intr_req] [get_bd_pins xlconcat0/In10]
  connect_bd_net -net iop_pl_grove0_peripheral_aresetn [get_bd_pins axi_interconnect_0/S03_ARESETN] [get_bd_pins iop_grove/peripheral_aresetn]
  connect_bd_net -net iop_pmod0_peripheral_aresetn [get_bd_pins axi_interconnect_0/S00_ARESETN] [get_bd_pins iop_pmod0/peripheral_aresetn]
  connect_bd_net -net iop_rpi_data_o [get_bd_pins iop_rpi/data_o] [get_bd_pins rpi_buf/IOBUF_IO_I]
  connect_bd_net -net iop_rpi_intr_req [get_bd_pins iop_rpi/intr_req] [get_bd_pins xlconcat0/In9]
  connect_bd_net -net iop_rpi_peripheral_aresetn [get_bd_pins axi_interconnect_0/S02_ARESETN] [get_bd_pins iop_rpi/peripheral_aresetn]
  connect_bd_net -net iop_rpi_tri_o [get_bd_pins concat_rp/In1] [get_bd_pins iop_rpi/tri_o] [get_bd_pins rpi_buf/IOBUF_IO_T]
  connect_bd_net -net logic_1_dout [get_bd_pins logic_1/dout] [get_bd_pins trace_analyzer_pi/valid] [get_bd_pins trace_analyzer_pmod0/valid] [get_bd_pins trace_analyzer_pmod1/valid]
  connect_bd_net -net mb_iop_grove0_intr_ack_Dout [get_bd_pins iop_grove/intr_ack] [get_bd_pins mb_iop_grove_intr_ack/Dout]
  connect_bd_net -net mb_iop_grove0_reset_Dout [get_bd_pins iop_grove/aux_reset_in] [get_bd_pins mb_iop_grove_reset/Dout]
  connect_bd_net -net mb_iop_rpi_intr_ack_Dout [get_bd_pins iop_rpi/intr_ack] [get_bd_pins mb_iop_rpi_intr_ack/Dout]
  connect_bd_net -net mb_iop_rpi_reset_Dout [get_bd_pins iop_rpi/aux_reset_in] [get_bd_pins mb_iop_rpi_reset/Dout]
  connect_bd_net -net mb_pmod1_intr_ack_Dout [get_bd_pins iop_pmod1/intr_ack] [get_bd_pins mb_iop_pmod1_intr_ack/Dout]
  connect_bd_net -net mb_pmod1_reset_Dout [get_bd_pins iop_pmod1/aux_reset_in] [get_bd_pins mb_iop_pmod1_reset/Dout]
  connect_bd_net -net mdm_0_Debug_SYS_Rst [get_bd_pins iop_grove/mb_debug_sys_rst] [get_bd_pins iop_pmod0/mb_debug_sys_rst] [get_bd_pins iop_pmod1/mb_debug_sys_rst] [get_bd_pins iop_rpi/mb_debug_sys_rst] [get_bd_pins mdm/Debug_SYS_Rst]
  connect_bd_net -net mipi_csi2_rx_subsyst_0_csirxss_csi_irq [get_bd_pins mipi/csirxss_csi_irq] [get_bd_pins xlconcat0/In11]
  connect_bd_net -net mipi_s2mm_introut [get_bd_pins mipi/s2mm_introut] [get_bd_pins xlconcat0/In15]
  connect_bd_net -net net_bdry_in_HDMI_RX_CLK_N_IN [get_bd_ports HDMI_RX_CLK_N_IN] [get_bd_pins video/HDMI_RX_CLK_N_IN]
  connect_bd_net -net net_bdry_in_HDMI_RX_CLK_P_IN [get_bd_ports HDMI_RX_CLK_P_IN] [get_bd_pins video/HDMI_RX_CLK_P_IN]
  connect_bd_net -net net_bdry_in_HDMI_RX_DAT_N_IN [get_bd_ports HDMI_RX_DAT_N_IN] [get_bd_pins video/HDMI_RX_DAT_N_IN]
  connect_bd_net -net net_bdry_in_HDMI_RX_DAT_P_IN [get_bd_ports HDMI_RX_DAT_P_IN] [get_bd_pins video/HDMI_RX_DAT_P_IN]
  connect_bd_net -net net_bdry_in_HDMI_SI5324_LOL_IN [get_bd_ports HDMI_SI5324_LOL_IN] [get_bd_pins video/HDMI_SI5324_LOL_IN]
  connect_bd_net -net net_bdry_in_RX_DET_IN [get_bd_ports RX_DET_IN] [get_bd_pins video/RX_DET_IN]
  connect_bd_net -net net_bdry_in_TX_HPD_IN [get_bd_ports TX_HPD_IN] [get_bd_pins video/TX_HPD_IN]
  connect_bd_net -net net_bdry_in_TX_REFCLK_N_IN [get_bd_ports TX_REFCLK_N_IN] [get_bd_pins video/TX_REFCLK_N_IN]
  connect_bd_net -net net_bdry_in_TX_REFCLK_P_IN [get_bd_ports TX_REFCLK_P_IN] [get_bd_pins video/TX_REFCLK_P_IN]
  connect_bd_net -net net_bdry_in_reset [get_bd_pins proc_sys_reset_0/aux_reset_in] [get_bd_pins proc_sys_reset_0/dcm_locked] [get_bd_pins proc_sys_reset_0/ext_reset_in] [get_bd_pins proc_sys_reset_1/aux_reset_in] [get_bd_pins proc_sys_reset_1/dcm_locked] [get_bd_pins proc_sys_reset_1/ext_reset_in] [get_bd_pins proc_sys_reset_2/aux_reset_in] [get_bd_pins proc_sys_reset_2/dcm_locked] [get_bd_pins proc_sys_reset_2/ext_reset_in] [get_bd_pins proc_sys_reset_3/aux_reset_in] [get_bd_pins proc_sys_reset_3/dcm_locked] [get_bd_pins proc_sys_reset_3/ext_reset_in] [get_bd_pins ps_e_0/pl_resetn0]
  connect_bd_net -net net_rst_processor_1_100M_interconnect_aresetn [get_bd_pins axi_interconnect/ARESETN] [get_bd_pins axi_interconnect_0/ARESETN] [get_bd_pins proc_sys_reset_0/interconnect_aresetn]
  connect_bd_net -net net_v_hdmi_rx_ss_hpd [get_bd_ports RX_HPD_OUT] [get_bd_pins video/RX_HPD_OUT]
  connect_bd_net -net net_v_hdmi_rx_ss_irq [get_bd_pins video/irq] [get_bd_pins xlconcat0/In1]
  connect_bd_net -net net_v_hdmi_tx_ss_irq [get_bd_pins video/irq1] [get_bd_pins xlconcat0/In2]
  connect_bd_net -net net_vcc_const_dout [get_bd_ports TX_EN_OUT] [get_bd_pins hdmi_tx_control/gpio_io_o] [get_bd_pins video/TX_EN_OUT]
  connect_bd_net -net net_vid_phy_controller_irq [get_bd_pins video/irq2] [get_bd_pins xlconcat0/In0]
  connect_bd_net -net net_vid_phy_controller_phy_txn_out [get_bd_ports HDMI_TX_DAT_N_OUT] [get_bd_pins video/HDMI_TX_DAT_N_OUT]
  connect_bd_net -net net_vid_phy_controller_phy_txp_out [get_bd_ports HDMI_TX_DAT_P_OUT] [get_bd_pins video/HDMI_TX_DAT_P_OUT]
  connect_bd_net -net net_vid_phy_controller_rx_tmds_clk_n [get_bd_ports RX_REFCLK_N_OUT] [get_bd_pins video/RX_REFCLK_N_OUT]
  connect_bd_net -net net_vid_phy_controller_rx_tmds_clk_p [get_bd_ports RX_REFCLK_P_OUT] [get_bd_pins video/RX_REFCLK_P_OUT]
  connect_bd_net -net net_vid_phy_controller_tx_tmds_clk_n [get_bd_ports HDMI_TX_CLK_N_OUT] [get_bd_pins video/HDMI_TX_CLK_N_OUT]
  connect_bd_net -net net_vid_phy_controller_tx_tmds_clk_p [get_bd_ports HDMI_TX_CLK_P_OUT] [get_bd_pins video/HDMI_TX_CLK_P_OUT]
  connect_bd_net -net net_zynq_us_ss_0_clk_out2 [get_bd_pins axi_interconnect/M07_ACLK] [get_bd_pins axi_interconnect/M08_ACLK] [get_bd_pins axi_interconnect/M09_ACLK] [get_bd_pins axi_interconnect/M10_ACLK] [get_bd_pins axi_interconnect/M16_ACLK] [get_bd_pins axi_interconnect/M18_ACLK] [get_bd_pins axi_interconnect/M26_ACLK] [get_bd_pins axi_interconnect_1/ACLK] [get_bd_pins axi_interconnect_1/M00_ACLK] [get_bd_pins axi_interconnect_1/M01_ACLK] [get_bd_pins axi_interconnect_1/M02_ACLK] [get_bd_pins axi_interconnect_1/M03_ACLK] [get_bd_pins axi_interconnect_1/S00_ACLK] [get_bd_pins axi_mem_intercon/ACLK] [get_bd_pins axi_mem_intercon/M00_ACLK] [get_bd_pins axi_mem_intercon/S00_ACLK] [get_bd_pins axi_mem_intercon_1/ACLK] [get_bd_pins axi_mem_intercon_1/M00_ACLK] [get_bd_pins axi_mem_intercon_1/S00_ACLK] [get_bd_pins mipi/video_aclk] [get_bd_pins proc_sys_reset_1/slowest_sync_clk] [get_bd_pins ps_e_0/pl_clk1] [get_bd_pins ps_e_0/saxihp0_fpd_aclk] [get_bd_pins ps_e_0/saxihp1_fpd_aclk] [get_bd_pins ps_e_0/saxihp2_fpd_aclk] [get_bd_pins ps_e_0_axi_periph/M06_ACLK] [get_bd_pins ps_e_0_axi_periph/M07_ACLK] [get_bd_pins shutdown_HP0_FPD/clk] [get_bd_pins shutdown_HP1_FPD/clk] [get_bd_pins shutdown_HP2_FPD/clk] [get_bd_pins video/aclk]
  connect_bd_net -net net_zynq_us_ss_0_dcm_locked [get_bd_pins axi_interconnect/M07_ARESETN] [get_bd_pins axi_interconnect/M08_ARESETN] [get_bd_pins axi_interconnect/M09_ARESETN] [get_bd_pins axi_interconnect/M10_ARESETN] [get_bd_pins axi_interconnect/M16_ARESETN] [get_bd_pins axi_interconnect/M18_ARESETN] [get_bd_pins axi_interconnect/M26_ARESETN] [get_bd_pins axi_interconnect_1/M00_ARESETN] [get_bd_pins axi_interconnect_1/M01_ARESETN] [get_bd_pins axi_interconnect_1/M02_ARESETN] [get_bd_pins axi_interconnect_1/M03_ARESETN] [get_bd_pins axi_interconnect_1/S00_ARESETN] [get_bd_pins axi_mem_intercon/M00_ARESETN] [get_bd_pins axi_mem_intercon/S00_ARESETN] [get_bd_pins axi_mem_intercon_1/M00_ARESETN] [get_bd_pins axi_mem_intercon_1/S00_ARESETN] [get_bd_pins mipi/video_aresetn] [get_bd_pins proc_sys_reset_1/peripheral_aresetn] [get_bd_pins ps_e_0_axi_periph/M06_ARESETN] [get_bd_pins ps_e_0_axi_periph/M07_ARESETN] [get_bd_pins shutdown_HP0_FPD/resetn] [get_bd_pins shutdown_HP1_FPD/resetn] [get_bd_pins shutdown_HP2_FPD/resetn] [get_bd_pins video/aresetn]
  connect_bd_net -net net_zynq_us_ss_0_peripheral_aresetn [get_bd_pins HDMI_CTL_axi_iic/s_axi_aresetn] [get_bd_pins audio_codec_ctrl_0/s_axi_aresetn] [get_bd_pins axi_intc_0/s_axi_aresetn] [get_bd_pins axi_interconnect/M00_ARESETN] [get_bd_pins axi_interconnect/M01_ARESETN] [get_bd_pins axi_interconnect/M02_ARESETN] [get_bd_pins axi_interconnect/M03_ARESETN] [get_bd_pins axi_interconnect/M04_ARESETN] [get_bd_pins axi_interconnect/M05_ARESETN] [get_bd_pins axi_interconnect/M06_ARESETN] [get_bd_pins axi_interconnect/M11_ARESETN] [get_bd_pins axi_interconnect/M12_ARESETN] [get_bd_pins axi_interconnect/M13_ARESETN] [get_bd_pins axi_interconnect/M14_ARESETN] [get_bd_pins axi_interconnect/M15_ARESETN] [get_bd_pins axi_interconnect/M17_ARESETN] [get_bd_pins axi_interconnect/M19_ARESETN] [get_bd_pins axi_interconnect/M20_ARESETN] [get_bd_pins axi_interconnect/M21_ARESETN] [get_bd_pins axi_interconnect/M22_ARESETN] [get_bd_pins axi_interconnect/M23_ARESETN] [get_bd_pins axi_interconnect/M24_ARESETN] [get_bd_pins axi_interconnect/M25_ARESETN] [get_bd_pins axi_interconnect/S00_ARESETN] [get_bd_pins axi_interconnect_0/M00_ARESETN] [get_bd_pins clk_wiz_10MHz/resetn] [get_bd_pins gpio_btns/s_axi_aresetn] [get_bd_pins gpio_leds/s_axi_aresetn] [get_bd_pins gpio_sws/s_axi_aresetn] [get_bd_pins iop_grove/s_axi_aresetn] [get_bd_pins iop_pmod0/s_axi_aresetn] [get_bd_pins iop_pmod1/s_axi_aresetn] [get_bd_pins iop_rpi/s_axi_aresetn] [get_bd_pins mipi/lite_aresetn] [get_bd_pins proc_sys_reset_0/peripheral_aresetn] [get_bd_pins rgbleds/s_axi_aresetn] [get_bd_pins system_management_wiz_0/s_axi_aresetn] [get_bd_pins hdmi_tx_control/s_axi_aresetn] [get_bd_pins video/s_axi_cpu_aresetn]
  connect_bd_net -net net_zynq_us_ss_0_s_axi_aclk [get_bd_pins HDMI_CTL_axi_iic/s_axi_aclk] [get_bd_pins address_remap_0/m_axi_out_aclk] [get_bd_pins address_remap_0/s_axi_in_aclk] [get_bd_pins audio_codec_ctrl_0/s_axi_aclk] [get_bd_pins axi_intc_0/s_axi_aclk] [get_bd_pins axi_interconnect/ACLK] [get_bd_pins axi_interconnect/M00_ACLK] [get_bd_pins axi_interconnect/M01_ACLK] [get_bd_pins axi_interconnect/M02_ACLK] [get_bd_pins axi_interconnect/M03_ACLK] [get_bd_pins axi_interconnect/M04_ACLK] [get_bd_pins axi_interconnect/M05_ACLK] [get_bd_pins axi_interconnect/M06_ACLK] [get_bd_pins axi_interconnect/M11_ACLK] [get_bd_pins axi_interconnect/M12_ACLK] [get_bd_pins axi_interconnect/M13_ACLK] [get_bd_pins axi_interconnect/M14_ACLK] [get_bd_pins axi_interconnect/M15_ACLK] [get_bd_pins axi_interconnect/M17_ACLK] [get_bd_pins axi_interconnect/M19_ACLK] [get_bd_pins axi_interconnect/M20_ACLK] [get_bd_pins axi_interconnect/M21_ACLK] [get_bd_pins axi_interconnect/M22_ACLK] [get_bd_pins axi_interconnect/M23_ACLK] [get_bd_pins axi_interconnect/M24_ACLK] [get_bd_pins axi_interconnect/M25_ACLK] [get_bd_pins axi_interconnect/S00_ACLK] [get_bd_pins axi_interconnect_0/ACLK] [get_bd_pins axi_interconnect_0/M00_ACLK] [get_bd_pins axi_interconnect_0/S00_ACLK] [get_bd_pins axi_interconnect_0/S01_ACLK] [get_bd_pins axi_interconnect_0/S02_ACLK] [get_bd_pins axi_interconnect_0/S03_ACLK] [get_bd_pins axi_register_slice_0/aclk] [get_bd_pins clk_wiz_0/clk_in1] [get_bd_pins clk_wiz_10MHz/clk_in1] [get_bd_pins gpio_btns/s_axi_aclk] [get_bd_pins gpio_leds/s_axi_aclk] [get_bd_pins gpio_sws/s_axi_aclk] [get_bd_pins iop_grove/clk_100M] [get_bd_pins iop_pmod0/clk_100M] [get_bd_pins iop_pmod1/clk_100M] [get_bd_pins iop_rpi/clk_100M] [get_bd_pins mipi/lite_aclk] [get_bd_pins proc_sys_reset_0/slowest_sync_clk] [get_bd_pins ps_e_0/maxihpm0_lpd_aclk] [get_bd_pins ps_e_0/pl_clk0] [get_bd_pins ps_e_0/saxi_lpd_aclk] [get_bd_pins rgbleds/s_axi_aclk] [get_bd_pins shutdown_LPD/clk] [get_bd_pins system_management_wiz_0/s_axi_aclk] [get_bd_pins hdmi_tx_control/s_axi_aclk] [get_bd_pins video/s_axi_cpu_aclk]
  connect_bd_net -net pmod0_data_o [get_bd_pins iop_pmod0/data_o] [get_bd_pins pmod0_buf/IOBUF_IO_I]
  connect_bd_net -net pmod0_intr_req [get_bd_pins iop_pmod0/intr_req] [get_bd_pins xlconcat0/In5]
  connect_bd_net -net pmod0_intr_req_Dout [get_bd_pins iop_pmod0/intr_ack] [get_bd_pins mb_iop_pmod0_intr_ack/Dout]
  connect_bd_net -net pmod0_reset_Dout [get_bd_pins iop_pmod0/aux_reset_in] [get_bd_pins mb_iop_pmod0_reset/Dout]
  connect_bd_net -net pmod0_tri_o [get_bd_pins concat_pmod0/In1] [get_bd_pins iop_pmod0/tri_o] [get_bd_pins pmod0_buf/IOBUF_IO_T]
  connect_bd_net -net pmod1_data_o [get_bd_pins iop_pmod1/data_o] [get_bd_pins pmod1_buf/IOBUF_IO_I]
  connect_bd_net -net pmod1_intr_req [get_bd_pins iop_pmod1/intr_req] [get_bd_pins xlconcat0/In6]
  connect_bd_net -net pmod1_peripheral_aresetn [get_bd_pins address_remap_0/m_axi_out_aresetn] [get_bd_pins address_remap_0/s_axi_in_aresetn] [get_bd_pins axi_interconnect_0/S01_ARESETN] [get_bd_pins axi_register_slice_0/aresetn] [get_bd_pins iop_pmod1/peripheral_aresetn] [get_bd_pins shutdown_LPD/resetn]
  connect_bd_net -net pmod1_tri_o [get_bd_pins concat_pmod1/In1] [get_bd_pins iop_pmod1/tri_o] [get_bd_pins pmod1_buf/IOBUF_IO_T]
  connect_bd_net -net proc_sys_reset_3_peripheral_aresetn [get_bd_pins axi_smc/aresetn] [get_bd_pins proc_sys_reset_3/peripheral_aresetn] [get_bd_pins ps_e_0_axi_periph/ARESETN] [get_bd_pins ps_e_0_axi_periph/M00_ARESETN] [get_bd_pins ps_e_0_axi_periph/M01_ARESETN] [get_bd_pins ps_e_0_axi_periph/M02_ARESETN] [get_bd_pins ps_e_0_axi_periph/M03_ARESETN] [get_bd_pins ps_e_0_axi_periph/M04_ARESETN] [get_bd_pins ps_e_0_axi_periph/M05_ARESETN] [get_bd_pins ps_e_0_axi_periph/S00_ARESETN] [get_bd_pins trace_analyzer_pi/axi_resetn] [get_bd_pins trace_analyzer_pmod0/axi_resetn] [get_bd_pins trace_analyzer_pmod1/axi_resetn]
  connect_bd_net -net rpi_buf_IOBUF_IO_O [get_bd_pins concat_rp/In0] [get_bd_pins iop_rpi/data_i] [get_bd_pins rpi_buf/IOBUF_IO_O]
  connect_bd_net -net syzygy_pg_1 [get_bd_ports syzygy_pg] [get_bd_pins xlconcat_1/In1]
  connect_bd_net -net trace_analyzer_pi_s2mm_introut [get_bd_pins trace_analyzer_pi/s2mm_introut] [get_bd_pins xlconcat0/In12]
  connect_bd_net -net trace_analyzer_pmod0_s2mm_introut [get_bd_pins trace_analyzer_pmod0/s2mm_introut] [get_bd_pins xlconcat0/In13]
  connect_bd_net -net trace_analyzer_pmod1_s2mm_introut [get_bd_pins trace_analyzer_pmod1/s2mm_introut] [get_bd_pins xlconcat0/In14]
  connect_bd_net -net xlconcat0_dout [get_bd_pins axi_intc_0/intr] [get_bd_pins xlconcat0/dout]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins ps_e_0/pl_ps_irq0] [get_bd_pins xlconcat_0/dout]
  connect_bd_net -net xlconcat_1_dout [get_bd_pins ps_e_0/emio_gpio_i] [get_bd_pins xlconcat_1/dout]
  connect_bd_net -net xlslice_0_Dout [get_bd_ports HDMI_SI5324_RST_OUT] [get_bd_pins xlslice_0/Dout]
  connect_bd_net -net xlslice_1_Dout [get_bd_ports HDMI_TX_LS_OE] [get_bd_pins xlslice_1/Dout]
  connect_bd_net -net zynq_us_emio_gpio_o [get_bd_pins mb_iop_grove_intr_ack/Din] [get_bd_pins mb_iop_grove_reset/Din] [get_bd_pins mb_iop_pmod0_intr_ack/Din] [get_bd_pins mb_iop_pmod0_reset/Din] [get_bd_pins mb_iop_pmod1_intr_ack/Din] [get_bd_pins mb_iop_pmod1_reset/Din] [get_bd_pins mb_iop_rpi_intr_ack/Din] [get_bd_pins mb_iop_rpi_reset/Din] [get_bd_pins ps_e_0/emio_gpio_o]
  connect_bd_net -net zynq_us_pl_clk2 [get_bd_pins proc_sys_reset_2/slowest_sync_clk] [get_bd_pins ps_e_0/pl_clk2]
  connect_bd_net -net zynq_us_pl_clk3 [get_bd_pins axi_smc/aclk] [get_bd_pins proc_sys_reset_3/slowest_sync_clk] [get_bd_pins ps_e_0/maxihpm0_fpd_aclk] [get_bd_pins ps_e_0/pl_clk3] [get_bd_pins ps_e_0/saxihp3_fpd_aclk] [get_bd_pins ps_e_0_axi_periph/ACLK] [get_bd_pins ps_e_0_axi_periph/M00_ACLK] [get_bd_pins ps_e_0_axi_periph/M01_ACLK] [get_bd_pins ps_e_0_axi_periph/M02_ACLK] [get_bd_pins ps_e_0_axi_periph/M03_ACLK] [get_bd_pins ps_e_0_axi_periph/M04_ACLK] [get_bd_pins ps_e_0_axi_periph/M05_ACLK] [get_bd_pins ps_e_0_axi_periph/S00_ACLK] [get_bd_pins trace_analyzer_pi/ap_clk] [get_bd_pins trace_analyzer_pmod0/ap_clk] [get_bd_pins trace_analyzer_pmod1/ap_clk]

  # Create address segments
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces address_remap_0/M_AXI_out] [get_bd_addr_segs ps_e_0/SAXIGP6/LPD_DDR_LOW] -force
  assign_bd_address -offset 0x80041000 -range 0x00001000 -target_address_space [get_bd_addr_spaces ps_e_0/Data] [get_bd_addr_segs HDMI_CTL_axi_iic/S_AXI/Reg] -force
  assign_bd_address -offset 0x800E0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces ps_e_0/Data] [get_bd_addr_segs audio_codec_ctrl_0/S_AXI/reg0] -force
  assign_bd_address -offset 0xA0010000 -range 0x00001000 -target_address_space [get_bd_addr_spaces ps_e_0/Data] [get_bd_addr_segs trace_analyzer_pi/axi_dma_0/S_AXI_LITE/Reg] -force
  assign_bd_address -offset 0xA0011000 -range 0x00001000 -target_address_space [get_bd_addr_spaces ps_e_0/Data] [get_bd_addr_segs trace_analyzer_pmod0/axi_dma_0/S_AXI_LITE/Reg] -force
  assign_bd_address -offset 0xA0012000 -range 0x00001000 -target_address_space [get_bd_addr_spaces ps_e_0/Data] [get_bd_addr_segs trace_analyzer_pmod1/axi_dma_0/S_AXI_LITE/Reg] -force
  assign_bd_address -offset 0x80043000 -range 0x00001000 -target_address_space [get_bd_addr_spaces ps_e_0/Data] [get_bd_addr_segs axi_intc_0/S_AXI/Reg] -force
  assign_bd_address -offset 0x80013000 -range 0x00001000 -target_address_space [get_bd_addr_spaces ps_e_0/Data] [get_bd_addr_segs mipi/axi_vdma/S_AXI_LITE/Reg] -force
  assign_bd_address -offset 0x80042000 -range 0x00001000 -target_address_space [get_bd_addr_spaces ps_e_0/Data] [get_bd_addr_segs video/axi_vdma/S_AXI_LITE/Reg] -force
  assign_bd_address -offset 0x80010000 -range 0x00001000 -target_address_space [get_bd_addr_spaces ps_e_0/Data] [get_bd_addr_segs video/hdmi_out/color_convert/s_axi_control/Reg] -force
  assign_bd_address -offset 0x80050000 -range 0x00001000 -target_address_space [get_bd_addr_spaces ps_e_0/Data] [get_bd_addr_segs video/hdmi_in/color_convert/s_axi_control/Reg] -force
  assign_bd_address -offset 0xA0040000 -range 0x00010000 -target_address_space [get_bd_addr_spaces ps_e_0/Data] [get_bd_addr_segs mipi/demosaic/s_axi_CTRL/Reg] -force
  assign_bd_address -offset 0x80000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces ps_e_0/Data] [get_bd_addr_segs video/hdmi_in/frontend/S_AXI_CPU_IN/Reg] -force
  assign_bd_address -offset 0x80020000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ps_e_0/Data] [get_bd_addr_segs video/hdmi_out/frontend/S_AXI_CPU_IN/Reg] -force
  assign_bd_address -offset 0xA0060000 -range 0x00010000 -target_address_space [get_bd_addr_spaces ps_e_0/Data] [get_bd_addr_segs mipi/gamma_lut/s_axi_CTRL/Reg] -force
  assign_bd_address -offset 0x80011000 -range 0x00001000 -target_address_space [get_bd_addr_spaces ps_e_0/Data] [get_bd_addr_segs gpio_btns/S_AXI/Reg] -force
  assign_bd_address -offset 0xA0013000 -range 0x00001000 -target_address_space [get_bd_addr_spaces ps_e_0/Data] [get_bd_addr_segs mipi/gpio_ip_reset/S_AXI/Reg] -force
  assign_bd_address -offset 0x80046000 -range 0x00001000 -target_address_space [get_bd_addr_spaces ps_e_0/Data] [get_bd_addr_segs gpio_leds/S_AXI/Reg] -force
  assign_bd_address -offset 0x80040000 -range 0x00001000 -target_address_space [get_bd_addr_spaces ps_e_0/Data] [get_bd_addr_segs gpio_sws/S_AXI/Reg] -force
  assign_bd_address -offset 0x800C0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces ps_e_0/Data] [get_bd_addr_segs iop_rpi/mb_bram_ctrl/S_AXI/Mem0] -force
  assign_bd_address -offset 0x800A0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces ps_e_0/Data] [get_bd_addr_segs iop_pmod0/mb_bram_ctrl/S_AXI/Mem0] -force
  assign_bd_address -offset 0x800B0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces ps_e_0/Data] [get_bd_addr_segs iop_pmod1/mb_bram_ctrl/S_AXI/Mem0] -force
  assign_bd_address -offset 0x80100000 -range 0x00010000 -target_address_space [get_bd_addr_spaces ps_e_0/Data] [get_bd_addr_segs iop_grove/mb_bram_ctrl/S_AXI/Mem0] -force
  assign_bd_address -offset 0x80120000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ps_e_0/Data] [get_bd_addr_segs mipi/mipi_csi2_rx_subsyst/csirxss_s_axi/Reg] -force
  assign_bd_address -offset 0x80070000 -range 0x00010000 -target_address_space [get_bd_addr_spaces ps_e_0/Data] [get_bd_addr_segs video/hdmi_in/pixel_pack/s_axi_control/Reg] -force
  assign_bd_address -offset 0x80080000 -range 0x00010000 -target_address_space [get_bd_addr_spaces ps_e_0/Data] [get_bd_addr_segs video/hdmi_out/pixel_unpack/s_axi_control/Reg] -force
  assign_bd_address -offset 0x80012000 -range 0x00001000 -target_address_space [get_bd_addr_spaces ps_e_0/Data] [get_bd_addr_segs rgbleds/S_AXI/Reg] -force
  assign_bd_address -offset 0x80090000 -range 0x00010000 -target_address_space [get_bd_addr_spaces ps_e_0/Data] [get_bd_addr_segs shutdown_HP0_FPD/S_AXI_CTRL/Reg] -force
  assign_bd_address -offset 0x80110000 -range 0x00010000 -target_address_space [get_bd_addr_spaces ps_e_0/Data] [get_bd_addr_segs shutdown_HP1_FPD/S_AXI_CTRL/Reg] -force
  assign_bd_address -offset 0x800D0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces ps_e_0/Data] [get_bd_addr_segs shutdown_HP2_FPD/S_AXI_CTRL/Reg] -force
  assign_bd_address -offset 0x800F0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces ps_e_0/Data] [get_bd_addr_segs shutdown_LPD/S_AXI_CTRL/Reg] -force
  assign_bd_address -offset 0x80014000 -range 0x00002000 -target_address_space [get_bd_addr_spaces ps_e_0/Data] [get_bd_addr_segs system_management_wiz_0/S_AXI_LITE/Reg] -force
  assign_bd_address -offset 0xA0020000 -range 0x00010000 -target_address_space [get_bd_addr_spaces ps_e_0/Data] [get_bd_addr_segs trace_analyzer_pmod0/trace_cntrl_32_0/s_axi_trace_cntrl/Reg] -force
  assign_bd_address -offset 0xA0030000 -range 0x00010000 -target_address_space [get_bd_addr_spaces ps_e_0/Data] [get_bd_addr_segs trace_analyzer_pmod1/trace_cntrl_32_0/s_axi_trace_cntrl/Reg] -force
  assign_bd_address -offset 0xA0000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces ps_e_0/Data] [get_bd_addr_segs trace_analyzer_pi/trace_cntrl_64_0/s_axi_trace_cntrl/Reg] -force
  assign_bd_address -offset 0x80016000 -range 0x00001000 -target_address_space [get_bd_addr_spaces ps_e_0/Data] [get_bd_addr_segs hdmi_tx_control/S_AXI/Reg] -force
  assign_bd_address -offset 0xA0050000 -range 0x00010000 -target_address_space [get_bd_addr_spaces ps_e_0/Data] [get_bd_addr_segs mipi/v_proc_sys/s_axi_ctrl/Reg] -force
  assign_bd_address -offset 0xA0070000 -range 0x00010000 -target_address_space [get_bd_addr_spaces ps_e_0/Data] [get_bd_addr_segs mipi/pixel_pack/s_axi_control/Reg] -force
  assign_bd_address -offset 0x80060000 -range 0x00010000 -target_address_space [get_bd_addr_spaces ps_e_0/Data] [get_bd_addr_segs video/phy/vid_phy_controller/vid_phy_axi4lite/Reg] -force
  assign_bd_address -offset 0x80000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces iop_grove/mb/Data] [get_bd_addr_segs address_remap_0/S_AXI_in/memory] -force
  assign_bd_address -offset 0x40000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces iop_grove/mb/Data] [get_bd_addr_segs iop_grove/gpio/S_AXI/Reg] -force
  assign_bd_address -offset 0x40800000 -range 0x00010000 -target_address_space [get_bd_addr_spaces iop_grove/mb/Data] [get_bd_addr_segs iop_grove/iic0/S_AXI/Reg] -force
  assign_bd_address -offset 0x40820000 -range 0x00010000 -target_address_space [get_bd_addr_spaces iop_grove/mb/Data] [get_bd_addr_segs iop_grove/iic1/S_AXI/Reg] -force
  assign_bd_address -offset 0x41200000 -range 0x00010000 -target_address_space [get_bd_addr_spaces iop_grove/mb/Data] [get_bd_addr_segs iop_grove/intc/S_AXI/Reg] -force
  assign_bd_address -offset 0x40010000 -range 0x00010000 -target_address_space [get_bd_addr_spaces iop_grove/mb/Data] [get_bd_addr_segs iop_grove/intr/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A20000 -range 0x00010000 -target_address_space [get_bd_addr_spaces iop_grove/mb/Data] [get_bd_addr_segs iop_grove/io_switch/S_AXI/S_AXI_reg] -force
  assign_bd_address -offset 0x00000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces iop_grove/mb/Data] [get_bd_addr_segs iop_grove/lmb/lmb_bram_if_cntlr/SLMB1/Mem] -force
  assign_bd_address -offset 0x00000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces iop_grove/mb/Instruction] [get_bd_addr_segs iop_grove/lmb/lmb_bram_if_cntlr/SLMB/Mem] -force
  assign_bd_address -offset 0x41C00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces iop_grove/mb/Data] [get_bd_addr_segs iop_grove/timer0/S_AXI/Reg] -force
  assign_bd_address -offset 0x41C20000 -range 0x00010000 -target_address_space [get_bd_addr_spaces iop_grove/mb/Data] [get_bd_addr_segs iop_grove/timer1/S_AXI/Reg] -force
  assign_bd_address -offset 0x80000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces iop_pmod0/mb/Data] [get_bd_addr_segs address_remap_0/S_AXI_in/memory] -force
  assign_bd_address -offset 0x40000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces iop_pmod0/mb/Data] [get_bd_addr_segs iop_pmod0/gpio/S_AXI/Reg] -force
  assign_bd_address -offset 0x40800000 -range 0x00010000 -target_address_space [get_bd_addr_spaces iop_pmod0/mb/Data] [get_bd_addr_segs iop_pmod0/iic/S_AXI/Reg] -force
  assign_bd_address -offset 0x41200000 -range 0x00010000 -target_address_space [get_bd_addr_spaces iop_pmod0/mb/Data] [get_bd_addr_segs iop_pmod0/intc/S_AXI/Reg] -force
  assign_bd_address -offset 0x40010000 -range 0x00010000 -target_address_space [get_bd_addr_spaces iop_pmod0/mb/Data] [get_bd_addr_segs iop_pmod0/intr/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A20000 -range 0x00010000 -target_address_space [get_bd_addr_spaces iop_pmod0/mb/Data] [get_bd_addr_segs iop_pmod0/io_switch/S_AXI/S_AXI_reg] -force
  assign_bd_address -offset 0x00000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces iop_pmod0/mb/Data] [get_bd_addr_segs iop_pmod0/lmb/lmb_bram_if_cntlr/SLMB1/Mem] -force
  assign_bd_address -offset 0x00000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces iop_pmod0/mb/Instruction] [get_bd_addr_segs iop_pmod0/lmb/lmb_bram_if_cntlr/SLMB/Mem] -force
  assign_bd_address -offset 0x44A10000 -range 0x00010000 -target_address_space [get_bd_addr_spaces iop_pmod0/mb/Data] [get_bd_addr_segs iop_pmod0/spi/AXI_LITE/Reg] -force
  assign_bd_address -offset 0x41C00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces iop_pmod0/mb/Data] [get_bd_addr_segs iop_pmod0/timer/S_AXI/Reg] -force
  assign_bd_address -offset 0x80000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces iop_pmod1/mb/Data] [get_bd_addr_segs address_remap_0/S_AXI_in/memory] -force
  assign_bd_address -offset 0x40000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces iop_pmod1/mb/Data] [get_bd_addr_segs iop_pmod1/gpio/S_AXI/Reg] -force
  assign_bd_address -offset 0x40800000 -range 0x00010000 -target_address_space [get_bd_addr_spaces iop_pmod1/mb/Data] [get_bd_addr_segs iop_pmod1/iic/S_AXI/Reg] -force
  assign_bd_address -offset 0x41200000 -range 0x00010000 -target_address_space [get_bd_addr_spaces iop_pmod1/mb/Data] [get_bd_addr_segs iop_pmod1/intc/S_AXI/Reg] -force
  assign_bd_address -offset 0x40010000 -range 0x00010000 -target_address_space [get_bd_addr_spaces iop_pmod1/mb/Data] [get_bd_addr_segs iop_pmod1/intr/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A20000 -range 0x00010000 -target_address_space [get_bd_addr_spaces iop_pmod1/mb/Data] [get_bd_addr_segs iop_pmod1/io_switch/S_AXI/S_AXI_reg] -force
  assign_bd_address -offset 0x00000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces iop_pmod1/mb/Data] [get_bd_addr_segs iop_pmod1/lmb/lmb_bram_if_cntlr/SLMB1/Mem] -force
  assign_bd_address -offset 0x00000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces iop_pmod1/mb/Instruction] [get_bd_addr_segs iop_pmod1/lmb/lmb_bram_if_cntlr/SLMB/Mem] -force
  assign_bd_address -offset 0x44A10000 -range 0x00010000 -target_address_space [get_bd_addr_spaces iop_pmod1/mb/Data] [get_bd_addr_segs iop_pmod1/spi/AXI_LITE/Reg] -force
  assign_bd_address -offset 0x41C00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces iop_pmod1/mb/Data] [get_bd_addr_segs iop_pmod1/timer/S_AXI/Reg] -force
  assign_bd_address -offset 0x80000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces iop_rpi/mb/Data] [get_bd_addr_segs address_remap_0/S_AXI_in/memory] -force
  assign_bd_address -offset 0x40800000 -range 0x00010000 -target_address_space [get_bd_addr_spaces iop_rpi/mb/Data] [get_bd_addr_segs iop_rpi/iic_subsystem/iic_0/S_AXI/Reg] -force
  assign_bd_address -offset 0x40810000 -range 0x00010000 -target_address_space [get_bd_addr_spaces iop_rpi/mb/Data] [get_bd_addr_segs iop_rpi/iic_subsystem/iic_1/S_AXI/Reg] -force
  assign_bd_address -offset 0x41200000 -range 0x00010000 -target_address_space [get_bd_addr_spaces iop_rpi/mb/Data] [get_bd_addr_segs iop_rpi/intc/S_AXI/Reg] -force
  assign_bd_address -offset 0x40020000 -range 0x00010000 -target_address_space [get_bd_addr_spaces iop_rpi/mb/Data] [get_bd_addr_segs iop_rpi/intr/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A20000 -range 0x00010000 -target_address_space [get_bd_addr_spaces iop_rpi/mb/Data] [get_bd_addr_segs iop_rpi/io_switch/S_AXI/S_AXI_reg] -force
  assign_bd_address -offset 0x00000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces iop_rpi/mb/Data] [get_bd_addr_segs iop_rpi/lmb/lmb_bram_if_cntlr/SLMB1/Mem] -force
  assign_bd_address -offset 0x00000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces iop_rpi/mb/Instruction] [get_bd_addr_segs iop_rpi/lmb/lmb_bram_if_cntlr/SLMB/Mem] -force
  assign_bd_address -offset 0x40000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces iop_rpi/mb/Data] [get_bd_addr_segs iop_rpi/rpi_gpio/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A10000 -range 0x00010000 -target_address_space [get_bd_addr_spaces iop_rpi/mb/Data] [get_bd_addr_segs iop_rpi/spi_subsystem/spi_0/AXI_LITE/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces iop_rpi/mb/Data] [get_bd_addr_segs iop_rpi/spi_subsystem/spi_1/AXI_LITE/Reg] -force
  assign_bd_address -offset 0x41C00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces iop_rpi/mb/Data] [get_bd_addr_segs iop_rpi/timers_subsystem/timer_0/S_AXI/Reg] -force
  assign_bd_address -offset 0x41C10000 -range 0x00010000 -target_address_space [get_bd_addr_spaces iop_rpi/mb/Data] [get_bd_addr_segs iop_rpi/timers_subsystem/timer_1/S_AXI/Reg] -force
  assign_bd_address -offset 0x40600000 -range 0x00010000 -target_address_space [get_bd_addr_spaces iop_rpi/mb/Data] [get_bd_addr_segs iop_rpi/uartlite/S_AXI/Reg] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces mipi/axi_vdma/Data_S2MM] [get_bd_addr_segs ps_e_0/SAXIGP3/HP1_DDR_LOW] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces trace_analyzer_pi/axi_dma_0/Data_S2MM] [get_bd_addr_segs ps_e_0/SAXIGP5/HP3_DDR_LOW] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces trace_analyzer_pmod0/axi_dma_0/Data_S2MM] [get_bd_addr_segs ps_e_0/SAXIGP5/HP3_DDR_LOW] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces trace_analyzer_pmod1/axi_dma_0/Data_S2MM] [get_bd_addr_segs ps_e_0/SAXIGP5/HP3_DDR_LOW] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces video/axi_vdma/Data_MM2S] [get_bd_addr_segs ps_e_0/SAXIGP2/HP0_DDR_LOW] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces video/axi_vdma/Data_S2MM] [get_bd_addr_segs ps_e_0/SAXIGP4/HP2_DDR_LOW] -force

  # Exclude Address Segments
  exclude_bd_addr_seg -offset 0xFF000000 -range 0x01000000 -target_address_space [get_bd_addr_spaces mipi/axi_vdma/Data_S2MM] [get_bd_addr_segs ps_e_0/SAXIGP3/HP1_LPS_OCM]
  exclude_bd_addr_seg -offset 0xFF000000 -range 0x01000000 -target_address_space [get_bd_addr_spaces trace_analyzer_pi/axi_dma_0/Data_S2MM] [get_bd_addr_segs ps_e_0/SAXIGP5/HP3_LPS_OCM]
  exclude_bd_addr_seg -offset 0xFF000000 -range 0x01000000 -target_address_space [get_bd_addr_spaces trace_analyzer_pmod0/axi_dma_0/Data_S2MM] [get_bd_addr_segs ps_e_0/SAXIGP5/HP3_LPS_OCM]
  exclude_bd_addr_seg -offset 0xFF000000 -range 0x01000000 -target_address_space [get_bd_addr_spaces trace_analyzer_pmod1/axi_dma_0/Data_S2MM] [get_bd_addr_segs ps_e_0/SAXIGP5/HP3_LPS_OCM]
  exclude_bd_addr_seg -offset 0xFF000000 -range 0x01000000 -target_address_space [get_bd_addr_spaces video/axi_vdma/Data_MM2S] [get_bd_addr_segs ps_e_0/SAXIGP2/HP0_LPS_OCM]
  exclude_bd_addr_seg -offset 0xFF000000 -range 0x01000000 -target_address_space [get_bd_addr_spaces video/axi_vdma/Data_S2MM] [get_bd_addr_segs ps_e_0/SAXIGP4/HP2_LPS_OCM]


  # Restore current instance
  current_bd_instance $oldCurInst

  # Create PFM attributes
  global overlay_name
  set pfm_name "xilinx.com:xd:${overlay_name}:1.0"
  set_property PFM_NAME ${pfm_name} [get_files [current_bd_design].bd]
  set_property PFM.CLOCK {  pl_clk0 {id "0" is_default "true"  proc_sys_reset "proc_sys_reset_0" status "fixed"}  pl_clk1 {id "1" is_default "false"  proc_sys_reset "proc_sys_reset_1" status "fixed"}  pl_clk2 {id "2" is_default "false"  proc_sys_reset "proc_sys_reset_2" status "fixed"}  pl_clk3 {id "3" is_default "false"  proc_sys_reset "proc_sys_reset_3" status "fixed"}  } [get_bd_cells /ps_e_0]
  set_property PFM.AXI_PORT {  M_AXI_HPM0_FPD {memport "M_AXI_GP"}  M_AXI_HPM0_LPD {memport "M_AXI_GP"}  S_AXI_HPC0_FPD {memport "S_AXI_HPC"}  S_AXI_HPC1_FPD {memport "S_AXI_HPC"}  S_AXI_HP0_FPD {memport "S_AXI_HP"}  S_AXI_HP1_FPD {memport "S_AXI_HP"}  S_AXI_HP2_FPD {memport "S_AXI_HP"}  S_AXI_HP3_FPD {memport "S_AXI_HP"}  S_AXI_LPD {memport "S_AXI_HP"}  } [get_bd_cells /ps_e_0]
  set_property PFM.IRQ {In1 {} In2 {} In3 {} In4 {} In5 {} In6 {} In7 {}} [get_bd_cells /xlconcat_0]

  validate_bd_design
  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


