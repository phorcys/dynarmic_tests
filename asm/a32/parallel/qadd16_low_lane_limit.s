/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00017FFF" }
}
*/
.text
.global _start
_start:
    ldr r1, =0x00007FFF
    ldr r2, =0x00010000
    qadd16 r0, r1, r2
    bkpt #0
.ltorg
