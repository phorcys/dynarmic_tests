/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x0001FFFF" }
}
*/
.text
.global _start
_start:
    ldr r1, =0xFFFE0002
    ldr r2, =0x0003FFFD
    qadd16 r0, r1, r2
    bkpt #0
.ltorg
