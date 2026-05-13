/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x1200563478000000"
  }
}
*/
.text
.global _start
_start:
    mov x0, #0x12
    movk x0, #0x3456, lsl #16
    movk x0, #0x78, lsl #32
    rev64 x0, x0
    brk #0
