/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x80FF0103" }
}
*/
.text
.global _start
_start:
    ldr r1, =0x80020304
    ldr r2, =0x01030201
    qsub8 r0, r1, r2
    bkpt #0
.ltorg
