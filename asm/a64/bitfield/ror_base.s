/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000080000000",
    "X1": "0x0000000008000000",
    "X2": "0x0000000000000001",
    "X3": "0x8000000000000000",
    "X4": "0x0000000000000000",
    "X5": "0x0000000000000000",
    "X6": "0x0000000000000000",
    "X7": "0x0000000000000000"
  }
}
*/
// Test: ROR - rotate right

.text
.global _start
_start:
    mov x0, #0x80000000
    ror x1, x0, #4           // rotate right 4 bits
    movz x2, #0x0001
    movk x2, #0x0000, lsl #16
    movk x2, #0x0000, lsl #32
    movk x2, #0x0000, lsl #48  // x2 = 1
    ror x3, x2, #1           // 1 >> 1 with wrap = high bit set
    mov x4, #0
    mov x5, #0
    mov x6, #0
    mov x7, #0

    brk #0
