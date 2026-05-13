/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x12345678",
    "R1": "0x00000004",
    "R2": "0x89ABCDEF",
    "R3": "0x00000010"
  }
}
*/
.text
.global _start
_start:
    sub sp, sp, #32

    ldr r4, =0x12345678
    str r4, [sp]
    mov r1, sp
    ldr r0, [r1], #4
    sub r1, r1, sp

    ldr r4, =0x89ABCDEF
    str r4, [sp, #12]
    add r3, sp, #12
    ldr r2, [r3], #4
    sub r3, r3, sp

    add sp, sp, #32
    bkpt #0
