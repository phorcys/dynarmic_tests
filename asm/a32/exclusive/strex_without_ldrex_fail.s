/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R2": "0x89ABCDEF",
    "R3": "0x12345678",
    "R7": "0x00000001"
  }
}
*/
.text
.global _start
_start:
    sub sp, sp, #16
    ldr r4, =0x12345678
    str r4, [sp]

    mov r5, sp
    ldr r2, =0x89ABCDEF
    strex r7, r2, [r5]
    ldr r3, [sp]

    add sp, sp, #16
    bkpt #0
