/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000010" }
}
*/
.text
.global _start
_start:
    ldr r1, =0x00010020
    ldr r2, =0x00020010
    uqsub16 r0, r1, r2
    bkpt #0
.ltorg
