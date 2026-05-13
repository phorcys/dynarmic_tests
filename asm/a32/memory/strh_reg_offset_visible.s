/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x000089AB" }
}
*/
.text
.global _start
_start:
    sub sp, sp, #8
    mov r1, sp
    mov r2, #2
    ldr r3, =0x89AB
    strh r3, [r1, r2]
    ldrh r0, [sp, #2]
    add sp, sp, #8
    bkpt #0
.ltorg
