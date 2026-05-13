/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000007" }
}
*/
.text
.global _start
_start:
    ldr r1, =0x00030002
    ldr r2, =0x00010002
    smuad r0, r1, r2
    bkpt #0
.ltorg
