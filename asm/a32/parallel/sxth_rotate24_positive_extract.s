/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000100" }
}
*/
.text
.global _start
_start:
    ldr r1, =0x007F0001
    sxth r0, r1, ror #24
    bkpt #0
.ltorg
