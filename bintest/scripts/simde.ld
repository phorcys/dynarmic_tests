ENTRY(_start)

/* Memory layout for SIMDe tests - needs more space for vectors */
MEMORY
{
    RAM (rwx) : ORIGIN = 0x400000, LENGTH = 16M
}

SECTIONS
{
    . = ORIGIN(RAM);

    .text : {
        *(.text)
        *(.text.*)
    } > RAM

    .rodata : {
        *(.rodata)
        *(.rodata.*)
    } > RAM

    .data : {
        *(.data)
        *(.data.*)
    } > RAM

    .bss : {
        __bss_start = .;
        *(.bss)
        *(.bss.*)
        *(COMMON)
        . = ALIGN(8);
        __bss_end = .;
    } > RAM

    .heap : {
        . = ALIGN(16);
        __heap_start = .;
        . = . + 4M;
        __heap_end = .;
    } > RAM

    /* Stack at end of RAM region, grows downward */
    .stack (NOLOAD) : {
        . = ALIGN(16);
        . = . + 256K;  /* 256KB stack for vector tests */
        __stack_top = .;
    } > RAM
}
