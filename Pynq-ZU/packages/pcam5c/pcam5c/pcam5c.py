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
import cffi
import warnings
from pynq import DefaultHierarchy

__author__ = "Parimal Patel, Yun Rock Qu"
__copyright__ = "Copyright 2020, Xilinx"
__email__ = "pynq_support@xilinx.com"


_pcam5c_lib_header = R"""
int pcam_mipi(unsigned long GPIO_IP_RESET_BaseAddress,
        unsigned long CAMGPIO_BaseAddress,
        unsigned long VPROCSSCS_BaseAddress,
        unsigned long GAMMALUT_BaseAddress,
        unsigned long DEMOSAIC_BaseAddress,
        unsigned long MIPI_CSI2_Baseaddress);
int StartPcam (int);
"""

_pcam5c_ffi = cffi.FFI()
_pcam5c_ffi.cdef(_pcam5c_lib_header)
LIB_SEARCH_PATH = os.path.dirname(os.path.realpath(__file__))

try:
    _pcam5c_lib = _pcam5c_ffi.dlopen(os.path.join(LIB_SEARCH_PATH,
                                                  "libpcam5c.so"))
except:
    warnings.warn("Could not load Xilinx Pcam5c camera Library",
                  ResourceWarning)
    _pcam5c_lib = None


class Pcam5C(DefaultHierarchy):
    """Driver for PCAM

    """

    @staticmethod
    def checkhierarchy(description):
        return (
            'gpio_ip_reset' in description['ip'] and
            'cam_gpio' in description['ip'] and
            'mipi_csi2_rx_subsyst_0' in description['ip'] and
            'demosaic0' in description['ip'] and
            'gamma_lut0' in description['ip'] and
            'v_proc_ss_0' in description['ip'])

    def __init__(self, description):
        """Create a new instance of the driver

        Can raise `RuntimeError` if the shared library was not found.

        Parameters
        ----------
        description : dict
            Entry in the ip_dict for the device

        """
        if _pcam5c_lib is None:
            raise RuntimeError("No PCam5C Library")
        super().__init__(description)

    def initialize(self):
        self._virtaddr_gpio_ip_reset=self.gpio_ip_reset.mmio.array.ctypes.data
        self._virtaddr_cam_gpio=self.cam_gpio.mmio.array.ctypes.data
        self._virtaddr_v_proc_ss_0=self.v_proc_ss_0.mmio.array.ctypes.data
        self._virtaddr_gamma_lut0=self.gamma_lut0.mmio.array.ctypes.data
        self._virtaddr_demosaic0=self.demosaic0.mmio.array.ctypes.data
        self._virtaddr_mipi_csi2_rx_subsyst_0=self.mipi_csi2_rx_subsyst_0.mmio.array.ctypes.data
        self.handle=_pcam5c_lib.pcam_mipi(self._virtaddr_gpio_ip_reset,
                                          self._virtaddr_cam_gpio,
                                          self._virtaddr_v_proc_ss_0,
                                          self._virtaddr_gamma_lut0,
                                          self._virtaddr_demosaic0,
                                          self._virtaddr_mipi_csi2_rx_subsyst_0
                                          )
        return(self.handle)

    def start(self, handle):
        print('Handle:', handle)
        _pcam5c_lib.StartPcam(self.handle)
        print("Camera started")
