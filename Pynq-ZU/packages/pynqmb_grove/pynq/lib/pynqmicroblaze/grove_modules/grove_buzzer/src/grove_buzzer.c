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
 * @file grove_buzzer.c
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
#include <grove_buzzer.h>

// Maximum number of Grove Buzzers which can be connected#define
#define MAX_BUZZER 2

struct buzzer_info {
	gpio data;
};
static struct buzzer_info buzzer_infos[MAX_BUZZER];
static int buzzer_info_used = 0;


grove_buzzer grove_buzzer_init_gpio(gpio data) {
	for (int i = 0; i < buzzer_info_used; ++i) {
		if (buzzer_infos[i].data == data)
			return i;
	}
	if (buzzer_info_used == MAX_BUZZER) return -1;
	grove_buzzer next = buzzer_info_used++;
	gpio_set_direction(data, GPIO_OUT);
	buzzer_infos[next].data = data;
	return next;
}

grove_buzzer grove_buzzer_init_pins(int data) {
	return grove_buzzer_init_gpio(
		gpio_open(data));
}

void grove_buzzer_generateTone(grove_buzzer buz, int period_us) {
    // turn-ON speaker
    gpio pb_speaker = buzzer_infos[buz].data;
	gpio_write(pb_speaker, 1);
    delay_us(period_us>>1);
    // turn-OFF speaker
    gpio_write(pb_speaker, 0);
    delay_us(period_us>>1);
}

void grove_buzzer_playTone(grove_buzzer buz, int tone, int duration) { 
    // tone is in us delay
    long i;
    for (i = 0; i < duration * 1000L; i += tone * 2) {
        grove_buzzer_generateTone(buz, tone*2);
    }
}

void grove_buzzer_playNote(grove_buzzer buz, char note, int duration) {

    char names[] = { 'c', 'd', 'e', 'f', 'g', 'a', 'b', 'C', 'D' };
    int tones[] = { 1915, 1700, 1519, 1432, 1275, 1136, 1014, 956, 1702 };
    int i;

    // play the tone corresponding to the note name
    for (i = 0; i < 8; i++) {
        if (names[i] == note) {
          grove_buzzer_playTone(buz, tones[i], duration);
        }
    }
}

void grove_buzzer_melody_demo(grove_buzzer buz) {
    // The number of notes
    int length = 15;
    char notes[] = "ccggaagffeeddc ";
    int beats[] = { 1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 2, 4 };
    int tempo = 300;
    int i;

    for(i = 0; i < length; i++) {
        if(notes[i] == ' ') {
            delay_ms(beats[i] * tempo);
        } else {
            grove_buzzer_playNote(buz, notes[i], beats[i] * tempo);
        }
        // Delay between notes
        delay_ms(tempo / 2);
    }
}
