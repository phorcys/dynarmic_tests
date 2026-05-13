/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0xFFFFFFFFFFFFFF80"
  },
  "MemData": {
    "0x1000": ["0x0000000000000080"]
  }
}
*/
.text
.global _start
_start:
    ldr x1, =0x1000
    ldrsb x0, [x1]
    brk #0
