ENTRY(Reset_Handler)

MEMORY
{
    RAM(xrw): ORIGIN = 0x20000000, LENGTH = 8K
    FLASH(rw) : ORIGIN = 0x08000000, LENGTH = 128K
}

_estack = ORIGIN(RAM) + LENGTH(RAM);

HEAP_SIZE = 0x200;
STACK_SIZE = 0x400;

/* Section Definitions */
SECTIONS
{
     /* Startup code with vector table */
    .isr_vector :
    {
        . = ALIGN(4);
        KEEP(*(.isr_vector))
        . = ALIGN(4);
    } > FLASH

    /* The program code and other data */
    .text :
    {
        . = ALIGN(4);
        *(.text*)
        . = ALIGN(4);
        _etext = .;
    } > FLASH

    /* .rodata section to store constant data */
    .rodata :
    {
        . = ALIGN(4);
        *(.rodata*)
        . = ALIGN(4);
    } > FLASH

    .preinit_array :
    {
        . = ALIGN(4);
        PROVIDE_HIDDEN (__preinit_array_start = .);
        KEEP (*(.preinit_array*))
        PROVIDE_HIDDEN (__preinit_array_end = .);
        . = ALIGN(4);
    } > FLASH

    .init_array :
    {
        . = ALIGN(4);
        PROVIDE_HIDDEN (__init_array_start = .);
        KEEP (*(SORT(.init_array.*)))
        KEEP (*(.init_array*))
        PROVIDE_HIDDEN (__init_array_end = .);
        . = ALIGN(4);
    } > FLASH

    .fini_array :
    {
        . = ALIGN(4);
        PROVIDE_HIDDEN (__fini_array_start = .);
        KEEP (*(SORT(.fini_array.*)))
        KEEP (*(.fini_array*))
        PROVIDE_HIDDEN (__fini_array_end = .);
        . = ALIGN(4);
    } > FLASH

    /* .bss section which is used for uninitialized data */
    .bss (NOLOAD) :
    {
        . = ALIGN(4);
        _sbss = .;
        *(.bss*)
        *(COMMON)
        . = ALIGN(4);
        _ebss = .;
    } > RAM

    _sidata = LOADADDR(.data);

    .data :
    {
        . = ALIGN(4);
        _sdata = .;
        *(.data*)
        . = ALIGN(4);
        _edata = .;
    } > RAM AT > FLASH

    /* stack section */
    .stack (NOLOAD):
    {
        . = ALIGN(8);
        PROVIDE(end = .);
        PROVIDE(_end = .);
        . = . + STACK_SIZE;
        . = . + HEAP_SIZE;
        . = ALIGN(8);
    } > RAM
}
