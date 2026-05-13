/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00001234",
    "R1": "0x00005678",
    "R2": "0x00009ABC",
    "R3": "0x0000DEF0"
  }
}
*/
.text
.arm
.global _start
_start:
    sub sp, sp, #32

    ldr r4, =0x1234
    strh r4, [sp, #0]
    ldrh r0, [sp, #0]

    ldr r4, =0x5678
    strh r4, [sp, #2]
    ldrh r1, [sp, #2]

    ldr r4, =0x9ABC
    strh r4, [sp, #6]
    ldrh r2, [sp, #6]

    ldr r4, =0xDEF0
    strh r4, [sp, #10]
    ldrh r3, [sp, #10]

    add sp, sp, #32
    bkpt #0
