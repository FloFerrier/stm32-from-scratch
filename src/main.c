#include <stdint.h>
#include <stdio.h>
#include "main.h"

extern void initialise_monitor_handles(void);

int MAIN(void) {

	initialise_monitor_handles();

	LOOP {
		printf("Hello world\r\n");
	}

	return 0;
}
