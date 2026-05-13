/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x00000000000000FF",
    "X1": "0x000000000000000F",
    "X2": "0x00000000000000F0",
    "X3": "0x000000000000FFFF",
    "X4": "0x00000000000000FF",
    "X5": "0x000000000000FF00",
    "X6": "0x0000000000000000",
    "X7": "0x0000000000000000"
  }
}
*/
// Test: BIC - bitwise AND NOT

.text
.global _start
_start:
    mov x0, #0xFF
    mov x1, #0x0F
    bic x2, x0, x1           // 0xFF & ~0x0F = 0xFF & 0xF0 = 0xF0
    mov x3, #0xFFFF
    mov x4, #0xFF
    bic x5, x3, x4           // 0xFFFF & ~0xFF = 0xFF00
    mov x6, #0
    mov x7, #0

    brk #0
