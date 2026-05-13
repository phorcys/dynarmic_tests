/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00000142",
    "R1": "0x0000003E",
    "R2": "0x1234573A",
    "R3": "0x00000001",
    "R4": "0x00000142",
    "R5": "0x00000180",
    "R6": "0x00000001"
  }
}
*/
.text
.arm
.global _start
_start:
    sub sp, sp, #0x200
    mov r7, #0x42
    str r7, [sp]

    ldr r8, =helper_table

    ldr r4, [r8]
    mov r0, sp
    mov r1, #0x100
    blx r4
    mov r9, r0

    ldr r4, [r8, #4]
    mov r0, r9
    blx r4
    mov r10, r0

    ldr r4, [r8, #8]
    mov r0, r10
    blx r4
    mov r11, r0

    add r12, r9, #0x7F
    bic r12, r12, #0x7F

    mov r0, r9
    sub r1, r12, r9
    mov r2, r11
    ldr r4, =0x142
    cmp r9, r4
    moveq r3, #1
    movne r3, #0
    mov r4, r10
    mov r5, r12
    ldr r0, =0x1234573A
    cmp r11, r0
    moveq r6, #1
    movne r6, #0
    mov r0, r9
    bkpt #0

slot_add:
    ldr r2, [r0]
    add r2, r2, r1
    str r2, [r0]
    mov r0, r2
    bx lr

identity_helper:
    bx lr

xor_helper:
    ldr r1, =0x12345678
    eor r0, r0, r1
    bx lr

.align 4
helper_table:
    .word slot_add
    .word identity_helper
    .word xor_helper
