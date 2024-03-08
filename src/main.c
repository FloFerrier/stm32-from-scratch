#include <stdint.h>
#include <stdbool.h>
#include "main.h"

#ifndef UTEST
#include "user_led.h"
#include "delay.h"
#else
#include "mock_user_led.h"
#include "mock_delay.h"
#endif

#ifndef DEBUG
#define DWT_CTRL (*(volatile uint32_t *)0xE0001000)
#define DWT_CYCCNT (*(volatile uint32_t *)0xE0001004)
static void dwt_pcsample_set(bool enable);
static void dwt_cyccnt_enable(void);
static uint32_t dwt_cyccnt_get(void);
#define PROFILE(code)               \
    {                               \
        dwt_pcsample_enable(true);  \
        code;                       \
        dwt_pcsample_enable(false); \
    }
#endif //DEBUG

/* Blink User Led on Nucleo-f446re board
 * User Led = GPIOA5
 */
int MAIN(void) {

	/* After reset, the CPU clock frequency is 16MHz */

	userLed_setup();

	LOOP {
		userLed_set(USER_LED_STATE_OFF);
		delay_ms(500u);
        userLed_set(USER_LED_STATE_ON);
		delay_ms(500u);
	}

	return 0;
}

#ifndef DEBUG
static void dwt_pcsample_set(bool enable) {
    if (enable) {
        DWT_CTRL &= ~(0b111 << 1u); /* POSTPRESET */
        DWT_CTRL |= (0b11 << 1u); /* POSTPRESET */
        DWT_CTRL |= (0b1 << 9u); /* CYCTAP */
        DWT_CTRL |= (0b1 << 12u); /* PCSAMPLENA */
    } else {
        DWT_CTRL &= ~(0b111 << 1u); /* POSTPRESET */
        DWT_CTRL &= ~(0b1 << 9u); /* CYCTAP */
        DWT_CTRL &= ~(0b1 << 12u); /* PCSAMPLENA */
    }
}

static void dwt_cyccnt_enable(void) {
    DWT_CTRL |= (0b1 << 0);
}

static uint32_t dwt_cyccnt_get(void) {
    return DWT_CYCCNT;
}

#endif //DEBUG
