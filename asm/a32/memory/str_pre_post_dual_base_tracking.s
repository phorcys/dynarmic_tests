/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x11111111",
    "R1": "0x00000004",
    "R2": "0x22222222",
    "R3": "0x00000008"
  }
}
*/
.text
.global _start
_start:
    sub sp, sp, #24
    mov r1, sp
    ldr r0, =0x11111111
    str r0, [r1, #4]!
    ldr r0, [sp, #4]
    sub r1, r1, sp

    add r3, sp, #12
    ldr r2, =0x22222222
    str r2, [r3], #-4
    ldr r2, [sp, #12]
    sub r3, r3, sp

    add sp, sp, #24
    bkpt #0
.ltorg
