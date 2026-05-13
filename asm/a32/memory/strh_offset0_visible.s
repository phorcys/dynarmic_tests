/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00001234" }
}
*/
.text
.global _start
_start:
    sub sp, sp, #8
    ldr r1, =0x1234
    strh r1, [sp]
    ldrh r0, [sp]
    add sp, sp, #8
    bkpt #0
.ltorg
