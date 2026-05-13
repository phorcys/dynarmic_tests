/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x20001234" }
}
*/
.text
.global _start
_start:
    ldr r1, =0x20000000
    ldr r2, =0x00001234
    uxtah r0, r1, r2
    bkpt #0
.ltorg
