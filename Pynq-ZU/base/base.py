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


__author__ = "Giuseppe Natale"
__copyright__ = "Copyright 2020, Xilinx"
__email__ = "pynq_support@xilinx.com"


import pynq
import pynq.lib
import time
import warnings
from math import isclose
from pynq.lib.logictools import TraceAnalyzer
from pynq.lib.video.clocks import *
from .constants import *


class BaseOverlay(pynq.Overlay):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        if self.is_loaded():
            self.iop_pmod0.mbtype = "Pmod"
            self.iop_pmod1.mbtype = "Pmod"
            self.iop_rpi.mbtype = "Rpi"

            self.PMOD0 = self.iop_pmod0.mb_info
            self.PMOD1 = self.iop_pmod1.mb_info
            self.PMODA = self.PMOD0
            self.PMODB = self.PMOD1
            self.RPI = self.iop_rpi.mb_info

            self.audio = self.audio_codec_ctrl_0
            self.audio.configure(iic_index=5)

            self.leds = self.gpio_leds.channel1
            self.leds.setdirection('out')
            self.leds.setlength(4)
            self.rgbleds = [pynq.lib.RGBLED(i, "rgbleds") for i in range(2)]
            self.buttons = self.gpio_btns.channel1
            self.buttons.setdirection('in')
            self.buttons.setlength(4)
            self.switches = self.gpio_sws.channel1
            self.switches.setdirection('in')
            self.switches.setlength(4)

            self.iop_grove.mbtype = "GC"
            self.GC = self.iop_grove.mb_info

            self.trace_rpi = TraceAnalyzer(
                self.trace_analyzer_pi.description['ip'],
                PYNQZU_RPI_SPECIFICATION)
            self.trace_pmod0 = TraceAnalyzer(
                self.trace_analyzer_pmod0.description['ip'],
                PYNQZU_PMODA_SPECIFICATION)
            self.trace_pmod1 = TraceAnalyzer(
                self.trace_analyzer_pmod1.description['ip'],
                PYNQZU_PMODB_SPECIFICATION)
                
        pynq.lib.pynqmicroblaze.bsp.add_module_path(
            '/pynq/lib/pynqmicroblaze/grove_modules')

    def download(self):
        super().download()
        self._check_syzygy_vio()
        self._init_clocks()

    def _init_clocks(self):
        # Wait for AXI reset to de-assert
        time.sleep(0.2)
        # Deassert HDMI clock reset
        self.hdmi_tx_control.channel2[0].write(1)
        # Wait 200 ms for the clock to come out of reset
        time.sleep(0.2)

        self.video.phy.vid_phy_controller.initialize()
        self.video.hdmi_in.frontend.set_phy(
            self.video.phy.vid_phy_controller)
        self.video.hdmi_out.frontend.set_phy(
            self.video.phy.vid_phy_controller)
        dp159 = DP159(self.HDMI_CTL_axi_iic, 0x5C)
        si = SI_5324C(self.HDMI_CTL_axi_iic, 0x68)
        self.video.hdmi_out.frontend.clocks = [dp159, si]
        if((self.hdmi_tx_control.read(0)) == 0):
            self.hdmi_tx_control.write(0, 1)

    def _check_syzygy_vio(self):
        syzygy_vio = pynq.pmbus.get_rails()["SYZYGY_VIO"]
        if isclose(syzygy_vio.voltage.value, 0, abs_tol=0.5):
            warnings.warn("SYZYGY_VIO is currently disabled, and as a "
                          "consequence on-board buttons and switches are also "
                          "disabled. This is possibly the result of an "
                          "incompatible voltage between the two connected "
                          "SYZYGY peripherals. Please restart the board after "
                          "having removed one of the two.", UserWarning)
