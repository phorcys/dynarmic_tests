/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000007FFF",
    "X1": "0x0000000000007FFF",
    "X2": "0x000000000000FFFF",
    "X3": "0xFFFFFFFFFFFFFFFF",
    "X4": "0x0000000000000000",
    "X5": "0x0000000000000000",
    "X6": "0x0000000000000000",
    "X7": "0x0000000000000000"
  }
}
*/
// Test: SXTH - sign extend halfword

.text
.global _start
_start:
    mov w0, #0x7FFF
    sxth x1, w0
    // x1 = 32767 (positive)
    mov w2, #0xFFFF
    sxth x3, w2
    // x3 = -1 (sign extended from 0xFFFF)
    mov x4, #0
    mov x5, #0
    mov x6, #0
    mov x7, #0

    brk #0
