/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000000" }
}
*/
.text
.global _start
_start:
    ldr r1, =0xFFFF8000
    usat16 r0, #15, r1
    bkpt #0
.ltorg
