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
 * @file grove_led.c
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

#include "timer.h"
#include "gpio.h"
#include <grove_led.h>
#include <xio_switch.h>

// Maximum number of Grove ledzers which can be connected#define
#define MAX_LED 2

struct leds_info {
	gpio data;
};

static struct leds_info leds_infos[MAX_LED];
static int leds_info_used = 0;


grove_led grove_led_init_gpio(gpio data) {
	for (int i = 0; i < leds_info_used; ++i) {
		if (leds_infos[i].data == data)
			return i;
	}
	if (leds_info_used == MAX_LED) return -1;
	grove_led next = leds_info_used++;
	gpio_set_direction(data, GPIO_OUT);
	leds_infos[next].data = data;
	return next;
}

grove_led grove_led_init_pins(int data) {
	return grove_led_init_gpio(
		gpio_open(data));
}

void grove_led_pwm_generate(grove_led led, int pwm_pin, int period, int duty) {
    set_pin(pwm_pin,PWM0);
	timer_pwm_generate(led, period, duty);
}

void grove_led_pwm_stop(grove_led led, int pwm_pin) {
    timer_pwm_stop(pwm_pin);
}

void grove_led_led_write(grove_led led, int pin, int value) {
    gpio led_dev=gpio_open(pin);
	gpio_set_direction(led_dev, GPIO_OUT);
	gpio_write(led_dev, value);
}

