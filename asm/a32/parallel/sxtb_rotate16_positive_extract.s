/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x0000007F" }
}
*/
.text
.global _start
_start:
    ldr r1, =0x007F8000
    sxtb r0, r1, ror #16
    bkpt #0
.ltorg
