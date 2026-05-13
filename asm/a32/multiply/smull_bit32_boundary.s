/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000000", "R1": "0x00000001" }
}
*/
.text
.global _start
_start:
    ldr r2, =0x10000
    ldr r3, =0x10000
    smull r0, r1, r2, r3
    bkpt #0
.ltorg
