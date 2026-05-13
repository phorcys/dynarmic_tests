/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x00000000000000FF",
    "X1": "0x000000000000000F",
    "X2": "0x000000000000000F",
    "X3": "0x0000000012345678",
    "X4": "0x00000000FF00FF00",
    "X5": "0x0000000012005600",
    "X6": "0x0000000000000000",
    "X7": "0x0000000000000000"
  }
}
*/
// Test: AND - bitwise AND

.text
.global _start
_start:
    mov x0, #0xFF
    mov x1, #0x0F
    and x2, x0, x1           // 0xFF & 0x0F = 0x0F
    movz x3, #0x5678
    movk x3, #0x1234, lsl #16  // x3 = 0x12345678
    movz x4, #0xFF00
    movk x4, #0xFF00, lsl #16  // x4 = 0xFF00FF00
    and x5, x3, x4           // 0x12345678 & 0xFF00FF00 = 0x12005600
    mov x6, #0
    mov x7, #0

    brk #0
