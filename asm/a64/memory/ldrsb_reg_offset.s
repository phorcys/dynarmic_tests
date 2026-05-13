/* CONFIG
{
  "Match": "All",
  "RegData": {
    "W0": "0xFFFFFF80"
  },
  "MemData": {
    "0x1005": ["0x0000000000000080"]
  }
}
*/
.text
.global _start
_start:
    ldr x1, =0x1000
    mov x2, #5
    ldrsb w0, [x1, x2]
    brk #0
