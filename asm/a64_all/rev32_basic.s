/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x7800000012005634"
  }
}
*/
.text
.global _start
_start:
    mov x0, #0x12
    movk x0, #0x3456, lsl #16
    movk x0, #0x78, lsl #32
    rev32 x0, x0
    brk #0
