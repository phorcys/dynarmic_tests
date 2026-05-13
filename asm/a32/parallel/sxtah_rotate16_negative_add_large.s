/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x1FFF8000" }
}
*/
.text
.global _start
_start:
    ldr r1, =0x20000000
    ldr r2, =0x80000000
    sxtah r0, r1, r2, ror #16
    bkpt #0
.ltorg
