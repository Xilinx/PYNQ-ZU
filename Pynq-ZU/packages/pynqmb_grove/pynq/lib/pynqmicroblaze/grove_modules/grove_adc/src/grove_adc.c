/******************************************************************************
 *  Copyright (c) 2020, Xilinx, Inc.
 *  All rights reserved.
 * 
 *  Redistribution and use in source and binary forms, with or without 
 *  modification, are permitted provided that the following conditions are met:
 *
 *  1.  Redistributions of source code must retain the above copyright notice, 
 *     this list of conditions and the following disclaimer.
 *
 *  2.  Redistributions in binary form must reproduce the above copyright 
 *      notice, this list of conditions and the following disclaimer in the 
 *      documentation and/or other materials provided with the distribution.
 *
 *  3.  Neither the name of the copyright holder nor the names of its 
 *      contributors may be used to endorse or promote products derived from 
 *      this software without specific prior written permission.
 *
 *  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 *  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, 
 *  THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR 
 *  PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR 
 *  CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, 
 *  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, 
 *  PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
 *  OR BUSINESS INTERRUPTION). HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, 
 *  WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR 
 *  OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF 
 *  ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 *****************************************************************************/
/******************************************************************************
 *
 *
 * @file grove_adc.c
 *
 * This class defines various functions (methods) which can be compiled into a
 * set of library functions.
 *
 * <pre>
 * MODIFICATION HISTORY:
 *
 * Ver   Who  Date     Changes
 * ----- --- ------- -----------------------------------------------
 * 1.00a pp  11/23/20 release
 *
 * </pre>
 *
 *****************************************************************************/

#include <grove_adc.h>
#include <i2c.h>
#include <xil_types.h>

#define IIC_ADDRESS 0x50

// VRef = Va measured on the board
#define V_REF 3.10

// ADC Registers
#define REG_ADDR_RESULT        0x00
#define REG_ADDR_CONFIG        0x02

#define MAX_ADC 2

struct grove_adc_pin_info {
	int sda;
	int scl;
};

static struct grove_adc_pin_info pin_info[MAX_ADC];
static int num_adcs;

// Read from a Register
u32 read_adc(grove_adc device, u8 reg){
   u8 data_buffer[2];
   u32 sample;

   data_buffer[0] = reg; // Set the address pointer register
   i2c_write(device, IIC_ADDRESS, data_buffer, 1);

   i2c_read(device, IIC_ADDRESS,data_buffer,2);
   sample = ((data_buffer[0]&0x0f) << 8) | data_buffer[1];
   return sample;
}


// Write a number of bytes to a Register
// Maximum of 2 data bytes can be written in one transaction
void write_adc(grove_adc device, u8 reg, u32 data, u8 bytes){
   u8 data_buffer[3];
   data_buffer[0] = reg;
   if(bytes ==2){
      data_buffer[1] = data & 0x0f; // Bits 11:8
      data_buffer[2] = data & 0xff; // Bits 7:0
   }else{
      data_buffer[1] = data & 0xff; // Bits 7:0
   }

   i2c_write(device, IIC_ADDRESS, data_buffer, bytes+1);

}

grove_adc grove_adc_init_pins(int sda, int scl) {
//	for (int i = 0; i < num_adcs; ++i) {
//		if (pin_info[i].sda == sda and pin_info[i].scl == scl) {
//			return i;
//		}
//	}
	i2c device = i2c_open(sda, scl);
	write_adc(device, REG_ADDR_CONFIG, 0x20, 1);
	return device;

}

unsigned int grove_adc_read_raw(grove_adc device) {
	return read_adc(device, REG_ADDR_RESULT);
}

float grove_adc_read(grove_adc device) {
	unsigned int raw = grove_adc_read_raw(device);
	return (raw * V_REF) / 2048;
}

