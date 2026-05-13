/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00005678" }
}
*/
.text
.global _start
_start:
    sub sp, sp, #8
    ldr r4, =0x12345678
    str r4, [sp, #4]
    mov r1, sp
    mov r2, #4
    ldrh r0, [r1, r2]
    add sp, sp, #8
    bkpt #0
.ltorg
