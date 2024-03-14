#include <stdint.h>
#include <stdio.h>
#include "main.h"

#define STK_CTRL (*(volatile uint32_t *)0xE000E010)
#define STK_RELOAD (*(volatile uint32_t *)0xE000E014)

extern volatile uint32_t systick_counter;

extern void initialise_monitor_handles(void);

int MAIN(void) {

	STK_CTRL |= 0x00000007;
	STK_RELOAD = 8000u; // each 1 ms
	initialise_monitor_handles();

	LOOP {
		printf("SysTick: %lu ticks\r\n", systick_counter);
		for(uint32_t delay=0u; delay < 8000000u; delay++);
	}

	return 0;
}
