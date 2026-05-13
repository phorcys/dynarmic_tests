/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x00000000000000FF",
    "X1": "0x000000000000000F",
    "X2": "0xFFFFFFFFFFFFFF0F",
    "X3": "0x0000000000000000",
    "X4": "0x0000000000000000",
    "X5": "0x0000000000000000",
    "X6": "0x0000000000000000",
    "X7": "0x0000000000000000"
  }
}
*/
// Test: EON - exclusive OR NOT

.text
.global _start
_start:
    mov x0, #0xFF
    mov x1, #0x0F
    eon x2, x0, x1           // 0xFF ^ ~0x0F = 0xFF ^ 0xFFFF...F0 = 0xFFFF...0F
    mov x3, #0
    mov x4, #0
    mov x5, #0
    mov x6, #0
    mov x7, #0

    brk #0
