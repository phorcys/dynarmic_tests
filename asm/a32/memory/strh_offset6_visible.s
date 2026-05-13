/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x0000DEF0" }
}
*/
.text
.global _start
_start:
    sub sp, sp, #8
    ldr r1, =0xDEF0
    strh r1, [sp, #6]
    ldrh r0, [sp, #6]
    add sp, sp, #8
    bkpt #0
.ltorg
