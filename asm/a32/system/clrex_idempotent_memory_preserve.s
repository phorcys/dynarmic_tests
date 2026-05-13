/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x000000AA",
    "R1": "0x00000001",
    "R2": "0x000000CC",
    "R3": "0x000000CC"
  }
}
*/
// CLREX should be idempotent and should not alter memory by itself.

.text
.arm
.global _start
_start:
    sub sp, sp, #16
    mov r4, #0xAA
    str r4, [sp]
    mov r5, #0xCC
    str r5, [sp, #4]

    mov r6, sp
    ldrex r0, [r6]
    clrex
    clrex
    strex r1, r5, [r6]

    add r6, sp, #4
    ldrex r2, [r6]
    ldr r3, [sp, #4]

    add sp, sp, #16
    bkpt #0
