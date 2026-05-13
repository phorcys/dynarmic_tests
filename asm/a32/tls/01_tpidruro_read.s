/* CONFIG
{
  "Match": "All",
  "TpidruroInit": "0x3000",
  "RegData": {
    "R0": "0x00003000"
  }
}
*/
.text
.arm
.global _start
_start:
    mrc p15, 0, r0, c13, c0, 3
    bkpt #0
