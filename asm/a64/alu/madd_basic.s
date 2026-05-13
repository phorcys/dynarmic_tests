/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000003",
    "X1": "0x0000000000000004",
    "X2": "0x0000000000000005",
    "X3": "0x0000000000000011",
    "X4": "0x0000000000000000",
    "X5": "0x0000000000000000",
    "X6": "0x0000000000000000",
    "X7": "0x0000000000000000"
  }
}
*/
// Test: MADD - multiply-add

.text
.global _start
_start:
    mov x0, #3
    mov x1, #4
    mov x2, #5
    madd x3, x0, x1, x2
    // x3 = 3 * 4 + 5 = 17
    mov x4, #0
    mov x5, #0
    mov x6, #0
    mov x7, #0

    brk #0
