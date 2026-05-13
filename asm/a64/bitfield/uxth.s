/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0xFFFFFFFFFFFF0000",
    "X1": "0x0000000000000000",
    "X2": "0x000000000000ABCD",
    "X3": "0x000000000000ABCD",
    "X4": "0x0000000000000000",
    "X5": "0x0000000000000000",
    "X6": "0x0000000000000000",
    "X7": "0x0000000000000000"
  }
}
*/
// Test: UXTH - zero extend halfword

.text
.global _start
_start:
    mov x0, #0xFFFFFFFFFFFF0000
    uxth x1, w0
    // x1 = 0 (zero extended from lower halfword)
    mov w2, #0xABCD
    uxth x3, w2
    // x3 = 0xABCD
    mov x4, #0
    mov x5, #0
    mov x6, #0
    mov x7, #0

    brk #0
