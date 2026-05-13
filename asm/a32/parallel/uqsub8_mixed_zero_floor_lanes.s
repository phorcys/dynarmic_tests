/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x000F1E00" }
}
*/
.text
.global _start
_start:
    ldr r1, =0x00102030
    ldr r2, =0x01010240
    uqsub8 r0, r1, r2
    bkpt #0
.ltorg
