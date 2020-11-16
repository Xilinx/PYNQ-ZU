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

from .i2c_device import *

# LPS25H I2C Slave Addresses
_LPS25H_ADDRESS0             = 0x5c
_LPS25H_ADDRESS1             = 0x5d
_LPS25H_REG_ID               = 0x0f
_LPS25H_ID                   = 0xbd

# Register map
_LPS25H_REF_P_XL             = 0x08
_LPS25H_REF_P_XH             = 0x09
_LPS25H_RES_CONF             = 0x10
_LPS25H_CTRL_REG_1           = 0x20
_LPS25H_CTRL_REG_2           = 0x21
_LPS25H_CTRL_REG_3           = 0x22
_LPS25H_CTRL_REG_4           = 0x23
_LPS25H_INT_CFG              = 0x24
_LPS25H_INT_SOURCE           = 0x25
_LPS25H_STATUS_REG           = 0x27
_LPS25H_PRESS_OUT_XL         = 0x28
_LPS25H_PRESS_OUT_L          = 0x29
_LPS25H_PRESS_OUT_H          = 0x2a
_LPS25H_TEMP_OUT_L           = 0x2b
_LPS25H_TEMP_OUT_H           = 0x2c
_LPS25H_FIFO_CTRL            = 0x2e
_LPS25H_FIFO_STATUS          = 0x2f
_LPS25H_THS_P_L              = 0x30
_LPS25H_THS_P_H              = 0x31
_LPS25H_RPDS_L               = 0x39
_LPS25H_RPDS_H               = 0x3a

class LPS25H:
    _BUFFER = bytearray(6)
    def __init__(self):
        self._write_u8(_LPS25H_CTRL_REG_1, 0xc4)
        self._write_u8(_LPS25H_RES_CONF, 0x05)
        self._write_u8(_LPS25H_FIFO_CTRL, 0xc0)
        self._write_u8(_LPS25H_CTRL_REG_2, 0x40)

    @property
    def pressure(self):
        press = self.read_press_raw()
        return press

    def read_press_raw(self):
        self._read_bytes(_LPS25H_PRESS_OUT_XL + 0x80, 3, self._BUFFER)
        press = (((self._BUFFER[2] & 0xFF) << 16) |((self._BUFFER[1] & 0xFF) << 8) | (self._BUFFER[0] & 0xFF))/4096
        return press

    @property
    def temperature(self):
        temp = self.read_temp_raw()
        return temp

    def read_temp_raw(self):
        self._read_bytes(_LPS25H_TEMP_OUT_L + 0x80, 2, self._BUFFER)
        temp = ((self._BUFFER[1] & 0xFF) << 8) | (self._BUFFER[0] & 0xFF)
        temp = ((temp & 0x7FFF) - (temp & 0x8000)) / 480 + 42.5
        return temp

    def _read_u8(self, address):
        raise NotImplementedError()

    def _read_bytes(self, address, count, buf):
        raise NotImplementedError()

    def _write_u8(self, address, val):
        raise NotImplementedError()	

class LPS25H_I2C(LPS25H):
    def __init__(self, i2c):
        self._device = I2CDevice(i2c, _LPS25H_ADDRESS0)
        super().__init__()

    def _read_u8(self, address):
        device = self._device
        with device as i2c:
            self._BUFFER[0] = address & 0xFF
            i2c.write(self._BUFFER, end=1, stop=False)
            i2c.readinto(self._BUFFER, end=1)
        return self._BUFFER[0]

    def _read_bytes(self, address, count, buf):
        device = self._device
        with device as i2c:
            buf[0] = address & 0xFF
            i2c.write(buf, end=1, stop=False)
            i2c.readinto(buf, end=count)

    def _write_u8(self, address, val):
        device = self._device
        with device as i2c:
            self._BUFFER[0] = address & 0xFF
            self._BUFFER[1] = val & 0xFF
            i2c.write(self._BUFFER, end=2)