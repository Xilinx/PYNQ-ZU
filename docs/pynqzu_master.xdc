## ----------------------------------------------------------------------------
## PYNQ-ZU Master XDC file for Rev 3.B Board. Refer to schematic file:XUP-ZU5EG-20200824.pdf
## Each constraint has bank number and schematic signal name
## Uncomment line of interested pin and change name of signal based on the design 
## The constraint line having two # indicates that they will automatically be picked up
## by the instatiated relevant IP in the design
## Parimal Patel
## Xilinx University Program
## 3/1/2021
## ---------------------------------------------------------------------------- 

## ----------------------------------------------------------------------------
## TP11 constraint
## TP7 => MIO2, TP8 => MIO3, TP9 => MIO76, TP10 => MIO77 automatically assigned by tools
## ---------------------------------------------------------------------------- 
#set_property PACKAGE_PIN AH6 [get_ports {TP11}];  #Bank 64 TP11
#set_property IOSTANDARD LVCMOS18 [get_ports {TP11}];
## ----------------------------------------------------------------------------
## CLK and Reset related constraints
## ---------------------------------------------------------------------------- 
## User Reset
#set_property PACKAGE_PIN H2 [get_ports {URST_B];  #Bank 65, URST_B
## FPGA CLK 125 MHz provided by Si5340 channel 2
#set_property PACKAGE_PIN K3 [get_ports {FPGA_CLK125_N}];  #Bank 65, FPGA_CLK125_N
#set_property IOSTANDARD LVDS [get_ports {FPGA_CLK125_N}]
#set_property PACKAGE_PIN K4 [get_ports {FPGA_CLK125_P}];  #Bank 65, FPGA_CLK125_P
#set_property IOSTANDARD LVDS [get_ports {FPGA_CLK125_P}]
## FPGA USER Clock 156.25 MHz provided by Si5340 channel 3
#set_property PACKAGE_PIN AD4 [get_ports {FPGA_USER_CLOCK_N}]; Bank 64, FPGA_USER_CLOCK_N
#set_property IOSTANDARD LVDS [get_ports {FPGA_USER_CLOCK_N}]
#set_property PACKAGE_PIN AD5 [get_ports {FPGA_USER_CLOCK_P}]; Bank 64, FPGA_USER_CLOCK_P
#set_property IOSTANDARD LVDS [get_ports {FPGA_USER_CLOCK_P}]

## ----------------------------------------------------------------------------
## HDMI TX and RX related constraints
## ---------------------------------------------------------------------------- 
## HDMI_RX_CLK_N_IN
#set_property PACKAGE_PIN V5 [get_ports HDMI_RX_CLK_N_IN]; #Bank 224, HDMI_RX_CLK_N
## HDMI_RX_CLK_P_IN
#set_property PACKAGE_PIN V6 [get_ports HDMI_RX_CLK_P_IN]; #Bank 224, HDMI_RX_CLK_P
## HDMI_RX_DAT_N_IN - Not needed as it is automatically picked up
##set_property PACKAGE_PIN Y1 [get_ports HDMI_RX_DAT_N_IN[0]]; #Bank 224, HDMI_RX_N0
##set_property PACKAGE_PIN V1 [get_ports HDMI_RX_DAT_N_IN[1]]; #Bank 224, HDMI_RX_N1
##set_property PACKAGE_PIN T1 [get_ports HDMI_RX_DAT_N_IN[2]]; #Bank 224, HDMI_RX_N2
## HDMI_RX_DAT_P_IN - Not needed as it is automatically picked up
##set_property PACKAGE_PIN Y2 [get_ports HDMI_RX_DAT_P_IN[0]]; #Bank 224, HDMI_RX_P0
##set_property PACKAGE_PIN V2 [get_ports HDMI_RX_DAT_P_IN[1]]; #Bank 224, HDMI_RX_P1
##set_property PACKAGE_PIN T2 [get_ports HDMI_RX_DAT_P_IN[2]]; #Bank 224, HDMI_RX_P2
## HDMI_SI5324_INT_ALM
#set_property PACKAGE_PIN G13 [get_ports HDMI_SI5324_INT_ALM]; #Bank 46, HDMI_SI5324_INT_ALM
#set_property IOSTANDARD LVCMOS33 [get_ports HDMI_SI5324_INT_ALM];
## HDMI_TX_LS_OE
#set_property PACKAGE_PIN E14 [get_ports HDMI_TX_LS_OE]; #Bank 46, HDMI_TX_LS_OE
#set_property IOSTANDARD LVCMOS33 [get_ports HDMI_TX_LS_OE];
## HDMI_TX_LVDS_OUT_N
#set_property PACKAGE_PIN AC6 [get_ports {HDMI_TX_LVDS_OUT_N}]; #Bank 64, HDMI_TX_LVDS_OUT_N
#set_property IOSTANDARD LVDS [get_ports {HDMI_TX_LVDS_OUT_N}];
## HDMI_TX_LVDS_OUT_P
#set_property PACKAGE_PIN AB6 [get_ports {HDMI_TX_LVDS_OUT_P}]; #Bank 64, HDMI_TX_LVDS_OUT_P
#set_property IOSTANDARD LVDS [get_ports {HDMI_TX_LVDS_OUT_P}];
## HDMI_TX_DAT_N_OUT - Not needed as it is automatically picked up
##set_property PACKAGE_PIN W3 [get_ports HDMI_TX_DAT_N_OUT[0]]; #Bank 224,
##set_property PACKAGE_PIN U3 [get_ports HDMI_TX_DAT_N_OUT[1]]; #Bank 224,
##set_property PACKAGE_PIN R3 [get_ports HDMI_TX_DAT_N_OUT[2]]; #Bank 224,
## HDMI_TX_DAT_P_OUT - Not needed as it is automatically picked up
##set_property PACKAGE_PIN W4 [get_ports HDMI_TX_DAT_P_OUT[0]]; #Bank 224,
##set_property PACKAGE_PIN U4 [get_ports HDMI_TX_DAT_P_OUT[1]]; #Bank 224,
##set_property PACKAGE_PIN R4 [get_ports HDMI_TX_DAT_P_OUT[2]]; #Bank 224,
## HDMI_SI5324_LOL_IN
#set_property PACKAGE_PIN F13 [get_ports HDMI_SI5324_LOL_IN]; #Bank 46, HDMI_SI5324_LOL         
#set_property IOSTANDARD LVCMOS33 [get_ports HDMI_SI5324_LOL_IN];
## HDMI_SI5324_RST_OUT
#set_property PACKAGE_PIN E13 [get_ports HDMI_SI5324_RST_OUT]; #Bank 46, HDMI_SI5324_RST
#set_property IOSTANDARD LVCMOS33 [get_ports HDMI_SI5324_RST_OUT];
## HDMI_TX_CT_HPD
#set_property PACKAGE_PIN D14 [get_ports HDMI_TX_CT_HPD]; #Bank 46, HDMI_TX_CT_HPD
#set_property IOSTANDARD LVCMOS33 [get_ports HDMI_TX_CT_HPD];
## RX_DDC_OUT_scl_io
#set_property PACKAGE_PIN D15 [get_ports RX_DDC_OUT_scl_io]; #Bank 46, HDMI_RX_SNK_SCL
#set_property IOSTANDARD LVCMOS33 [get_ports RX_DDC_OUT_scl_io];
#set_property PULLUP true [get_ports RX_DDC_OUT_scl_io];
## RX_DDC_OUT_sda_io
#set_property PACKAGE_PIN C13 [get_ports RX_DDC_OUT_sda_io]; #Bank 46, HDMI_RX_SNK_SDA
#set_property IOSTANDARD LVCMOS33 [get_ports RX_DDC_OUT_sda_io];
#set_property PULLUP true [get_ports RX_DDC_OUT_sda_io];
## RX_DET_IN
#set_property PACKAGE_PIN L13 [get_ports RX_DET_IN]; #Bank 46, HDMI_RX_PWR_DET
#set_property IOSTANDARD LVCMOS33 [get_ports RX_DET_IN];
## RX_HPD_OUT
#set_property PACKAGE_PIN L14 [get_ports {RX_HPD_OUT}]; #Bank 46, HDMI_RX_HPD
#set_property IOSTANDARD LVCMOS33 [get_ports {RX_HPD_OUT}];
## RX_REFCLK_N_OUT
#set_property PACKAGE_PIN H3 [get_ports RX_REFCLK_N_OUT]; #Bank 65, HDMI_REC_CLOCK_N
#set_property IOSTANDARD LVDS [get_ports RX_REFCLK_N_OUT];
## RX_REFCLK_P_OUT
#set_property PACKAGE_PIN H4 [get_ports RX_REFCLK_P_OUT]; #Bank 65, HDMI_REC_CLOCK_P
#set_property IOSTANDARD LVDS [get_ports RX_REFCLK_P_OUT];
## TX_DDC_OUT_scl_io
#set_property PACKAGE_PIN A14 [get_ports TX_DDC_OUT_scl_io]; #Bank 46, HDMI_TX_SRC_SCL
#set_property IOSTANDARD LVCMOS33 [get_ports TX_DDC_OUT_scl_io];
## TX_DDC_OUT_sda_io
#set_property PACKAGE_PIN B14 [get_ports TX_DDC_OUT_sda_io]; #Bank 46, HDMI_TX_SRC_SDA
#set_property IOSTANDARD LVCMOS33 [get_ports TX_DDC_OUT_sda_io];
## TX_EN_OUT
#set_property PACKAGE_PIN A13 [get_ports TX_EN_OUT];  #Bank 46, HDMI_TX_EN
#set_property IOSTANDARD LVCMOS33 [get_ports TX_EN_OUT];
### HDMI_TX_CEC
##set_property PACKAGE_PIN B13 [get_ports HDMI_TX_CEC];  #Bank 46, HDMI_TX_CEC
##set_property IOSTANDARD LVCMOS33 [get_ports HDMI_TX_CEC];
## TX_HPD_IN
#set_property PACKAGE_PIN C14 [get_ports TX_HPD_IN]; #Bank 46, HDMI_TX_HPD
#set_property IOSTANDARD LVCMOS33 [get_ports TX_HPD_IN];
## TX_REFCLK_N_IN
#set_property PACKAGE_PIN Y5 [get_ports TX_REFCLK_N_IN]; #Bank 224, HDMI_SI5324_OUT_N
## TX_REFCLK_P_IN
#set_property PACKAGE_PIN Y6 [get_ports TX_REFCLK_P_IN]; #Bank 224, HDMI_SI5324_OUT_P
## HDMI_CTL_iic_scl_io
#set_property PACKAGE_PIN A15 [get_ports HDMI_CTL_iic_scl_io]; #Bank 46, HDMI_CTL_SCL
#set_property IOSTANDARD LVCMOS33 [get_ports HDMI_CTL_iic_scl_io]; 
## HDMI_CTL_iic_sda_io
#set_property PACKAGE_PIN B15 [get_ports HDMI_CTL_iic_sda_io]; #Bank 46, HDMI_CTL_SDA
#set_property IOSTANDARD LVCMOS33 [get_ports HDMI_CTL_iic_sda_io];

## ----------------------------------------------------------------------------
## On-board peripherals related constraints
## ---------------------------------------------------------------------------- 
## dip_switch_4bits_tri_i
#set_property PACKAGE_PIN AA12 [get_ports {dip_switch_4bits_tri_i[0]}]; #Bank 44, SW0
#set_property PACKAGE_PIN Y12 [get_ports {dip_switch_4bits_tri_i[1]}]; #Bank 44, SW1
#set_property PACKAGE_PIN W11 [get_ports {dip_switch_4bits_tri_i[2]}]; #Bank 44, SW2
#set_property PACKAGE_PIN W12 [get_ports {dip_switch_4bits_tri_i[3]}]; #Bank 44, SW3
#set_property IOSTANDARD LVCMOS12 [get_ports {dip_switch_4bits_tri_i[*]}];
## push_button_4bits_tri_i
#set_property PACKAGE_PIN AH14 [get_ports {push_button_4bits_tri_i[0]}]; #Bank 44, BTN0
#set_property PACKAGE_PIN AG14 [get_ports {push_button_4bits_tri_i[1]}]; #Bank 44, BTN1
#set_property PACKAGE_PIN AE14 [get_ports {push_button_4bits_tri_i[2]}]; #Bank 44, BTN2
#set_property PACKAGE_PIN AE15 [get_ports {push_button_4bits_tri_i[3]}]; #Bank 44, BTN3
#set_property IOSTANDARD LVCMOS12 [get_ports {push_button_4bits_tri_i[*]}];
## led_4bits_tri_o
#set_property PACKAGE_PIN B5 [get_ports {led_4bits_tri_o[0]}]; #Bank 66, LED0
#set_property PACKAGE_PIN A6 [get_ports {led_4bits_tri_o[1]}]; #Bank 66, LED1
#set_property PACKAGE_PIN B8 [get_ports {led_4bits_tri_o[2]}]; #Bank 66, LED2
#set_property PACKAGE_PIN A7 [get_ports {led_4bits_tri_o[3]}]; #Bank 66, LED3
#set_property IOSTANDARD LVCMOS12 [get_ports {led_4bits_tri_o[*]}];
## grove0_tri_io
#set_property PACKAGE_PIN K5  [get_ports {grove0_tri_io[0]}];  #Bank 65, K5_GROVE_IO1
#set_property PACKAGE_PIN P9  [get_ports {grove0_tri_io[1]}];  #Bank 65, P9_GROVE_IO2 
#set_property IOSTANDARD LVCMOS18 [get_ports {grove0_tri_io[0]}];
#set_property IOSTANDARD LVCMOS18 [get_ports {grove0_tri_io[1]}];
## grove1_tri_io
#set_property PACKAGE_PIN AE4  [get_ports {grove1_tri_io[0]}]; #Bank 64, AE4_GROVE_IO1  
#set_property PACKAGE_PIN AB5  [get_ports {grove1_tri_io[1]}]; #Bank 64, AB5_GROVE_IO2 
#set_property IOSTANDARD LVCMOS18 [get_ports {grove1_tri_io[0]}];
#set_property IOSTANDARD LVCMOS18 [get_ports {grove1_tri_io[1]}];
## rgbled0_tri_o
#set_property PACKAGE_PIN A9 [get_ports {rgbled0_tri_o[0]}];  #Bank 66, LED_B0
#set_property PACKAGE_PIN A5 [get_ports {rgbled0_tri_o[1]}];  #Bank 66, LED_G0
#set_property PACKAGE_PIN A4 [get_ports {rgbled0_tri_o[2]}];  #Bank 66, LED_R0
#set_property IOSTANDARD LVCMOS12 [get_ports {rgbled0_tri_o[*]}];
## rgbled1_tri_o
#set_property PACKAGE_PIN A8 [get_ports {rgbled1_tri_o[0]}];  #Bank 66, LED_B1
#set_property PACKAGE_PIN B9 [get_ports {rgbled1_tri_o[1]}];  #Bank 66, LED_G1
#set_property PACKAGE_PIN B6 [get_ports {rgbled1_tri_o[2]}];  #Bank 66, LED_R1
#set_property IOSTANDARD LVCMOS12 [get_ports {rgbled1_tri_o[*]}];

## ----------------------------------------------------------------------------
## Audio CODEC related constraints
## ---------------------------------------------------------------------------- 
## Audio CODEC I2C SCL is connected to channel 2 of PS I2C MUX (U42)
## Audio CODEC I2C SDA is connected to channel 2 of PS I2C MUX (U42)
#set_property PACKAGE_PIN G15 [get_ports audio_codec_clk_10MHz]; #Bank 46, AUDIO_MCLK
#set_property PACKAGE_PIN E15 [get_ports audio_codec_bclk]; #Bank 46, AUDIO_BCLK
#set_property PACKAGE_PIN F15 [get_ports audio_codec_lrclk]; #Bank 46, AUDIO_WCLK
#set_property PACKAGE_PIN H13 [get_ports audio_codec_sdata_o]; #Bank 46, AUDIO_DIN
#set_property PACKAGE_PIN K14 [get_ports audio_codec_sdata_i]; #Bank 46, AUDIO_DOUT
#set_property PACKAGE_PIN H14 [get_ports {codec_addr[0]}]; #Bank 46, AUDIO_ADR0
#set_property PACKAGE_PIN G14 [get_ports {codec_addr[1]}]; #Bank 46, AUDIO_ADR1
#set_property IOSTANDARD LVCMOS33 [get_ports audio_codec_clk_10MHz]; 
#set_property IOSTANDARD LVCMOS33 [get_ports audio_codec_bclk]; 
#set_property IOSTANDARD LVCMOS33 [get_ports audio_codec_lrclk]; 
#set_property IOSTANDARD LVCMOS33 [get_ports audio_codec_sdata_o];
#set_property IOSTANDARD LVCMOS33 [get_ports audio_codec_sdata_i]; 
#set_property IOSTANDARD LVCMOS33 [get_ports codec_addr[0]];
#set_property IOSTANDARD LVCMOS33 [get_ports codec_addr[1]]; 

## ----------------------------------------------------------------------------
## Various headers/interface/Connectors related constraints
## ---------------------------------------------------------------------------- 
## ----------------------------------------------------------------------------
## XADC related constraints
## ---------------------------------------------------------------------------- 
### Header XADC Pin1 to an_p0, Pin2 to an_p1, an_n0 and an_n1 are grounded
#set_property PACKAGE_PIN AC7 [get_ports {Vaux14_v_n}]; #Channel 14n, Bank 64, AR_AN_N0		   
#set_property PACKAGE_PIN AB7 [get_ports {Vaux14_v_p}]; #Channel 14p, Bank 64, AR_AN_P0             
#set_property PACKAGE_PIN AC8 [get_ports {Vaux15_v_n}]; #Channel 15n, Bank 64, AR_AN_N1            
#set_property PACKAGE_PIN AB8 [get_ports {Vaux15_v_p}]; #Channel 15p, Bank 64, AR_AN_P1 
#set_property IOSTANDARD ANALOG [get_ports {Vaux14_v_n}];            
#set_property IOSTANDARD ANALOG [get_ports {Vaux14_v_p}];            
#set_property IOSTANDARD ANALOG [get_ports {Vaux15_v_n}];            
#set_property IOSTANDARD ANALOG [get_ports {Vaux15_v_p}];  
## ----------------------------------------------------------------------------
## PMOD0/PMODA related constraints
## ---------------------------------------------------------------------------- 
#set_property PACKAGE_PIN T8 [get_ports {pmod0[0]}]; #Bank 65, PMOD0_LS0
#set_property PACKAGE_PIN R8 [get_ports {pmod0[1]}]; #Bank 65, PMOD0_LS1
#set_property PACKAGE_PIN V8 [get_ports {pmod0[2]}]; #Bank 65, PMOD0_LS2
#set_property PACKAGE_PIN U8 [get_ports {pmod0[3]}]; #Bank 65, PMOD0_LS3
#set_property PACKAGE_PIN V9 [get_ports {pmod0[4]}]; #Bank 65, PMOD0_LS4
#set_property PACKAGE_PIN U9 [get_ports {pmod0[5]}]; #Bank 65, PMOD0_LS5
#set_property PACKAGE_PIN Y8 [get_ports {pmod0[6]}]; #Bank 65, PMOD0_LS6
#set_property PACKAGE_PIN W8 [get_ports {pmod0[7]}]; #Bank 65, PMOD0_LS7
#set_property PULLUP true [get_ports {pmod0[2]}];
#set_property PULLUP true [get_ports {pmod0[3]}];
#set_property PULLUP true [get_ports {pmod0[6]}];
#set_property PULLUP true [get_ports {pmod0[7]}];
#set_property IOSTANDARD LVCMOS18 [get_ports {pmod0[*]}];
## ----------------------------------------------------------------------------
## PMOD1/PMODB related constraints
## ---------------------------------------------------------------------------- 
#set_property PACKAGE_PIN F5 [get_ports {pmod1[0]}]; #Bank 66, PMOD1_LS0
#set_property PACKAGE_PIN G5 [get_ports {pmod1[1]}]; #Bank 66, PMOD1_LS1
#set_property PACKAGE_PIN E3 [get_ports {pmod1[2]}]; #Bank 66, PMOD1_LS2
#set_property PACKAGE_PIN E4 [get_ports {pmod1[3]}]; #Bank 66, PMOD1_LS3
#set_property PACKAGE_PIN F3 [get_ports {pmod1[4]}]; #Bank 66, PMOD1_LS4
#set_property PACKAGE_PIN G3 [get_ports {pmod1[5]}]; #Bank 66, PMOD1_LS5
#set_property PACKAGE_PIN E2 [get_ports {pmod1[6]}]; #Bank 66, PMOD1_LS6
#set_property PACKAGE_PIN F2 [get_ports {pmod1[7]}]; #Bank 66, PMOD1_LS7
#set_property PULLUP true [get_ports {pmod1[2]}];
#set_property PULLUP true [get_ports {pmod1[3]}];
#set_property PULLUP true [get_ports {pmod1[6]}];
#set_property PULLUP true [get_ports {pmod1[7]}];
#set_property DRIVE 8 [get_ports {pmod1[*]}];
#set_property IOSTANDARD LVCMOS12 [get_ports {pmod1[*]}];
## ----------------------------------------------------------------------------
## RaspberryPi related constraints
## ---------------------------------------------------------------------------- 
#set_property PACKAGE_PIN C7  [get_ports {rpi[0]}]; #Bank 66, RPIO_LS00, ID_SC
#set_property PACKAGE_PIN C8  [get_ports {rpi[1]}]; #Bank 66, RPIO_LS01, ID_SD
#set_property PACKAGE_PIN D2  [get_ports {rpi[2]}]; #Bank 66, RPIO_LS02, SDA
#set_property PACKAGE_PIN F1  [get_ports {rpi[3]}]; #Bank 66, RPIO_LS03, SCL
#set_property PACKAGE_PIN E1  [get_ports {rpi[4]}]; #Bank 66, RPIO_LS04
#set_property PACKAGE_PIN A1  [get_ports {rpi[5]}]; #Bank 66, RPIO_LS05
#set_property PACKAGE_PIN C2  [get_ports {rpi[6]}]; #Bank 66, RPIO_LS06
#set_property PACKAGE_PIN A2  [get_ports {rpi[7]}]; #Bank 66, RPIO_LS07
#set_property PACKAGE_PIN B3  [get_ports {rpi[8]}]; #Bank 66, RPIO_LS08
#set_property PACKAGE_PIN C9  [get_ports {rpi[9]}]; #Bank 66, RPIO_LS09
#set_property PACKAGE_PIN B4  [get_ports {rpi[10]}]; #Bank 66, RPIO_LS10
#set_property PACKAGE_PIN D9  [get_ports {rpi[11]}]; #Bank 66, RPIO_LS11
#set_property PACKAGE_PIN B1  [get_ports {rpi[12]}]; #Bank 66, RPIO_LS12
#set_property PACKAGE_PIN C4  [get_ports {rpi[13]}]; #Bank 66, RPIO_LS13
#set_property PACKAGE_PIN F7  [get_ports {rpi[14]}]; #Bank 66, RPIO_LS14
#set_property PACKAGE_PIN D4  [get_ports {rpi[15]}]; #Bank 66, RPIO_LS15
#set_property PACKAGE_PIN C1  [get_ports {rpi[16]}]; #Bank 66, RPIO_LS16
#set_property PACKAGE_PIN E8  [get_ports {rpi[17]}]; #Bank 66, RPIO_LS17
#set_property PACKAGE_PIN G1  [get_ports {rpi[18]}]; #Bank 66, RPIO_LS18
#set_property PACKAGE_PIN E7  [get_ports {rpi[19]}]; #Bank 66, RPIO_LS19
#set_property PACKAGE_PIN C6  [get_ports {rpi[20]}]; #Bank 66, RPIO_LS20
#set_property PACKAGE_PIN C3  [get_ports {rpi[21]}]; #Bank 66, RPIO_LS21
#set_property PACKAGE_PIN E9  [get_ports {rpi[22]}]; #Bank 66, RPIO_LS22
#set_property PACKAGE_PIN F8  [get_ports {rpi[23]}]; #Bank 66, RPIO_LS23
#set_property PACKAGE_PIN G8  [get_ports {rpi[24]}]; #Bank 66, RPIO_LS24
#set_property PACKAGE_PIN A3  [get_ports {rpi[25]}]; #Bank 66, RPIO_LS25
#set_property PACKAGE_PIN D1  [get_ports {rpi[26]}]; #Bank 66, RPIO_LS26
#set_property PACKAGE_PIN G4  [get_ports {rpi[27]}]; #Bank 66, RPIO_LS27

#set_property IOSTANDARD LVCMOS12 [get_ports {rpi[*]}]; 
#set_property DRIVE 8 [get_ports {rpi[*]}];    

## ----------------------------------------------------------------------------
## FMC Expansion Connector - I2C Channel
## FMC SCL is connected to channel 5 of PS I2C MUX (U42)
## FMC SDA is connected to channel 5 of PS I2C MUX (U42)
## FMC Expansion Connector - FMC_PRESENT
## FMC_LPC_PRSNT_M2C_B_LS is routed to PS_MIO6

#set_property PACKAGE_PIN N3 [get_ports {FMC_LPC_DP0_C2M_N}];  #Bank 224, FMC_LPC_DP0_C2M_N
#set_property PACKAGE_PIN N4 [get_ports {FMC_LPC_DP0_C2M_P}];  #Bank 224, FMC_LPC_DP0_C2M_P
#set_property PACKAGE_PIN P1 [get_ports {FMC_LPC_DP0_M2C_N}];  #Bank 224, FMC_LPC_DP0_M2C_N
#set_property PACKAGE_PIN P2 [get_ports {FMC_LPC_DP0_M2C_P}];  #Bank 224, FMC_LPC_DP0_M2C_p

#set_property PACKAGE_PIN L2 [get_ports {FMC_LPC_CLK0_M2C_N}];  #Bank 65, FMC_LPC_CLK0_M2C_N
#set_property PACKAGE_PIN L3 [get_ports {FMC_LPC_CLK0_M2C_P}];  #Bank 65, FMC_LPC_CLK0_M2C_P
#set_property PACKAGE_PIN L6 [get_ports {FMC_LPC_LA00_CC_N}];  #Bank 65, FMC_LPC_LA00_CC_N
#set_property PACKAGE_PIN L7 [get_ports {FMC_LPC_LA00_CC_P}];  #Bank 65, FMC_LPC_LA00_CC_P
#set_property PACKAGE_PIN P6 [get_ports {FMC_LPC_LA01_CC_N}];  #Bank 65, FMC_LPC_LA01_CC_N
#set_property PACKAGE_PIN P7 [get_ports {FMC_LPC_LA01_CC_P}];  #Bank 65, FMC_LPC_LA01_CC_P
#set_property PACKAGE_PIN K7 [get_ports {FMC_LPC_LA02_N}];  #Bank 65, FMC_LPC_LA02_N
#set_property PACKAGE_PIN K8 [get_ports {FMC_LPC_LA02_P}];  #Bank 65, FMC_LPC_LA02_P
#set_property PACKAGE_PIN J9 [get_ports {FMC_LPC_LA03_N}];  #Bank 65, FMC_LPC_LA03_N
#set_property PACKAGE_PIN K9 [get_ports {FMC_LPC_LA03_P}];  #Bank 65, FMC_LPC_LA03_P
#set_property PACKAGE_PIN H8 [get_ports {FMC_LPC_LA04_N}];  #Bank 65, FMC_LPC_LA04_N
#set_property PACKAGE_PIN H9 [get_ports {FMC_LPC_LA04_P}];  #Bank 65, FMC_LPC_LA04_P
#set_property PACKAGE_PIN H1 [get_ports {FMC_LPC_LA05_N}];  #Bank 65, FMC_LPC_LA05_N
#set_property PACKAGE_PIN J1 [get_ports {FMC_LPC_LA05_P}];  #Bank 65, FMC_LPC_LA05_P
#set_property PACKAGE_PIN H7 [get_ports {FMC_LPC_LA06_N}];  #Bank 65, FMC_LPC_LA06_N
#set_property PACKAGE_PIN J7 [get_ports {FMC_LPC_LA06_P}];  #Bank 65, FMC_LPC_LA06_P
#set_property PACKAGE_PIN H6 [get_ports {FMC_LPC_LA07_N}];  #Bank 65, FMC_LPC_LA07_N
#set_property PACKAGE_PIN J6 [get_ports {FMC_LPC_LA07_P}];  #Bank 65, FMC_LPC_LA07_P
#set_property PACKAGE_PIN J4 [get_ports {FMC_LPC_LA08_N}];  #Bank 65, FMC_LPC_LA08_N
#set_property PACKAGE_PIN J5 [get_ports {FMC_LPC_LA08_P}];  #Bank 65, FMC_LPC_LA08_P
#set_property PACKAGE_PIN K1 [get_ports {FMC_LPC_LA09_N}];  #Bank 65, FMC_LPC_LA09_N
#set_property PACKAGE_PIN L1 [get_ports {FMC_LPC_LA09_P}];  #Bank 65, FMC_LPC_LA09_P
#set_property PACKAGE_PIN N6 [get_ports {FMC_LPC_LA10_N}];  #Bank 65, FMC_LPC_LA10_N
#set_property PACKAGE_PIN N7 [get_ports {FMC_LPC_LA10_P}];  #Bank 65, FMC_LPC_LA10_P
#set_property PACKAGE_PIN J2 [get_ports {FMC_LPC_LA11_N}];  #Bank 65, FMC_LPC_LA11_N
#set_property PACKAGE_PIN K2 [get_ports {FMC_LPC_LA11_P}];  #Bank 65, FMC_LPC_LA11_P
#set_property PACKAGE_PIN L5 [get_ports {FMC_LPC_LA12_N}];  #Bank 65, FMC_LPC_LA12_N
#set_property PACKAGE_PIN M6 [get_ports {FMC_LPC_LA12_P}];  #Bank 65, FMC_LPC_LA12_P
#set_property PACKAGE_PIN T6 [get_ports {FMC_LPC_LA13_N}];  #Bank 65, FMC_LPC_LA13_N
#set_property PACKAGE_PIN R6 [get_ports {FMC_LPC_LA13_P}];  #Bank 65, FMC_LPC_LA13_P
#set_property PACKAGE_PIN T7 [get_ports {FMC_LPC_LA14_N}];  #Bank 65, FMC_LPC_LA14_N
#set_property PACKAGE_PIN R7 [get_ports {FMC_LPC_LA14_P}];  #Bank 65, FMC_LPC_LA14_P
#set_property PACKAGE_PIN N8 [get_ports {FMC_LPC_LA15_N}];  #Bank 65, FMC_LPC_LA15_N
#set_property PACKAGE_PIN N9 [get_ports {FMC_LPC_LA15_P}];  #Bank 65, FMC_LPC_LA15_P
#set_property PACKAGE_PIN L8 [get_ports {FMC_LPC_LA16_N}];  #Bank 65, FMC_LPC_LA16_N
#set_property PACKAGE_PIN M8 [get_ports {FMC_LPC_LA16_P}];  #Bank 65, FMC_LPC_LA16_P
## ----------------------------------------------------------------------------
## FMC Expansion Connector - Bank 64
## ---------------------------------------------------------------------------- 
#set_property PACKAGE_PIN AF5 [get_ports {FMC_LPC_CLK1_M2C_N}];  #Bank 64, FMC_LPC_CLK1_M2C_N
#set_property PACKAGE_PIN AE5 [get_ports {FMC_LPC_CLK1_M2C_P}];  #Bank 64, FMC_LPC_CLK1_M2C_P
#set_property PACKAGE_PIN AC3 [get_ports {FMC_LPC_LA17_CC_N}];  #Bank 64, FMC_LPC_LA17_CC_N
#set_property PACKAGE_PIN AC4 [get_ports {FMC_LPC_LA17_CC_P}];  #Bank 64, FMC_LPC_LA17_CC_P
#set_property PACKAGE_PIN AD1 [get_ports {FMC_LPC_LA18_CC_N}];  #Bank 64, FMC_LPC_LA18_CC_N
#set_property PACKAGE_PIN AD2 [get_ports {FMC_LPC_LA18_CC_P}];  #Bank 64, FMC_LPC_LA18_CC_P
#set_property PACKAGE_PIN AC2 [get_ports {FMC_LPC_LA19_N}];  #Bank 64, FMC_LPC_LA19_N
#set_property PACKAGE_PIN AB2 [get_ports {FMC_LPC_LA19_P}];  #Bank 64, FMC_LPC_LA19_P
#set_property PACKAGE_PIN AB3 [get_ports {FMC_LPC_LA20_N}];  #Bank 64, FMC_LPC_LA20_N
#set_property PACKAGE_PIN AB4 [get_ports {FMC_LPC_LA20_P}];  #Bank 64, FMC_LPC_LA20_P
#set_property PACKAGE_PIN AF2 [get_ports {FMC_LPC_LA21_N}];  #Bank 64, FMC_LPC_LA21_N
#set_property PACKAGE_PIN AE2 [get_ports {FMC_LPC_LA21_P}];  #Bank 64, FMC_LPC_LA21_P
#set_property PACKAGE_PIN AC1 [get_ports {FMC_LPC_LA22_N}];  #Bank 64, FMC_LPC_LA22_N
#set_property PACKAGE_PIN AB1 [get_ports {FMC_LPC_LA22_P}];  #Bank 64, FMC_LPC_LA22_P
#set_property PACKAGE_PIN AD9 [get_ports {FMC_LPC_LA23_N}];  #Bank 64, FMC_LPC_LA23_N
#set_property PACKAGE_PIN AC9 [get_ports {FMC_LPC_LA23_P}];  #Bank 64, FMC_LPC_LA23_P
#set_property PACKAGE_PIN AH3 [get_ports {FMC_LPC_LA24_N}];  #Bank 64, FMC_LPC_LA24_N
#set_property PACKAGE_PIN AG3 [get_ports {FMC_LPC_LA24_P}];  #Bank 64, FMC_LPC_LA24_P
#set_property PACKAGE_PIN AH1 [get_ports {FMC_LPC_LA25_N}];  #Bank 64, FMC_LPC_LA25_N
#set_property PACKAGE_PIN AH2 [get_ports {FMC_LPC_LA25_P}];  #Bank 64, FMC_LPC_LA25_P
#set_property PACKAGE_PIN AG1 [get_ports {FMC_LPC_LA26_N}];  #Bank 64, FMC_LPC_LA26_N
#set_property PACKAGE_PIN AF1 [get_ports {FMC_LPC_LA26_P}];  #Bank 64, FMC_LPC_LA26_P
#set_property PACKAGE_PIN AF3 [get_ports {FMC_LPC_LA27_N}];  #Bank 64, FMC_LPC_LA27_N
#set_property PACKAGE_PIN AE3 [get_ports {FMC_LPC_LA27_P}];  #Bank 64, FMC_LPC_LA27_P
#set_property PACKAGE_PIN AG5 [get_ports {FMC_LPC_LA28_N}];  #Bank 64, FMC_LPC_LA28_N
#set_property PACKAGE_PIN AG6 [get_ports {FMC_LPC_LA28_P}];  #Bank 64, FMC_LPC_LA28_P
#set_property PACKAGE_PIN AH4 [get_ports {FMC_LPC_LA29_N}];  #Bank 64, FMC_LPC_LA29_N
#set_property PACKAGE_PIN AG4 [get_ports {FMC_LPC_LA29_P}];  #Bank 64, FMC_LPC_LA29_P
#set_property PACKAGE_PIN AE8 [get_ports {FMC_LPC_LA30_N}];  #Bank 64, FMC_LPC_LA30_N
#set_property PACKAGE_PIN AE9 [get_ports {FMC_LPC_LA30_N}];  #Bank 64, FMC_LPC_LA30_P
#set_property PACKAGE_PIN AH9 [get_ports {FMC_LPC_LA31_N}];  #Bank 64, FMC_LPC_LA31_N
#set_property PACKAGE_PIN AG9 [get_ports {FMC_LPC_LA31_P}];  #Bank 64, FMC_LPC_LA31_P
#set_property PACKAGE_PIN AG8 [get_ports {FMC_LPC_LA32_N}];  #Bank 64, FMC_LPC_LA32_N
#set_property PACKAGE_PIN AF8 [get_ports {FMC_LPC_LA32_P}];  #Bank 64, FMC_LPC_LA32_P
#set_property PACKAGE_PIN AE7 [get_ports {FMC_LPC_LA33_N}];  #Bank 64, FMC_LPC_LA33_N
#set_property PACKAGE_PIN AD7 [get_ports {FMC_LPC_LA33_P}];  #Bank 64, FMC_LPC_LA33_P

#set_property IOSTANDARD LVCMOS18 [get_ports -of_objects [get_iobanks 64]];
#set_property IOSTANDARD LVCMOS18 [get_ports -of_objects [get_iobanks 65]];

## ----------------------------------------------------------------------------
## MIPI 
## CAM_SCL and CAM_SDA are driven by Channel 3 of I2C MUX
## ---------------------------------------------------------------------------- 
#set_property PACKAGE_PIN AH7 [get_ports {cam_gpio_tri_io[0]}]; Bank 64, CAM_GPIO_LS
#set_property IOSTANDARD LVCMOS18 [get_ports {cam_gpio_tri_io[0]}]

##set_property IOSTANDARD MIPI_DPHY_DCI [get_ports mipi_clk_n]
##set_property PACKAGE_PIN D7 [get_ports mipi_clk_p]; #Bank 66, MIPI_CLK_P
##set_property PACKAGE_PIN D6 [get_ports mipi_clk_n]; #Bank 66, MIPI_CLK_P
##set_property IOSTANDARD MIPI_DPHY_DCI [get_ports mipi_clk_p]
##set_property IOSTANDARD MIPI_DPHY_DCI [get_ports mipi_lane_n0]
##set_property IOSTANDARD MIPI_DPHY_DCI [get_ports mipi_lane_n1]
##set_property PACKAGE_PIN E5 [get_ports mipi_lane_p0]; #Bank 66, MIPI_LANE_P0
##set_property PACKAGE_PIN D5 [get_ports mipi_lane_n0]; #Bank 66, MIPI_LANE_N0
##set_property IOSTANDARD MIPI_DPHY_DCI [get_ports mipi_lane_p0]
##set_property PACKAGE_PIN G6 [get_ports mipi_lane_p1]; #Bank 66, MIPI_LANE_P1
##set_property PACKAGE_PIN F6 [get_ports mipi_lane_n1]; #Bank 66, MIPI_LANE_N1
##set_property IOSTANDARD MIPI_DPHY_DCI [get_ports mipi_lane_p1]

## SYZYGY Power Good related constraint
#set_property PACKAGE_PIN J14 [get_ports {syzygy_pgood}]; #Bank 46, SYZYGY_PG  
#set_property IOSTANDARD LVCMOS33 [get_ports syzygy_pgood]

## ----------------------------------------------------------------------------
## SYZYGY STD0 Expansion Connector - Bank 43 and Bank 44
## ---------------------------------------------------------------------------- 
#set_property PACKAGE_PIN AE10 [get_ports {SYZYGY1_DP0}];  #Bank 43, SYZYGY1_DP0
#set_property PACKAGE_PIN AH12 [get_ports {SYZYGY1_DP1}];  #Bank 43, SYZYGY1_DP1
#set_property PACKAGE_PIN AF10 [get_ports {SYZYGY1_DN0}];  #Bank 43, SYZYGY1_DN0
#set_property PACKAGE_PIN AH11 [get_ports {SYZYGY1_DN1}];  #Bank 43, SYZYGY1_DN1
#set_property PACKAGE_PIN AF11 [get_ports {SYZYGY1_DP2}];  #Bank 43, SYZYGY1_DP2
#set_property PACKAGE_PIN AG10 [get_ports {SYZYGY1_DP3}];  #Bank 43, SYZYGY1_DP3
#set_property PACKAGE_PIN AG11 [get_ports {SYZYGY1_DN2}];  #Bank 43, SYZYGY1_DN2
#set_property PACKAGE_PIN AH10 [get_ports {SYZYGY1_DN3}];  #Bank 43, SYZYGY1_DN3
#set_property PACKAGE_PIN AD15 [get_ports {SYZYGY1_DP4}];  #Bank 44, SYZYGY1_DP4
#set_property PACKAGE_PIN AE13 [get_ports {SYZYGY1_DP5}];  #Bank 44, SYZYGY1_DP5
#set_property PACKAGE_PIN AD14 [get_ports {SYZYGY1_DN4}];  #Bank 44, SYZYGY1_DN4
#set_property PACKAGE_PIN AF13 [get_ports {SYZYGY1_DN5}];  #Bank 44, SYZYGY1_DN5
#set_property PACKAGE_PIN AC14 [get_ports {SYZYGY1_DP6}];  #Bank 44, SYZYGY1_DP6
#set_property PACKAGE_PIN AG13 [get_ports {SYZYGY1_DP7}];  #Bank 44, SYZYGY1_DP7
#set_property PACKAGE_PIN AC13 [get_ports {SYZYGY1_DN6}];  #Bank 44, SYZYGY1_DN6
#set_property PACKAGE_PIN AH13 [get_ports {SYZYGY1_DN7}];  #Bank 44, SYZYGY1_DN7
#set_property PACKAGE_PIN W10 [get_ports {SYZYGY1_S16}];  #Bank 43, SYZYGY1_S16
#set_property PACKAGE_PIN AA11 [get_ports {SYZYGY1_S17}];  #Bank 43, SYZYGY1_S17
#set_property PACKAGE_PIN Y9 [get_ports {SYZYGY1_S18}];  #Bank 43, SYZYGY1_S18
#set_property PACKAGE_PIN AD11 [get_ports {SYZYGY1_S19}];  #Bank 43, SYZYGY1_S19
#set_property PACKAGE_PIN Y10 [get_ports {SYZYGY1_S20}];  #Bank 43, SYZYGY1_S20
#set_property PACKAGE_PIN AC11 [get_ports {SYZYGY1_S21}];  #Bank 43, SYZYGY1_S21
#set_property PACKAGE_PIN AA8 [get_ports {SYZYGY1_S22}];  #Bank 43, SYZYGY1_S22
#set_property PACKAGE_PIN AD10 [get_ports {SYZYGY1_S23}];  #Bank 43, SYZYGY1_S23
#set_property PACKAGE_PIN AA10 [get_ports {SYZYGY1_S24}];  #Bank 43, SYZYGY1_S24
#set_property PACKAGE_PIN AB11 [get_ports {SYZYGY1_S25}];  #Bank 43, SYZYGY1_S25
#set_property PACKAGE_PIN AB9 [get_ports {SYZYGY1_S26}];  #Bank 43, SYZYGY1_S26
#set_property PACKAGE_PIN AB10 [get_ports {SYZYGY1_S27}];  #Bank 43, SYZYGY1_S27

#set_property PACKAGE_PIN AD12 [get_ports {SYZYGY1_P2C_CLKN}];  #Bank 43, SYZYGY1_P2C_CLKN
#set_property PACKAGE_PIN AF12 [get_ports {SYZYGY1_C2P_CLKN}];  #Bank 43, SYZYGY1_C2P_CLKN
#set_property PACKAGE_PIN AC12 [get_ports {SYZYGY1_P2C_CLKP}];  #Bank 43, SYZYGY1_P2C_CLKP
#set_property PACKAGE_PIN AE12 [get_ports {SYZYGY1_C2P_CLKP}];  #Bank 43, SYZYGY1_C2P_CLKP

## ----------------------------------------------------------------------------
## SYZYGY STD1 Expansion Connector - Bank 44 and Bank 45
## ---------------------------------------------------------------------------- 
#set_property PACKAGE_PIN J11 [get_ports {SYZYGY2_DP0}];  #Bank 45, SYZYGY2_DP0
#set_property PACKAGE_PIN J12 [get_ports {SYZYGY2_DP1}];  #Bank 45, SYZYGY2_DP1
#set_property PACKAGE_PIN J10 [get_ports {SYZYGY2_DN0}];  #Bank 45, SYZYGY2_DN0
#set_property PACKAGE_PIN H12 [get_ports {SYZYGY2_DN1}];  #Bank 45, SYZYGY2_DN1
#set_property PACKAGE_PIN H11 [get_ports {SYZYGY2_DP2}];  #Bank 45, SYZYGY2_DP2
#set_property PACKAGE_PIN K13 [get_ports {SYZYGY2_DP3}];  #Bank 45, SYZYGY2_DP3
#set_property PACKAGE_PIN G10 [get_ports {SYZYGY2_DN2}];  #Bank 45, SYZYGY2_DN2
#set_property PACKAGE_PIN K12 [get_ports {SYZYGY2_DN3}];  #Bank 45, SYZYGY2_DN3
#set_property PACKAGE_PIN Y14 [get_ports {SYZYGY2_DP4}];  #Bank 46, SYZYGY2_DP4
#set_property PACKAGE_PIN AA13 [get_ports {SYZYGY2_DP5}];  #Bank 46, SYZYGY2_DP5
#set_property PACKAGE_PIN Y13 [get_ports {SYZYGY2_DN4}];  #Bank 46, SYZYGY2_DN4
#set_property PACKAGE_PIN AB13 [get_ports {SYZYGY2_DN5}];  #Bank 46, SYZYGY2_DN5
#set_property PACKAGE_PIN W14 [get_ports {SYZYGY2_DP6}];  #Bank 46, SYZYGY2_DP6
#set_property PACKAGE_PIN AB15 [get_ports {SYZYGY2_DP7}];  #Bank 46, SYZYGY2_DP7
#set_property PACKAGE_PIN W13 [get_ports {SYZYGY2_DN6}];  #Bank 46, SYZYGY2_DN6
#set_property PACKAGE_PIN AB14 [get_ports {SYZYGY2_DN7}];  #Bank 46, SYZYGY2_DN7
#set_property PACKAGE_PIN A12 [get_ports {SYZYGY2_S16}];  #Bank 45, SYZYGY2_S16
#set_property PACKAGE_PIN A11 [get_ports {SYZYGY2_S17}];  #Bank 45, SYZYGY2_S17
#set_property PACKAGE_PIN D12 [get_ports {SYZYGY2_S17}];  #Bank 45, SYZYGY2_S18
#set_property PACKAGE_PIN C12 [get_ports {SYZYGY2_S19}];  #Bank 45, SYZYGY2_S19
#set_property PACKAGE_PIN E12 [get_ports {SYZYGY2_S20}];  #Bank 45, SYZYGY2_S20
#set_property PACKAGE_PIN B10 [get_ports {SYZYGY2_S21}];  #Bank 45, SYZYGY2_S21
#set_property PACKAGE_PIN A10 [get_ports {SYZYGY2_S22}];  #Bank 45, SYZYGY2_S22
#set_property PACKAGE_PIN C11 [get_ports {SYZYGY2_S23}];  #Bank 45, SYZYGY2_S23
#set_property PACKAGE_PIN D11 [get_ports {SYZYGY2_S24}];  #Bank 45, SYZYGY2_S24
#set_property PACKAGE_PIN B11 [get_ports {SYZYGY2_S25}];  #Bank 45, SYZYGY2_S25
#set_property PACKAGE_PIN D10 [get_ports {SYZYGY2_S26}];  #Bank 45, SYZYGY2_S26
#set_property PACKAGE_PIN E10 [get_ports {SYZYGY2_S27}];  #Bank 45, SYZYGY2_S27

#set_property PACKAGE_PIN F11 [get_ports {SYZYGY2_P2C_CLKN}];  #Bank 45, SYZYGY2_P2C_CLKN
#set_property PACKAGE_PIN F10 [get_ports {SYZYGY2_C2P_CLKN}];  #Bank 45, SYZYGY2_C2P_CLKN
#set_property PACKAGE_PIN F12 [get_ports {SYZYGY2_P2C_CLKP}];  #Bank 45, SYZYGY2_P2C_CLKP
#set_property PACKAGE_PIN G11 [get_ports {SYZYGY2_C2P_CLKP}];  #Bank 45, SYZYGY2_C2P_CLKP

## ----------------------------------------------------------------------------
## Default operating IOSTANDARD for SYZYGY banks
## ---------------------------------------------------------------------------- 
#set_property IOSTANDARD LVCMOS12 [get_ports -of_objects [get_iobanks 43]];
#set_property IOSTANDARD LVCMOS12 [get_ports -of_objects [get_iobanks 44]];
#set_property IOSTANDARD LVCMOS12 [get_ports -of_objects [get_iobanks 45]];
