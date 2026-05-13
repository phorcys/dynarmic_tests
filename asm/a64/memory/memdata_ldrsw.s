/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0xFFFFFFFF80000000",
    "X1": "0x000000007FFFFFFF"
  },
  "MemData": {
    "0x1000": ["0x000000007FFFFFFF", "0x0000000080000000"]
  }
}
*/
.text
.global _start
_start:
    ldr x3, =0x1000
    ldrsw x0, [x3, #8]
    ldrsw x1, [x3]
    brk #0
