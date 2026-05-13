/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00000055",
    "R1": "0x00000000",
    "R2": "0x00000001",
    "R3": "0x00000066"
  }
}
*/
// Exclusive success followed by CLREX-forced failure.

.text
.arm
.global _start
_start:
    sub sp, sp, #16

    mov r4, #0x55
    str r4, [sp]
    mov r5, #0x66
    str r5, [sp, #4]

    mov r6, sp
    ldrex r0, [r6]
    strex r1, r5, [r6]      @ success => status 0

    add r6, sp, #4
    ldrex r4, [r6]
    clrex
    strex r2, r0, [r6]      @ fail after clrex => status 1
    ldr r3, [sp, #4]

    add sp, sp, #16
    bkpt #0
