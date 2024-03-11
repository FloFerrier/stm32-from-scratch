#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#include "main.h"

#ifndef UTEST
#include "user_led.h"
#include "delay.h"
#else
#include "mock_user_led.h"
#include "mock_delay.h"
#endif

#define STK_CTRL (*(volatile uint32_t *)0xE000E010)
#define STK_RELOAD (*(volatile uint32_t *)0xE000E014)
#define STK_VAL (*(volatile uint32_t *)0xE000E018)
#define STK_CALIB (*(volatile uint32_t *)0xE000E01C)

#ifdef DEBUG
#define ITM_PORT0 (*(volatile uint32_t *)0xE0000000)
#define DWT_CTRL (*(volatile uint32_t *)0xE0001000)
#define DWT_CYCCNT (*(volatile uint32_t *)0xE0001004)
__attribute__((weak)) int _write(int file, char *ptr, int len);
__attribute__((weak)) int __io_putchar(int ch);
static void dwt_pcsample_set(bool enable);
static void dwt_cyccnt_enable(void);
static uint32_t dwt_cyccnt_get(void);
#define PROFILE(code)\
    {\
        dwt_pcsample_set(true);\
        code;\
        dwt_pcsample_set(false);\
    }
#endif //DEBUG

extern volatile uint32_t systick_counter;

/* Blink User Led on Nucleo-f446re board
 * User Led = GPIOA5
 */
int MAIN(void) {

	/* After reset, the CPU clock frequency is 16MHz */

    STK_CTRL |= 0x00000007;
    STK_RELOAD = 16000u; // each 1 ms

	userLed_setup();

	LOOP {
        printf("SysTicks: %lu\r\n", systick_counter);
		userLed_set(USER_LED_STATE_OFF);
		delay_ms(500u);
        userLed_set(USER_LED_STATE_ON);
		delay_ms(500u);
	}

	return 0;
}

#ifdef DEBUG
__attribute__((weak)) int _write(int file, char *ptr, int len) {

	for (uint32_t index = 0; index < len; index++) {
		(void)__io_putchar(*ptr++);
	}
	return len;
}

__attribute__((weak)) int __io_putchar(int ch) {
    while (ITM_PORT0 == 0);
    ITM_PORT0 = (uint32_t)ch;
    return ch;
}

static void dwt_pcsample_set(bool enable) {
    if (enable) {
        DWT_CTRL &= ~(0b1111 << 1u); /* POSTPRESET */
        DWT_CTRL |= (8u << 1u); /* POSTPRESET */
        DWT_CTRL &= ~(1u << 9u); /* CYCTAP */
        DWT_CTRL |= (1u << 12u); /* PCSAMPLENA */
    } else {
        DWT_CTRL &= ~(0b1111 << 1u); /* POSTPRESET */
        DWT_CTRL &= ~(1u << 9u); /* CYCTAP */
        DWT_CTRL &= ~(1u << 12u); /* PCSAMPLENA */
    }
}

static void dwt_cyccnt_enable(void) {
    DWT_CTRL |= (1u << 0);
}

static uint32_t dwt_cyccnt_get(void) {
    return DWT_CYCCNT;
}

#endif //DEBUG
