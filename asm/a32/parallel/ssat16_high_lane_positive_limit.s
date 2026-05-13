/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x3FFF0001" }
}
*/
.text
.global _start
_start:
    ldr r1, =0x7FFF0001
    ssat16 r0, #15, r1
    bkpt #0
.ltorg
