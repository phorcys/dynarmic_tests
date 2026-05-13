/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x7F7F7F7F" }
}
*/
.text
.global _start
_start:
    ldr r1, =0x7F7F7F7F
    ldr r2, =0xFFFFFFFF
    qsub8 r0, r1, r2
    bkpt #0
.ltorg
