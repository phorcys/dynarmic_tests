/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0xFF0130FF" }
}
*/
.text
.global _start
_start:
    ldr r1, =0xFF0010F0
    ldr r2, =0x01012020
    uqadd8 r0, r1, r2
    bkpt #0
.ltorg
