#   Copyright (c) 2020, Xilinx, Inc.
#   All rights reserved.
#
#   Redistribution and use in source and binary forms, with or without
#   modification, are permitted provided that the following conditions are met:
#
#   1.  Redistributions of source code must retain the above copyright notice,
#       this list of conditions and the following disclaimer.
#
#   2.  Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
#
#   3.  Neither the name of the copyright holder nor the names of its
#       contributors may be used to endorse or promote products derived from
#       this software without specific prior written permission.
#
#   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
#   AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
#   THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
#   PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
#   CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
#   EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
#   PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
#   OR BUSINESS INTERRUPTION). HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
#   WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
#   OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
#   ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

import os

__author__ = "Parimal Patel"
__copyright__ = "Copyright 2020, Xilinx"
__email__ = "pynq_support@xilinx.com"


# Microblaze constants
BIN_LOCATION = os.path.dirname(os.path.realpath(__file__)) + "/"
BSP_LOCATION = os.path.join(BIN_LOCATION, "bsp_iop_grove")

# PYNQ-ZU constants
GC0 = {'ip_name': 'iop_grove/mb_bram_ctrl',
       'rst_name': 'mb_iop_grove_reset',
       'intr_pin_name': 'iop_grove/dff_en_reset_vector_0/q',
       'intr_ack_name': 'mb_iop_grove_intr_ack'}
GC1 = {'ip_name': 'iop_grove/mb_bram_ctrl',
       'rst_name': 'mb_iop_grove_reset',
       'intr_pin_name': 'iop_grove/dff_en_reset_vector_0/q',
       'intr_ack_name': 'mb_iop_grove_intr_ack'}

# Grove mailbox constants
MAILBOX_OFFSET = 0xF000
MAILBOX_SIZE = 0x1000
MAILBOX_PY2IOP_CMD_OFFSET = 0xffc
MAILBOX_PY2IOP_ADDR_OFFSET = 0xff8
MAILBOX_PY2IOP_DATA_OFFSET = 0xf00

# Grove mailbox commands
WRITE_CMD = 0
READ_CMD = 1
IOP_MMIO_REGSIZE = 0x10000

# Grove switch register map
GROVE_SWITCHCONFIG_BASEADDR = 0x44A20000
GROVE_SWITCHCONFIG_NUMREGS = 4

# Each Grove pin can be tied to digital IO, SPI, or IIC
GROVE_NUM_DIGITAL_PINS = 2
GROVE_SWCFG_DIO = 0x0
GROVE_SWCFG_SDA0 = 0xC
GROVE_SWCFG_SCL0 = 0xD
GROVE_SWCFG_PWM0 = 0x10
GROVE_SWCFG_TIMER_G0 = 0x18
GROVE_SWCFG_TIMER_IC0 = 0x38

# Switch config - all digital IOs
GROVE_SWCFG_DIOALL = [GROVE_SWCFG_DIO, GROVE_SWCFG_DIO]

# IIC register map
GROVE_XIIC_0_BASEADDR = 0x40800000
GROVE_XIIC_1_BASEADDR = 0x40810000
GROVE_XIIC_DGIER_OFFSET = 0x1C
GROVE_XIIC_IISR_OFFSET = 0x20
GROVE_XIIC_IIER_OFFSET = 0x28
GROVE_XIIC_RESETR_OFFSET = 0x40
GROVE_XIIC_CR_REG_OFFSET = 0x100
GROVE_XIIC_SR_REG_OFFSET = 0x104
GROVE_XIIC_DTR_REG_OFFSET = 0x108
GROVE_XIIC_DRR_REG_OFFSET = 0x10C
GROVE_XIIC_ADR_REG_OFFSET = 0x110
GROVE_XIIC_TFO_REG_OFFSET = 0x114
GROVE_XIIC_RFO_REG_OFFSET = 0x118
GROVE_XIIC_TBA_REG_OFFSET = 0x11C
GROVE_XIIC_RFD_REG_OFFSET = 0x120
GROVE_XIIC_GPO_REG_OFFSET = 0x124

# IO register map
GROVE_DIO_BASEADDR = 0x40000000
GROVE_DIO_DATA_OFFSET = 0x0
GROVE_DIO_TRI_OFFSET = 0x4

# AXI IO direction constants
GROVE_CFG_DIO_ALLOUTPUT = 0x0
GROVE_CFG_DIO_ALLINPUT = 0xffffffff
