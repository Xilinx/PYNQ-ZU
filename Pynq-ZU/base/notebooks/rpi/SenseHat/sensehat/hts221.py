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
import numpy as np

# HTS221 I2C Slave Address
_HTS221_ADDRESS          = 0x5f
_HTS221_REG_ID           = 0x0f
_HTS221_ID               = 0xbc

# Register map
_HTS221_WHO_AM_I         = 0x0f
_HTS221_AV_CONF          = 0x10
_HTS221_CTRL1            = 0x20
_HTS221_CTRL2            = 0x21
_HTS221_CTRL3            = 0x22
_HTS221_STATUS           = 0x27
_HTS221_HUMIDITY_OUT_L   = 0x28
_HTS221_HUMIDITY_OUT_H   = 0x29
_HTS221_TEMP_OUT_L       = 0x2a
_HTS221_TEMP_OUT_H       = 0x2b
_HTS221_H0_H_2           = 0x30
_HTS221_H1_H_2           = 0x31
_HTS221_T0_C_8           = 0x32
_HTS221_T1_C_8           = 0x33
_HTS221_T1_T0            = 0x35
_HTS221_H0_T0_OUT        = 0x36
_HTS221_H1_T0_OUT        = 0x3a
_HTS221_T0_OUT           = 0x3c
_HTS221_T1_OUT           = 0x3e

class HTS221:
    _BUFFER = bytearray(6)
    def __init__(self):
        self._write_u8(_HTS221_CTRL1, 0x87)
        self._write_u8(_HTS221_AV_CONF, 0x1b)   
        val1 = self._read_u8(_HTS221_T1_T0 + 0x80)
        val2 = self._read_u8(_HTS221_T0_C_8 + 0x80)
        T0 = ((val1 & 0x03) << 8 | val2) / 8
        val2 = self._read_u8(_HTS221_T1_C_8 + 0x80)
        T1 = ((val1 & 0x0c) << 6 | val2) / 8
        self._read_bytes(_HTS221_T0_OUT + 0x80, 2, self._BUFFER)
        T0_OUT =(self._BUFFER[1] << 8) | self._BUFFER[0]
        self._read_bytes(_HTS221_T1_OUT + 0x80, 2, self._BUFFER)
        T1_OUT = np.uint16((self._BUFFER[1] << 8) | self._BUFFER[0])
        self._temp_m = (T1 - T0) / (T1_OUT - T0_OUT)
        self._temp_c = T0 - (self._temp_m * T0_OUT)

        val1 = self._read_u8(_HTS221_H0_H_2 + 0x80)
        H0 = val1 / 2
        print("H0 ", val1)
        val1 = self._read_u8(_HTS221_H1_H_2 + 0x80)
        H1 = val1 / 2
        print("H1 ", val1)
        self._read_bytes(_HTS221_H0_T0_OUT + 0x80, 2, self._BUFFER)
        H0_T0_OUT = self._BUFFER[1] << 8 | self._BUFFER[0]
        print("buffer1 ", self._BUFFER[1])
        print("buffer0 ", self._BUFFER[0])
        print("H0_T0_OUT ", H0_T0_OUT)
        self._read_bytes(_HTS221_H1_T0_OUT + 0x80, 2, self._BUFFER)
        H1_T0_OUT = self._BUFFER[1] << 8 | self._BUFFER[0]
        print("buffer1 ", self._BUFFER[1])
        print("buffer0 ", self._BUFFER[0])
        print("H0_T0_OUT ", H0_T0_OUT)
        self._hum_m = (H1 - H0) / (H1_T0_OUT - H0_T0_OUT)
        self._hum_c = H0 - (self._hum_m * H0_T0_OUT)
        print("self._hum_m ", self._hum_m)
        print("self._hum_c ", self._hum_c)
        
    @property
    def humidity(self):
        hum = self.read_hum_raw()
        return hum    
    def read_hum_raw(self):
        self._read_bytes(_HTS221_HUMIDITY_OUT_L + 0x80, 2, self._BUFFER)
        hum = (((self._BUFFER[1] & 0xFF) << 8) | (self._BUFFER[0] & 0xFF))
        hum = hum * self._hum_m + self._hum_c
        return hum    
    @property
    def temperature(self):
        temp = self.read_temp_raw()
        return temp 
    def read_temp_raw(self):
        self._read_bytes(_HTS221_TEMP_OUT_L + 0x80, 2, self._BUFFER)
        temp = ((self._BUFFER[1] & 0xFF) << 8) | (self._BUFFER[0] & 0xFF)
        temp = temp * self._temp_m + self._temp_c
        return temp 
    def _read_u8(self, address):
        raise NotImplementedError() 
    def _read_bytes(self, address, count, buf):
        raise NotImplementedError() 
    def _write_u8(self, address, val):
        raise NotImplementedError()	

class HTS221_I2C(HTS221):
    def __init__(self, i2c):
        self._device = I2CDevice(i2c, _HTS221_ADDRESS)
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
