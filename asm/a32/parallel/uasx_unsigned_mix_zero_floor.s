/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x0021000F" }
}
*/
.text
.global _start
_start:
    ldr r1, =0x00010010
    ldr r2, =0x00010020
    uasx r0, r1, r2
    bkpt #0
.ltorg
