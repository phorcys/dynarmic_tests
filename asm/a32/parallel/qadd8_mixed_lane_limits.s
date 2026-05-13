/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x7FFF7F80" }
}
*/
.text
.global _start
_start:
    ldr r1, =0x7F807F80
    ldr r2, =0x017F0180
    qadd8 r0, r1, r2
    bkpt #0
.ltorg
