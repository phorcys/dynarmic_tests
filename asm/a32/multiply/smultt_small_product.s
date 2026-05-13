/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000006" }
}
*/
.text
.global _start
_start:
    ldr r1, =0x00030000
    ldr r2, =0x00020000
    smultt r0, r1, r2
    bkpt #0
.ltorg
