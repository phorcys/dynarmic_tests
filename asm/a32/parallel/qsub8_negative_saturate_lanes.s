/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x80808080" }
}
*/
.text
.global _start
_start:
    ldr r1, =0x80808080
    ldr r2, =0x01010101
    qsub8 r0, r1, r2
    bkpt #0
.ltorg
