/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00007FFF" }
}
*/
.text
.global _start
_start:
    sub sp, sp, #8
    ldr r4, =0x00007FFF
    str r4, [sp, #4]
    mov r1, sp
    mov r2, #4
    ldrsh r0, [r1, r2]
    add sp, sp, #8
    bkpt #0
.ltorg
