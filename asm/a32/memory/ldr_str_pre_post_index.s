/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x11223344",
    "R1": "0x55667788",
    "R2": "0x00000010",
    "R3": "0x00000018"
  }
}
*/
.text
.arm
.global _start
_start:
    sub sp, sp, #32

    ldr r4, =0x11223344
    add r5, sp, #8
    str r4, [r5, #8]!
    ldr r0, [r5]
    sub r2, r5, sp

    ldr r4, =0x55667788
    add r5, sp, #16
    str r4, [r5], #8
    ldr r1, [sp, #16]
    sub r3, r5, sp

    add sp, sp, #32
    bkpt #0
