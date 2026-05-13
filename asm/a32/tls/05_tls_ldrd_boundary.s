/* CONFIG
{
  "Match": "All",
  "TpidrurwInit": "0x3000",
  "TlsData": {
    "0xFF8": "0x0123456789ABCDEF"
  },
  "RegData": {
    "R0": "0x89ABCDEF",
    "R1": "0x01234567"
  }
}
*/
.text
.arm
.global _start
_start:
    mrc p15, 0, r2, c13, c0, 2
    ldr r3, =0xFF8
    add r2, r2, r3
    ldrd r0, r1, [r2]
    bkpt #0
