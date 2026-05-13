/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x000F0000" }
}
*/
.text
.global _start
_start:
    ldr r1, =0x00100005
    ldr r2, =0x00010020
    uqsub16 r0, r1, r2
    bkpt #0
.ltorg
