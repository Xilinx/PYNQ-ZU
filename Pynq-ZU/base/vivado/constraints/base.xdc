# Copyright (C) 2021 Xilinx, Inc
# SPDX-License-Identifier: BSD-3-Clause

################################################################
# PYNQ-ZU Base Overlay Constraints File
# Features:
#	Video Pipeline - HDMIIn, HDMIOut
#	MIPI-PCAM
#	Two PL-GRove connectors
# 	Four on-board switches, push buttons, LEDs each
#	Two RGBLeds
#	Two PMODs, RPi
#	Audio CODEC HP+Mic, HP 
# 	Two Ananlog channels conneccted to XADC
# 	SYZYGY_PG
################################################################
# HDMI_RX_CLK_N_IN
set_property PACKAGE_PIN V5 [get_ports HDMI_RX_CLK_N_IN]; 
# HDMI_RX_CLK_P_IN
set_property PACKAGE_PIN V6 [get_ports HDMI_RX_CLK_P_IN]; 
# HDMI_RX_DAT_N_IN - Not needed as it is automatically picked up
#set_property PACKAGE_PIN Y1 [get_ports HDMI_RX_DAT_N_IN[0]];
#set_property PACKAGE_PIN V1 [get_ports HDMI_RX_DAT_N_IN[1]];
#set_property PACKAGE_PIN T1 [get_ports HDMI_RX_DAT_N_IN[2]];
# HDMI_RX_DAT_P_IN - Not needed as it is automatically picked up
#set_property PACKAGE_PIN Y2 [get_ports HDMI_RX_DAT_P_IN[0]];
#set_property PACKAGE_PIN V2 [get_ports HDMI_RX_DAT_P_IN[1]];
#set_property PACKAGE_PIN T2 [get_ports HDMI_RX_DAT_P_IN[2]];
# HDMI_TX_LS_OE
set_property PACKAGE_PIN E14 [get_ports HDMI_TX_LS_OE[0]]; 
set_property IOSTANDARD LVCMOS33 [get_ports HDMI_TX_LS_OE[0]];
# HDMI_TX_CLK_N_OUT
set_property PACKAGE_PIN AC6 [get_ports {HDMI_TX_CLK_N_OUT}];
set_property IOSTANDARD LVDS [get_ports {HDMI_TX_CLK_N_OUT}];
# HDMI_TX_CLK_P_OUT
set_property PACKAGE_PIN AB6 [get_ports {HDMI_TX_CLK_P_OUT}];
set_property IOSTANDARD LVDS [get_ports {HDMI_TX_CLK_P_OUT}];
# HDMI_TX_DAT_N_OUT - Not needed as it is automatically picked up
#set_property PACKAGE_PIN W3 [get_ports HDMI_TX_DAT_N_OUT[0]];
#set_property PACKAGE_PIN U3 [get_ports HDMI_TX_DAT_N_OUT[1]];
#set_property PACKAGE_PIN R3 [get_ports HDMI_TX_DAT_N_OUT[2]];
# HDMI_TX_DAT_P_OUT - Not needed as it is automatically picked up
#set_property PACKAGE_PIN W4 [get_ports HDMI_TX_DAT_P_OUT[0]];
#set_property PACKAGE_PIN U4 [get_ports HDMI_TX_DAT_P_OUT[1]];
#set_property PACKAGE_PIN R4 [get_ports HDMI_TX_DAT_P_OUT[2]];
# HDMI_SI5324_LOL_IN
set_property PACKAGE_PIN F13 [get_ports HDMI_SI5324_LOL_IN];          
set_property IOSTANDARD LVCMOS33 [get_ports HDMI_SI5324_LOL_IN];
# HDMI_SI5324_RST_OUT
set_property PACKAGE_PIN E13 [get_ports HDMI_SI5324_RST_OUT];
set_property IOSTANDARD LVCMOS33 [get_ports HDMI_SI5324_RST_OUT];
# RX_DDC_OUT_scl_io
set_property PACKAGE_PIN D15 [get_ports RX_DDC_OUT_scl_io];
set_property IOSTANDARD LVCMOS33 [get_ports RX_DDC_OUT_scl_io];
set_property PULLUP true [get_ports RX_DDC_OUT_scl_io];
# RX_DDC_OUT_sda_io
set_property PACKAGE_PIN C13 [get_ports RX_DDC_OUT_sda_io];
set_property IOSTANDARD LVCMOS33 [get_ports RX_DDC_OUT_sda_io];
set_property PULLUP true [get_ports RX_DDC_OUT_sda_io];
# RX_DET_IN
set_property PACKAGE_PIN L13 [get_ports RX_DET_IN];
set_property IOSTANDARD LVCMOS33 [get_ports RX_DET_IN];
# RX_HPD_OUT
set_property PACKAGE_PIN L14 [get_ports {RX_HPD_OUT}];
set_property IOSTANDARD LVCMOS33 [get_ports {RX_HPD_OUT}];
# RX_REFCLK_N_OUT
set_property PACKAGE_PIN H3 [get_ports RX_REFCLK_N_OUT];
set_property IOSTANDARD LVDS [get_ports RX_REFCLK_N_OUT];
# RX_REFCLK_P_OUT
set_property PACKAGE_PIN H4 [get_ports RX_REFCLK_P_OUT];
set_property IOSTANDARD LVDS [get_ports RX_REFCLK_P_OUT];
# TX_DDC_OUT_scl_io
set_property PACKAGE_PIN A14 [get_ports TX_DDC_OUT_scl_io];
set_property IOSTANDARD LVCMOS33 [get_ports TX_DDC_OUT_scl_io];
# TX_DDC_OUT_sda_io
set_property PACKAGE_PIN B14 [get_ports TX_DDC_OUT_sda_io];
set_property IOSTANDARD LVCMOS33 [get_ports TX_DDC_OUT_sda_io];
# TX_EN_OUT
set_property PACKAGE_PIN A13 [get_ports TX_EN_OUT[0]];
set_property IOSTANDARD LVCMOS33 [get_ports TX_EN_OUT[0]];
# HDMI_TX_CT_HPD; this signal is not needed as it is pulled high on board
#set_property PACKAGE_PIN D14 [get_ports {HDMI_TX_CT_HPD[0]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {HDMI_TX_CT_HPD[0]}]
# TX_HPD_IN
set_property PACKAGE_PIN C14 [get_ports TX_HPD_IN];
set_property IOSTANDARD LVCMOS33 [get_ports TX_HPD_IN];
# TX_REFCLK_N_IN
set_property PACKAGE_PIN Y5 [get_ports TX_REFCLK_N_IN];
# TX_REFCLK_P_IN
set_property PACKAGE_PIN Y6 [get_ports TX_REFCLK_P_IN];
# HDMI_CTL_iic_scl_io
set_property PACKAGE_PIN A15 [get_ports HDMI_CTL_iic_scl_io];
set_property IOSTANDARD LVCMOS33 [get_ports HDMI_CTL_iic_scl_io];
# HDMI_CTL_iic_sda_io
set_property PACKAGE_PIN B15 [get_ports HDMI_CTL_iic_sda_io];
set_property IOSTANDARD LVCMOS33 [get_ports HDMI_CTL_iic_sda_io];

## Header XADC Pin1 to an_p0, Pin2 to an_p1, an_n0 and an_n1 are grounded
set_property PACKAGE_PIN AC7 [get_ports {Vaux14_v_n}]; #Channel 14n
set_property PACKAGE_PIN AB7 [get_ports {Vaux14_v_p}]; #Channel 14p
set_property PACKAGE_PIN AC8 [get_ports {Vaux15_v_n}]; #Channel 15n
set_property PACKAGE_PIN AB8 [get_ports {Vaux15_v_p}]; #Channel 15p
set_property IOSTANDARD ANALOG [get_ports {Vaux14_v_n}];
set_property IOSTANDARD ANALOG [get_ports {Vaux14_v_p}];
set_property IOSTANDARD ANALOG [get_ports {Vaux15_v_n}];
set_property IOSTANDARD ANALOG [get_ports {Vaux15_v_p}];

# dip_switch_4bits_tri_i
set_property PACKAGE_PIN AA12 [get_ports {dip_switch_4bits_tri_i[0]}];
set_property PACKAGE_PIN Y12 [get_ports {dip_switch_4bits_tri_i[1]}];
set_property PACKAGE_PIN W11 [get_ports {dip_switch_4bits_tri_i[2]}];
set_property PACKAGE_PIN W12 [get_ports {dip_switch_4bits_tri_i[3]}];
set_property IOSTANDARD LVCMOS12 [get_ports {dip_switch_4bits_tri_i[*]}];
# led_4bits_tri_o
set_property PACKAGE_PIN B5 [get_ports {led_4bits_tri_o[0]}];
set_property PACKAGE_PIN A6 [get_ports {led_4bits_tri_o[1]}];
set_property PACKAGE_PIN B8 [get_ports {led_4bits_tri_o[2]}];
set_property PACKAGE_PIN A7 [get_ports {led_4bits_tri_o[3]}];
set_property IOSTANDARD LVCMOS12 [get_ports {led_4bits_tri_o[*]}];
# pmod0
set_property PACKAGE_PIN T8 [get_ports {pmod0[0]}];
set_property PACKAGE_PIN R8 [get_ports {pmod0[1]}];
set_property PACKAGE_PIN V8 [get_ports {pmod0[2]}];
set_property PACKAGE_PIN U8 [get_ports {pmod0[3]}];
set_property PACKAGE_PIN V9 [get_ports {pmod0[4]}];
set_property PACKAGE_PIN U9 [get_ports {pmod0[5]}];
set_property PACKAGE_PIN Y8 [get_ports {pmod0[6]}];
set_property PACKAGE_PIN W8 [get_ports {pmod0[7]}];
set_property PULLUP true [get_ports {pmod0[2]}];
set_property PULLUP true [get_ports {pmod0[3]}];
set_property PULLUP true [get_ports {pmod0[6]}];
set_property PULLUP true [get_ports {pmod0[7]}];
set_property IOSTANDARD LVCMOS18 [get_ports {pmod0[*]}];
# pmod1
set_property PACKAGE_PIN F5 [get_ports {pmod1[0]}];
set_property PACKAGE_PIN G5 [get_ports {pmod1[1]}];
set_property PACKAGE_PIN E3 [get_ports {pmod1[2]}];
set_property PACKAGE_PIN E4 [get_ports {pmod1[3]}];
set_property PACKAGE_PIN F3 [get_ports {pmod1[4]}];
set_property PACKAGE_PIN G3 [get_ports {pmod1[5]}];
set_property PACKAGE_PIN E2 [get_ports {pmod1[6]}];
set_property PACKAGE_PIN F2 [get_ports {pmod1[7]}];
set_property PULLUP true [get_ports {pmod1[2]}];
set_property PULLUP true [get_ports {pmod1[3]}];
set_property PULLUP true [get_ports {pmod1[6]}];
set_property PULLUP true [get_ports {pmod1[7]}];
set_property DRIVE 8 [get_ports {pmod1[*]}];
set_property IOSTANDARD LVCMOS12 [get_ports {pmod1[*]}];
# push_button_4bits_tri_i
set_property PACKAGE_PIN AH14 [get_ports {push_button_4bits_tri_i[0]}];
set_property PACKAGE_PIN AG14 [get_ports {push_button_4bits_tri_i[1]}];
set_property PACKAGE_PIN AE14 [get_ports {push_button_4bits_tri_i[2]}];
set_property PACKAGE_PIN AE15 [get_ports {push_button_4bits_tri_i[3]}];
set_property IOSTANDARD LVCMOS12 [get_ports {push_button_4bits_tri_i[*]}];
# Audio CODEC I2C SCL is connected to channel 2 of PS I2C MUX (U42)
# Audio CODEC I2C SDA is connected to channel 2 of PS I2C MUX (U42)
set_property PACKAGE_PIN G15 [get_ports audio_codec_clk_10MHz]; 
set_property PACKAGE_PIN E15 [get_ports audio_codec_bclk]; 
set_property PACKAGE_PIN F15 [get_ports audio_codec_lrclk]; 
set_property PACKAGE_PIN H13 [get_ports audio_codec_sdata_o];
set_property PACKAGE_PIN K14 [get_ports audio_codec_sdata_i]; 
set_property PACKAGE_PIN H14 [get_ports {codec_addr[0]}];
set_property PACKAGE_PIN G14 [get_ports {codec_addr[1]}];
set_property IOSTANDARD LVCMOS33 [get_ports audio_codec_clk_10MHz]; 
set_property IOSTANDARD LVCMOS33 [get_ports audio_codec_bclk]; 
set_property IOSTANDARD LVCMOS33 [get_ports audio_codec_lrclk]; 
set_property IOSTANDARD LVCMOS33 [get_ports audio_codec_sdata_o];
set_property IOSTANDARD LVCMOS33 [get_ports audio_codec_sdata_i]; 
set_property IOSTANDARD LVCMOS33 [get_ports codec_addr[0]];
set_property IOSTANDARD LVCMOS33 [get_ports codec_addr[1]]; 
# RaspberryPi
set_property PACKAGE_PIN C7  [get_ports {rpi[0]}]; # ID_SC
set_property PACKAGE_PIN C8  [get_ports {rpi[1]}]; # ID_SD
set_property PACKAGE_PIN D2  [get_ports {rpi[2]}];  # SDA
set_property PACKAGE_PIN F1  [get_ports {rpi[3]}]; # SCL
set_property PACKAGE_PIN E1  [get_ports {rpi[4]}]; 
set_property PACKAGE_PIN A1  [get_ports {rpi[5]}]; 
set_property PACKAGE_PIN C2  [get_ports {rpi[6]}]; 
set_property PACKAGE_PIN A2  [get_ports {rpi[7]}]; 
set_property PACKAGE_PIN B3  [get_ports {rpi[8]}]; 
set_property PACKAGE_PIN C9  [get_ports {rpi[9]}]; 
set_property PACKAGE_PIN B4  [get_ports {rpi[10]}]; 
set_property PACKAGE_PIN D9  [get_ports {rpi[11]}]; 
set_property PACKAGE_PIN B1  [get_ports {rpi[12]}]; 
set_property PACKAGE_PIN C4  [get_ports {rpi[13]}]; 
set_property PACKAGE_PIN F7  [get_ports {rpi[14]}]; 
set_property PACKAGE_PIN D4  [get_ports {rpi[15]}]; 
set_property PACKAGE_PIN C1  [get_ports {rpi[16]}]; 
set_property PACKAGE_PIN E8  [get_ports {rpi[17]}]; 
set_property PACKAGE_PIN G1  [get_ports {rpi[18]}]; 
set_property PACKAGE_PIN E7  [get_ports {rpi[19]}]; 
set_property PACKAGE_PIN C6  [get_ports {rpi[20]}]; 
set_property PACKAGE_PIN C3  [get_ports {rpi[21]}]; 
set_property PACKAGE_PIN E9  [get_ports {rpi[22]}]; 
set_property PACKAGE_PIN F8  [get_ports {rpi[23]}]; 
set_property PACKAGE_PIN G8  [get_ports {rpi[24]}]; 
set_property PACKAGE_PIN A3  [get_ports {rpi[25]}]; 
set_property PACKAGE_PIN D1  [get_ports {rpi[26]}]; 
set_property PACKAGE_PIN G4  [get_ports {rpi[27]}]; 

set_property IOSTANDARD LVCMOS12 [get_ports {rpi[*]}]; 
set_property DRIVE 8 [get_ports {rpi[*]}];    

# grove0_tri_io
set_property PACKAGE_PIN K5  [get_ports {pl_groves[0]}];  # J19, Pin1
set_property PACKAGE_PIN P9  [get_ports {pl_groves[1]}];  # J19, Pin2 
set_property IOSTANDARD LVCMOS18 [get_ports {pl_groves[0]}];
set_property IOSTANDARD LVCMOS18 [get_ports {pl_groves[1]}];
# grove1_tri_io
set_property PACKAGE_PIN AE4  [get_ports {pl_groves[2]}]; # J20, Pin1  
set_property PACKAGE_PIN AB5  [get_ports {pl_groves[3]}]; # J20, Pin2 
set_property IOSTANDARD LVCMOS18 [get_ports {pl_groves[2]}];
set_property IOSTANDARD LVCMOS18 [get_ports {pl_groves[3]}];
# rgbled0_tri_o
set_property PACKAGE_PIN A9 [get_ports {rgbleds_tri_o[0]}];  # Blue
set_property PACKAGE_PIN A5 [get_ports {rgbleds_tri_o[1]}];  # Green
set_property PACKAGE_PIN A4 [get_ports {rgbleds_tri_o[2]}];  # Red
#set_property IOSTANDARD LVCMOS12 [get_ports {rgbleds_tri_o[*]}];
# rgbled1_tri_o
set_property PACKAGE_PIN A8 [get_ports {rgbleds_tri_o[3]}];  # Blue
set_property PACKAGE_PIN B9 [get_ports {rgbleds_tri_o[4]}];  # Green
set_property PACKAGE_PIN B6 [get_ports {rgbleds_tri_o[5]}];  # Red
set_property IOSTANDARD LVCMOS12 [get_ports {rgbleds_tri_o[*]}];
## SYZYGY Power Good related constraint
set_property PACKAGE_PIN J14 [get_ports {syzygy_pg}]; #Bank 46, SYZYGY_PG  
set_property IOSTANDARD LVCMOS33 [get_ports syzygy_pg]
# MIPI
# CAM_SCL and CAM_SDA are driven by Channel 3 of I2C MUX
set_property PACKAGE_PIN AH7 [get_ports {cam_gpio_tri_o[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {cam_gpio_tri_o[0]}]

# Trace Analyzer related false path timing constraints
set_false_path -to [get_pins {base_i/trace_analyzer_pi/dff_en_reset_vector_0/inst/q_reg[*]/D}]
set_false_path -to [get_pins {base_i/trace_analyzer_pmod0/dff_en_reset_vector_0/inst/q_reg[*]/D}]
set_false_path -to [get_pins {base_i/trace_analyzer_pmod1/dff_en_reset_vector_0/inst/q_reg[*]/D}]

