/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000001234",
    "X1": "0x3412000000000000",
    "X2": "0x0000000000000001",
    "X3": "0x0100000000000000",
    "X4": "0x0000000000000000",
    "X5": "0x0000000000000000",
    "X6": "0x0000000000000000",
    "X7": "0x0000000000000000"
  }
}
*/
// Test: REV - reverse bytes

.text
.global _start
_start:
    movz x0, #0x1234
    rev x1, x0               // reverse byte order
    movz x2, #0x0001
    rev x3, x2               // 0x01000000...
    mov x4, #0
    mov x5, #0
    mov x6, #0
    mov x7, #0

    brk #0
