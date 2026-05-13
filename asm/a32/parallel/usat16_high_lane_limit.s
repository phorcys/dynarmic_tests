/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000001" }
}
*/
.text
.global _start
_start:
    ldr r1, =0xFFFF0001
    usat16 r0, #15, r1
    bkpt #0
.ltorg
