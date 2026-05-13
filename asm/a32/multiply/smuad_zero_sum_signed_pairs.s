/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000002" }
}
*/
.text
.global _start
_start:
    ldr r1, =0x0001FFFF
    ldr r2, =0x0001FFFF
    smuad r0, r1, r2
    bkpt #0
.ltorg
