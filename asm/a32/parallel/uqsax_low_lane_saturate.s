/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x0000FFFF" }
}
*/
.text
.global _start
_start:
    ldr r1, =0x0001FFFF
    ldr r2, =0x00008000
    uqsax r0, r1, r2
    bkpt #0
.ltorg
