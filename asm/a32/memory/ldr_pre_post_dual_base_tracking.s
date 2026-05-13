/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x11111111",
    "R1": "0x00000004",
    "R2": "0x22222222",
    "R3": "0x00000004"
  }
}
*/
.text
.global _start
_start:
    sub sp, sp, #24
    ldr r4, =0x11111111
    str r4, [sp, #4]
    mov r1, sp
    ldr r0, [r1, #4]!
    sub r1, r1, sp

    ldr r4, =0x22222222
    str r4, [sp, #8]
    add r3, sp, #8
    ldr r2, [r3], #-4
    sub r3, r3, sp

    add sp, sp, #24
    bkpt #0
.ltorg
