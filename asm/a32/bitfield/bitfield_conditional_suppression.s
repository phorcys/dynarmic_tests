/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00000001",
    "R1": "0x00000000",
    "R2": "0x00000003",
    "R3": "0x00000004"
  }
}
*/
// Conditional execution for bitfield ops must suppress writes when false.

.arch armv7-a
.text
.arm
.global _start
_start:
    mov r0, #0
    cmp r0, #0

    ldr r0, =0x12345678
    bfi r0, r0, #8, #8      @ executes => 0x12347878
    mov r0, #1

    mov r1, #0
    cmp r1, #1
    ldr r4, =0x87654321
    bfieq r1, r4, #8, #8    @ suppressed

    mov r2, #0
    cmp r2, #0
    ldr r4, =0x80000000
    sbfxne r2, r4, #31, #1  @ suppressed
    add r2, r2, #3

    mov r3, #0
    cmp r3, #0
    ldr r4, =0xF0
    ubfxeq r3, r4, #4, #4   @ executes => 0xF
    sub r3, r3, #11         @ => 4

    bkpt #0
