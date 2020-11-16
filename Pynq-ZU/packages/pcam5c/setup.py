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

from setuptools import setup, find_packages, Distribution
from setuptools.command.build_ext import build_ext
from distutils.file_util import copy_file
import os

# Requirement
required = [
    'pynq>=2.6.0'
]


# Extend package files by directory or by file
def extend_package(data_list):
    for data in data_list:
        if os.path.isdir(data):
            package_files.extend(
                [os.path.join("..", root, f)
                 for root, _, files in os.walk(data) for f in files]
            )
        elif os.path.isfile(data):
            package_files.append(os.path.join("..", data))

# Extend package files
package_files = []
extend_package(
    ["embeddedsw/XilinxProcessorIPLib/drivers/v_hdmi_common/src",
     "embeddedsw/XilinxProcessorIPLib/drivers/v_hdmirxss/src",
     "embeddedsw/XilinxProcessorIPLib/drivers/v_hdmirx/src",
     "embeddedsw/XilinxProcessorIPLib/drivers/v_hdmitxss/src",
     "embeddedsw/XilinxProcessorIPLib/drivers/v_hdmitx/src",
     "embeddedsw/XilinxProcessorIPLib/drivers/video_common/src",
     "embeddedsw/XilinxProcessorIPLib/drivers/vphy/src",
     "embeddedsw/XilinxProcessorIPLib/drivers/vtc/src",
     "embeddedsw/XilinxProcessorIPLib/drivers/iic/src",
     "embeddedsw/XilinxProcessorIPLib/drivers/gpio/src",
     "embeddedsw/XilinxProcessorIPLib/drivers/iicps/src",
     "embeddedsw/XilinxProcessorIPLib/drivers/scugic/src",
     "embeddedsw/XilinxProcessorIPLib/drivers/axivdma/src",
     "embeddedsw/XilinxProcessorIPLib/drivers/mipicsiss/src",
     "embeddedsw/XilinxProcessorIPLib/drivers/csi/src",
     "embeddedsw/XilinxProcessorIPLib/drivers/dphy/src",
     "embeddedsw/lib/bsp/standalone/src",
     "embeddedsw_lib.mk",
     "common",
     "_pcam5c",
     'pcam5c'
     ])


class BuildExtension(build_ext):
    def run_make(self, src_path, dst_path, output_lib):
        self.spawn(['make', 'PYNQ_BUILD_ARCH={}'.format("aarch64"),
                    '-C', src_path])
        os.makedirs(os.path.join(self.build_lib, dst_path), exist_ok=True)
        copy_file(src_path + output_lib,
                  os.path.join(self.build_lib, dst_path, output_lib))

    def run(self):
        self.run_make("_pcam5c/", "pcam5c", "libpcam5c.so")
        build_ext.run(self)


# Enforce platform-dependent distribution
class BinaryDistribution(Distribution):
    def has_ext_modules(self):
        return True


setup(name='pynq_zu_pcam5c',
      version="1.0",
      description='pcam5 driver for Pynq-ZU',
      author='Xilinx PYNQ Development Team',
      author_email='pynq_support@xilinx.com',
      url='https://github.com/Xilinx/PYNQ-ZU',
      packages=find_packages(),
      cmdclass={
          "build_ext": BuildExtension,
          },
      distclass=BinaryDistribution,
      python_requires='>=3.6.0',
      install_requires=required,
      package_data={
          'pcam5c': package_files,
      },
      entry_points={
          "pynq.lib": "pcam5c = pcam5c"
      },
      ext_modules=[],
      zip_safe=False,
      license="BSD 3-Clause"
      )
