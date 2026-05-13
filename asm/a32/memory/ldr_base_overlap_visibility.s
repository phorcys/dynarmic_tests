/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x11111111",
    "R1": "0x00000004",
    "R2": "0x11111111",
    "R3": "0x00000004"
  }
}
*/
// Base/result overlap without writeback plus visible base updates on indexed loads.

.text
.arm
.global _start
_start:
    sub sp, sp, #16

    ldr r4, =0x11111111
    str r4, [sp, #4]

    add r0, sp, #4
    ldr r0, [r0]            @ base/result overlap without writeback

    mov r6, sp
    ldr r2, [r6, #4]!
    sub r1, r6, sp

    add r7, sp, #8
    str r4, [sp, #8]
    ldr r5, [r7, #-4]!
    sub r3, r7, sp

    add sp, sp, #16
    bkpt #0
