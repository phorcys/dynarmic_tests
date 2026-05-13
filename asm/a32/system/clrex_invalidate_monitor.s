/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x000000AA",
    "R1": "0x00000001",
    "R2": "0x00000055",
    "R3": "0x000000AA"
  }
}
*/
// A32-only CLREX must invalidate the local exclusive monitor.

.text
.arm
.global _start
_start:
    sub sp, sp, #16
    mov r4, #0xAA
    str r4, [sp]

    mov r5, sp
    ldrex r0, [r5]
    clrex
    mov r2, #0x55
    strex r1, r2, [r5]
    ldr r3, [sp]

    add sp, sp, #16
    bkpt #0
