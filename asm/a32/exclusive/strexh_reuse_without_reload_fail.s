/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00008001",
    "R1": "0x00000000",
    "R2": "0x00000001",
    "R3": "0x0000FFFF"
  }
}
*/
.text
.global _start
_start:
    sub sp, sp, #16
    ldr r4, =0x00008001
    strh r4, [sp]

    mov r5, sp
    ldrexh r0, [r5]

    mov r6, #0xFFFF
    strexh r1, r6, [r5]

    mov r6, #0x1234
    strexh r2, r6, [r5]
    ldrh r3, [sp]

    add sp, sp, #16
    bkpt #0
