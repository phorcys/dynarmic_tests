/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0xFFFFFFFA" }
}
*/
.text
.global _start
_start:
    ldr r1, =0x00030000
    ldr r2, =0xFFFE0000
    smulwt r0, r1, r2
    bkpt #0
.ltorg
