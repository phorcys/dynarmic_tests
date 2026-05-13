/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000103" }
}
*/
.text
.global _start
_start:
    ldr r1, =0x00020304
    ldr r2, =0x01030201
    uqsub8 r0, r1, r2
    bkpt #0
.ltorg
