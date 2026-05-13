/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x7FFF0000" }
}
*/
.text
.global _start
_start:
    ldr r1, =0x7FFF0001
    ldr r2, =0x00010000
    qasx r0, r1, r2
    bkpt #0
.ltorg
