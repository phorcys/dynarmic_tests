/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x000000000000007F",
    "X1": "0x000000000000007F",
    "X2": "0x00000000000000FF",
    "X3": "0xFFFFFFFFFFFFFFFF",
    "X4": "0x0000000000000000",
    "X5": "0x0000000000000000",
    "X6": "0x0000000000000000",
    "X7": "0x0000000000000000"
  }
}
*/
// Test: SXTB - sign extend byte

.text
.global _start
_start:
    mov w0, #0x7F
    sxtb x1, w0
    // x1 = 127 (positive)
    mov w2, #0xFF
    sxtb x3, w2
    // x3 = -1 (sign extended from 0xFF)
    mov x4, #0
    mov x5, #0
    mov x6, #0
    mov x7, #0

    brk #0
