/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0xFFFF0030" }
}
*/
.text
.global _start
_start:
    ldr r1, =0xFFFF0010
    ldr r2, =0x00010020
    uqadd16 r0, r1, r2
    bkpt #0
.ltorg
