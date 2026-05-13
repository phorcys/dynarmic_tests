/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000000",
    "X1": "0x0000000000000001",
    "X2": "0x0000000000000001",
    "X3": "0x7FFFFFFFFFFFFFFF",
    "X4": "0x0000000000000001",
    "X5": "0x8000000000000000",
    "X6": "0x0000000000000000",
    "X7": "0x0000000000000000"
  }
}
*/
// Test: ADDS - set flags

.text
.global _start
_start:
    mov x0, #0
    mov x1, #1
    adds x2, x0, x1          // 0 + 1 = 1, Z=0, N=0, C=0, V=0
    mov x3, #0x7FFFFFFFFFFFFFFF
    mov x4, #1
    adds x5, x3, x4          // MAX + 1, overflow, V=1
    mov x6, #0
    mov x7, #0

    brk #0
