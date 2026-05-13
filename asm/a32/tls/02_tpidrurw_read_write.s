/* CONFIG
{
  "Match": "All",
  "TpidrurwInit": "0x3000",
  "RegData": {
    "R1": "0x00003000",
    "R2": "0x00003400"
  }
}
*/
.text
.arm
.global _start
_start:
    mrc p15, 0, r1, c13, c0, 2
    ldr r0, =0x3400
    mcr p15, 0, r0, c13, c0, 2
    mrc p15, 0, r2, c13, c0, 2
    bkpt #0
