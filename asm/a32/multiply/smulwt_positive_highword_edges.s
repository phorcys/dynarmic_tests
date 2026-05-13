/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000002" }
}
*/
.text
.global _start
_start:
    ldr r1, =0x00020000
    ldr r2, =0x00018000
    smulwt r0, r1, r2
    bkpt #0
.ltorg
