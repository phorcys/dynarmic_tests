/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x80000002" }
}
*/
.text
.global _start
_start:
    ldr r1, =0x80000001
    ldr r2, =0x00010000
    qsax r0, r1, r2
    bkpt #0
.ltorg
