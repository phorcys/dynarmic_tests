/* CONFIG
{
  "Match": "All",
  "TpidrurwInit": "0x3000",
  "RegData": {
    "R2": "0x89ABCDEF",
    "R3": "0x10203040"
  }
}
*/
.text
.arm
.global _start
_start:
    mrc p15, 0, r0, c13, c0, 2
    ldr r1, =0x89ABCDEF
    str r1, [r0, #0]
    ldr r2, [r0, #0]

    ldr r1, =0x10203040
    str r1, [r0, #4]
    ldr r3, [r0, #4]
    bkpt #0
