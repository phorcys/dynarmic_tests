/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000000" }
}
*/
.text
.global _start
_start:
    ldr r1, =0x12345678
    ldr r2, =0x12345678
    uqsub8 r0, r1, r2
    bkpt #0
.ltorg
