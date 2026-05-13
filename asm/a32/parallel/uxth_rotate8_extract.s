/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00002233" }
}
*/
.text
.global _start
_start:
    ldr r1, =0x11223344
    uxth r0, r1, ror #8
    bkpt #0
.ltorg
