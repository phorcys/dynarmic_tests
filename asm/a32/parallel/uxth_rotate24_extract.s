/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00004411" }
}
*/
.text
.global _start
_start:
    ldr r1, =0x11223344
    uxth r0, r1, ror #24
    bkpt #0
.ltorg
