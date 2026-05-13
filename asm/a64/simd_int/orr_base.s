/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x00000000000000F0",
    "X1": "0x000000000000000F",
    "X2": "0x00000000000000FF",
    "X3": "0x0000000012340000",
    "X4": "0x0000000000005678",
    "X5": "0x0000000012345678",
    "X6": "0x0000000000000000",
    "X7": "0x0000000000000000"
  }
}
*/
// Test: ORR - bitwise OR

.text
.global _start
_start:
    mov x0, #0xF0
    mov x1, #0x0F
    orr x2, x0, x1           // 0xF0 | 0x0F = 0xFF
    movz x3, #0x0000
    movk x3, #0x1234, lsl #16  // x3 = 0x12340000
    movz x4, #0x5678           // x4 = 0x00005678
    orr x5, x3, x4           // 0x12340000 | 0x00005678 = 0x12345678
    mov x6, #0
    mov x7, #0

    brk #0
