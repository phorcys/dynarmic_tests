/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x12345678",
    "R1": "0x00000004"
  }
}
*/
.text
.global _start
_start:
    sub sp, sp, #16
    ldr r4, =0x12345678
    str r4, [sp]
    mov r1, sp
    ldr r0, [r1], #4
    sub r1, r1, sp
    add sp, sp, #16
    bkpt #0
.ltorg
