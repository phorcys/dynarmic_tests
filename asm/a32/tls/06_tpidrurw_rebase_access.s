/* CONFIG
{
  "Match": "All",
  "TpidrurwInit": "0x3000",
  "TlsData": {
    "0x100": "0x55667788"
  },
  "RegData": {
    "R1": "0x00003100",
    "R2": "0x55667788"
  }
}
*/
.text
.arm
.global _start
_start:
    ldr r0, =0x3100
    mcr p15, 0, r0, c13, c0, 2
    mrc p15, 0, r1, c13, c0, 2
    ldr r2, [r1, #0]
    bkpt #0
