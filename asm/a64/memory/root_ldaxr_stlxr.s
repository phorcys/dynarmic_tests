/* CONFIG
{
  "Match": "All",
  "RegData": {
    "W0": "0x00000000",
    "X1": "0x0000000000005678"
  },
  "MemData": {
    "0x1000": ["0x0000000000000000"]
  }
}
*/
.text
.global _start
_start:
    ldr x2, =0x1000
    ldaxr x1, [x2]
    mov x1, #0x5678
    stlxr w0, x1, [x2]
    ldr x1, [x2]
    brk #0
