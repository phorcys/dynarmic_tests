/* CONFIG
{
  "Match": "All",
  "TpidrurwInit": "0x3000",
  "TlsData": {
    "0x0": "0x12345678",
    "0x4": "0xCAFEBABE"
  },
  "RegData": {
    "R0": "0x12345678",
    "R1": "0xCAFEBABE"
  }
}
*/
.text
.arm
.global _start
_start:
    mrc p15, 0, r2, c13, c0, 2
    ldr r0, [r2, #0]
    ldr r1, [r2, #4]
    bkpt #0
