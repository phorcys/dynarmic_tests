/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00000011",
    "R1": "0x00000022",
    "R2": "0x00000033",
    "R3": "0x00002233"
  }
}
*/
.text
.arm
.global _start
_start:
    sub sp, sp, #32
    add r4, sp, #8

    mov r5, #0x11
    strb r5, [r4, #0]
    ldrb r0, [r4, #0]

    mov r5, #0x22
    strb r5, [r4, #1]
    ldrb r1, [r4, #1]

    mov r5, #0x33
    strb r5, [r4, #4]
    ldrb r2, [r4, #4]

    mov r5, #0x22
    strb r5, [r4, #6]
    ldrb r3, [r4, #4]
    ldrb r5, [r4, #6]
    orr r3, r3, r5, lsl #8

    add sp, sp, #32
    bkpt #0
