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
    ldr r1, =0x5678
    strh r1, [sp, #2]
    ldrh r0, [sp, #2]
    add sp, sp, #8
    bkpt #0
.ltorg
