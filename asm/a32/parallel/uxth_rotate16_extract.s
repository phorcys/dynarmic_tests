/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00001122" }
}
*/
.text
.global _start
_start:
    ldr r1, =0x11223344
    uxth r0, r1, ror #16
    bkpt #0
.ltorg
