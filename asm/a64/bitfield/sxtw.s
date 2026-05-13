/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x000000007FFFFFFF",
    "X1": "0x000000007FFFFFFF",
    "X2": "0x0000000080000000",
    "X3": "0xFFFFFFFF80000000",
    "X4": "0x0000000000000000",
    "X5": "0x0000000000000000",
    "X6": "0x0000000000000000",
    "X7": "0x0000000000000000"
  }
}
*/
// Test: SXTW - sign extend word

.text
.global _start
_start:
    mov w0, #0x7FFFFFFF
    sxtw x1, w0
    // x1 = 2147483647 (positive)
    mov w2, #0x80000000
    sxtw x3, w2
    // x3 = -2147483648 (sign extended)
    mov x4, #0
    mov x5, #0
    mov x6, #0
    mov x7, #0

    brk #0
