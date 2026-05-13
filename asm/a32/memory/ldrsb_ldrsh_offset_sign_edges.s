/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0xFFFFFF80",
    "R1": "0xFFFF8001",
    "R2": "0x0000007F",
    "R3": "0x00007FFF"
  }
}
*/
.text
.global _start
_start:
    sub sp, sp, #16

    mov r4, #0x7F
    strb r4, [sp]
    mov r4, #0x80
    strb r4, [sp, #1]

    movw r4, #0x7FFF
    strh r4, [sp, #4]
    ldr r4, =0x8001
    strh r4, [sp, #6]

    ldrsb r0, [sp, #1]
    ldrsh r1, [sp, #6]
    ldrsb r2, [sp]
    ldrsh r3, [sp, #4]

    add sp, sp, #16
    bkpt #0
