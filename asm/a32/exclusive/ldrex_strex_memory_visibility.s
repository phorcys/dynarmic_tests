/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x12345678",
    "R1": "0x00000000",
    "R2": "0x89ABCDEF",
    "R3": "0x89ABCDEF"
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
    ldrex r0, [r5]
    ldr r2, =0x89ABCDEF
    strex r1, r2, [r5]
    ldr r3, [sp]

    add sp, sp, #16
    bkpt #0
