/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000001234"
  },
  "MemData": {
    "0x1008": ["0x0000000000001234"]
  }
}
*/
.text
.global _start
_start:
    ldr x2, =0x1000
    mov w3, #1
    ldr x0, [x2, w3, sxtw #3]
    brk #0
