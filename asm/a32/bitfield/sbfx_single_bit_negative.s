/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0xFFFFFFFF" }
}
*/
.text
.global _start
_start:
    ldr r1, =0x00000008
    sbfx r0, r1, #3, #1
    bkpt #0
.ltorg
