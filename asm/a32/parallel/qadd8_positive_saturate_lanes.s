/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x7F122334" }
}
*/
.text
.global _start
_start:
    ldr r1, =0x7F102030
    ldr r2, =0x01020304
    qadd8 r0, r1, r2
    bkpt #0
.ltorg
