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
 * @file grove_ledbar.c
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


#include <grove_ledbar.h>
#include <timer.h>

#define GLB_CMDMODE 0x00
#define MAX_LEDBAR 4
struct ledbar_info {
	gpio clk;
	gpio data;
};

static struct ledbar_info ledbar_infos[MAX_LEDBAR];
static int ledbar_info_used = 0;

grove_ledbar grove_ledbar_init_gpio(gpio data, gpio clk) {
	for (int i = 0; i < ledbar_info_used; ++i) {
		if (ledbar_infos[i].clk == clk && 
		    ledbar_infos[i].data == data)
			return i;
	}
	if (ledbar_info_used == MAX_LEDBAR) return -1;
	grove_ledbar next = ledbar_info_used++;
	gpio_set_direction(data, GPIO_OUT);
	gpio_set_direction(clk, GPIO_OUT);
	ledbar_infos[next].clk = clk;
	ledbar_infos[next].data = data;
	return next;
}

grove_ledbar grove_ledbar_init_pins(int data, int clk) {
	return grove_ledbar_init_gpio(
		gpio_open(data),
		gpio_open(clk));
}

void send_data(grove_ledbar l, unsigned char data){
	gpio gpio_clk = ledbar_infos[l].clk;
	gpio gpio_data = ledbar_infos[l].data;
	int clkval = 0;

	gpio_write(gpio_data, 0);
	// First toggle the clock 8 times
	for (int i = 0; i < 8; ++i) {
		clkval ^= 1;
		gpio_write(gpio_clk, clkval);
	}

	// Working in 8-bit mode
	for (int i = 0; i < 8; i++){
		/*
		 * Read each bit of the data to be sent MSB first
		 * Write it to the data_pin
		 */
		gpio_write(gpio_data, data& 0x80?1:0);
		clkval ^= 1;
		gpio_write(gpio_clk, clkval);

		// Shift Incoming data to fetch next bit
		data = data << 1;
	}
}

void latch_data(grove_ledbar l){
	gpio gpio_data = ledbar_infos[l].data;
	gpio_write(gpio_data, 0);
	delay_ms(10);

	// Generate four pulses on the data pin as per data sheet
	for (int i = 0; i < 4; i++){
		gpio_write(gpio_data, 1);
		gpio_write(gpio_data, 0);
	}
}

void grove_ledbar_set_raw(grove_ledbar l, unsigned char* brightness) {
	send_data(l, GLB_CMDMODE);

	for (int i = 0; i < 10; i++){
		send_data(l, brightness[9-i]);
	}
	// Two extra empty bits for padding the command to the correct length
	send_data(l, 0x00);
	send_data(l, 0x00);

	latch_data(l);
}

void grove_ledbar_set_level(grove_ledbar l, int level, unsigned char intensity,
                      int inverse) {
	unsigned char led_data[10];
	for (int i = 0; i < 10; ++i) {
		unsigned char led_value = i < level? intensity: 0;
		if (inverse) {
			led_data[9-i] = led_value;
		} else {
			led_data[i] = led_value;
		}
	}
	grove_ledbar_set_raw(l, led_data);
}

