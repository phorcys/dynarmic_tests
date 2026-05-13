/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x12345678",
    "R1": "0x00000008",
    "R2": "0x89ABCDEF",
    "R3": "0x00000014"
  }
}
*/
.text
.global _start
_start:
    sub sp, sp, #32

    ldr r0, =0x12345678
    mov r1, sp
    str r0, [r1, #8]!
    sub r1, r1, sp

    ldr r2, =0x89ABCDEF
    add r3, sp, #16
    str r2, [r3], #4
    sub r3, r3, sp

    add sp, sp, #32
    bkpt #0
