/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000001234",
    "X1": "0x0000000000005678"
  },
  "MemData": {
    "0x1000": ["0x0000000000001234", "0x0000000000005678"]
  }
}
*/
.text
.global _start
_start:
    ldr x2, =0x1000
    mov x3, #0
    ldr x0, [x2, x3]
    mov x3, #8
    ldr x1, [x2, x3]
    brk #0
