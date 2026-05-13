/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00EAA44C",
    "R1": "0x00000001",
    "R2": "0x00000100",
    "R3": "0x00000001",
    "R4": "0x00000387",
    "R5": "0x00000001"
  }
}
*/
.text
.arm
.global _start
_start:
    sub sp, sp, #0x800

    add r5, sp, #0x77
    str r5, [sp]

    mov r0, sp
    ldr r6, =accumulate_minus_one
    mov r1, #0x380
    mov r2, #8
    blx r6
    mov r9, r0

    mov r0, sp
    ldr r6, =read_slot
    blx r6
    mov r10, r0

    add r11, r10, #0xFF
    bic r11, r11, #0xFF
    add r12, r11, #0x100

    ldr r0, =0x00EAA44C
    str r0, [r11]
    mov r0, #0x0C
    str r0, [r11, #4]
    str r11, [r11, #8]
    str r12, [r11, #0x10]

    ldr r0, [r11]
    ldr r1, [r11, #8]
    cmp r1, r11
    moveq r1, #1
    movne r1, #0

    ldr r2, [r11, #0x10]
    sub r2, r2, r11

    cmp r9, r10
    moveq r3, #1
    movne r3, #0

    sub r4, r10, r5
    sub r5, r11, r10
    cmp r5, #0
    moveq r5, #0
    movne r5, #1
    bkpt #0

accumulate_minus_one:
    ldr r3, [r0]
    add r3, r3, r1
    add r3, r3, r2
    sub r3, r3, #1
    str r3, [r0]
    mov r0, r3
    bx lr

read_slot:
    ldr r0, [r0]
    bx lr

.align 4
