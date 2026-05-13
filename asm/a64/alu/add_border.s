/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0xFFFFFFFFFFFFFFFF",
    "X1": "0x0000000000000001",
    "X2": "0x0000000000000000",
    "X3": "0x0000000000000000",
    "X4": "0x0000000000000000",
    "X5": "0x0000000000000000",
    "X6": "0x0000000000000000",
    "X7": "0x0000000000000000"
  }
}
*/
// Test: ADD - overflow and boundary cases
// Testing: MAX + 1 = 0 (wrap), -1 + 1 = 0

.text
.global _start
_start:
    // -1 + 1 = 0
    movn x0, #0              // x0 = -1 (0xFFFFFFFFFFFFFFFF)
    mov x1, #1
    add x2, x0, x1           // -1 + 1 = 0

    mov x3, #0
    mov x4, #0
    mov x5, #0
    mov x6, #0
    mov x7, #0

    brk #0
