/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x0000FFFF" }
}
*/
.text
.global _start
_start:
    ldr r1, =0x0000FFF0
    ldr r2, =0x00000020
    uqadd16 r0, r1, r2
    bkpt #0
.ltorg
