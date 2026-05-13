/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x7FFF7FFF" }
}
*/
.text
.global _start
_start:
    ldr r1, =0x00017FFF
    ldr r2, =0x00008000
    qsax r0, r1, r2
    bkpt #0
.ltorg
