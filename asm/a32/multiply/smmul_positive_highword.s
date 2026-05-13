/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000010" }
}
*/
.text
.global _start
_start:
    ldr r1, =0x10000000
    ldr r2, =0x00000100
    smmul r0, r1, r2
    bkpt #0
.ltorg
