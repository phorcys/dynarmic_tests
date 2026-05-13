/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x12345678",
    "R1": "0x00000004",
    "R2": "0x9ABCDEF0",
    "R3": "0x00000008"
  }
}
*/
.text
.global _start
_start:
    sub sp, sp, #16
    mov r4, sp

    ldr r0, =0x12345678
    str r0, [r4], #4
    ldr r0, [sp]
    sub r1, r4, sp

    ldr r2, =0x9ABCDEF0
    str r2, [r4], #4
    ldr r2, [sp, #4]
    sub r3, r4, sp

    add sp, sp, #16
    bkpt #0
