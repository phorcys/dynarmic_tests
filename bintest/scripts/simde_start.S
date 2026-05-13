.section .text
.global _start
.type _start, %function
_start:
    ldr x0, =__stack_top
    mov sp, x0
    ldr x0, =__bss_start
    ldr x1, =__bss_end
bss_clear:
    cmp x0, x1
    b.ge bss_done
    str xzr, [x0], #8
    b bss_clear
bss_done:
    bl main
    mov x8, #94
    svc #0
    b .
.size _start, . - _start
