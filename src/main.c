#include "main.h"
#include <stdint.h>
#include <stdio.h>
#include <FreeRTOS.h>
#include <stm32f1xx_hal.h>
#include <task.h>

extern void initialise_monitor_handles(void);
void HAL_MspInit(void);

int MAIN(void) {

	(void)HAL_Init;

	initialise_monitor_handles();

	LOOP {
		printf("Hello World\r\n");
		for(uint32_t delay=0u; delay < 8000000u; delay++);
	}

	return 0;
}

void HAL_MspInit(void) {
	__HAL_RCC_SYSCFG_CLK_ENABLE();
    __HAL_RCC_PWR_CLK_ENABLE();

    HAL_NVIC_SetPriority(PendSV_IRQn, 15, 0);
}
