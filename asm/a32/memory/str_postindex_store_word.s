/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x12345678" }
}
*/
.text
.global _start
_start:
    sub sp, sp, #16
    mov r1, sp
    ldr r0, =0x12345678
    str r0, [r1], #4
    ldr r2, [sp]
    mov r0, r2
    add sp, sp, #16
    bkpt #0
.ltorg
