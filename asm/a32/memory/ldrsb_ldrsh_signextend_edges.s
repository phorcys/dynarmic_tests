/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0xFFFFFFFF",
    "R1": "0x0000007F",
    "R2": "0xFFFF8001",
    "R3": "0x00007FFE"
  }
}
*/
.text
.arm
.global _start
_start:
    sub sp, sp, #32
    add r4, sp, #8

    mov r5, #0xFF
    strb r5, [r4, #0]
    ldrsb r0, [r4, #0]

    mov r5, #0x7F
    strb r5, [r4, #1]
    ldrsb r1, [r4, #1]

    ldr r5, =0x00008001
    strh r5, [r4, #4]
    ldrsh r2, [r4, #4]

    ldr r5, =0x00007FFE
    strh r5, [r4, #6]
    ldrsh r3, [r4, #6]

    add sp, sp, #32
    bkpt #0
