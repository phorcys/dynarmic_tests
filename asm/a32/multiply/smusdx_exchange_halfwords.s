/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0xFFFFFFFE"
  }
}
*/
.text
.global _start
_start:
    ldr r1, =0x00020001
    ldr r2, =0x00040003
    smusdx r0, r1, r2       @ 1*4 - 2*3 = -2
    bkpt #0
