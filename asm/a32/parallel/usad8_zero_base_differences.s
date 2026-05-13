/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x0000000A" }
}
*/
.text
.global _start
_start:
    ldr r1, =0x01020304
    ldr r2, =0x00000000
    usad8 r0, r1, r2
    bkpt #0
.ltorg
