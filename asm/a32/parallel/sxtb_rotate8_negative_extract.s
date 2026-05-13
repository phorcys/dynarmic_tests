/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0xFFFFFFFF" }
}
*/
.text
.global _start
_start:
    ldr r1, =0x0080FF00
    sxtb r0, r1, ror #8
    bkpt #0
.ltorg
