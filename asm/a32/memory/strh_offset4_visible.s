/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00009ABC" }
}
*/
.text
.global _start
_start:
    sub sp, sp, #8
    ldr r1, =0x9ABC
    strh r1, [sp, #4]
    ldrh r0, [sp, #4]
    add sp, sp, #8
    bkpt #0
.ltorg
