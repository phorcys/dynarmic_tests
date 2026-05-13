/* CONFIG
{
  "Match": "All",
  "RegData": {
    "W0": "0xFFFFFF80",
    "W1": "0x0000007F"
  },
  "MemData": {
    "0x1000": ["0x0000000000007F80"]
  }
}
*/
.text
.global _start
_start:
    ldr x3, =0x1000
    ldrsb w0, [x3]
    ldrsb w1, [x3, #1]
    brk #0
