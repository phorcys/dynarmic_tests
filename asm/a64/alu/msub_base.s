/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000003",
    "X1": "0x0000000000000004",
    "X2": "0x0000000000000005",
    "X3": "0xFFFFFFFFFFFFFFF9",
    "X4": "0x0000000000000000",
    "X5": "0x0000000000000000",
    "X6": "0x0000000000000000",
    "X7": "0x0000000000000000"
  }
}
*/
// Test: MSUB - multiply-subtract

.text
.global _start
_start:
    mov x0, #3
    mov x1, #4
    mov x2, #5
    msub x3, x0, x1, x2      // x3 - (3 * 4) = 5 - 12 = -7
    mov x4, #0
    mov x5, #0
    mov x6, #0
    mov x7, #0

    brk #0
