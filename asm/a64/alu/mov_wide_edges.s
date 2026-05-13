/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x123456789ABCDEF0",
    "X1": "0x00000000DEF09ABC",
    "X2": "0xFFFFFFFFFFFF0000",
    "X3": "0xFFFFFFFF5678EDCB"
  }
}
*/
// MOVZ/MOVK/MOVN edge coverage across 32-bit and 64-bit forms.

.text
.global _start
_start:
    movz x0, #0xDEF0
    movk x0, #0x9ABC, lsl #16
    movk x0, #0x5678, lsl #32
    movk x0, #0x1234, lsl #48

    movz w1, #0x9ABC
    movk w1, #0xDEF0, lsl #16

    movn x2, #0xFFFF

    movn x3, #0x1234
    movk x3, #0x5678, lsl #16

    brk #0
