/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00010000" }
}
*/
.text
.global _start
_start:
    ldr r1, =0x0001FFFF
    usat16 r0, #15, r1
    bkpt #0
.ltorg
