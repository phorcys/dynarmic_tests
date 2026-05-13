/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0xFFFFFFFF80000000"
  },
  "MemData": {
    "0x1008": ["0x0000000080000000"]
  }
}
*/
.text
.global _start
_start:
    ldr x1, =0x1000
    ldrsw x0, [x1, #8]
    brk #0
