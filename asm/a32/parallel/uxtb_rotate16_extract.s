/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000022" }
}
*/
.text
.global _start
_start:
    ldr r1, =0x11223344
    uxtb r0, r1, ror #16
    bkpt #0
.ltorg
