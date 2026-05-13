/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0xC0000001" }
}
*/
.text
.global _start
_start:
    ldr r1, =0x80000001
    ssat16 r0, #15, r1
    bkpt #0
.ltorg
