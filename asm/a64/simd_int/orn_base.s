/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x00000000000000F0",
    "X1": "0x00000000000000FF",
    "X2": "0xFFFFFFFFFFFFFFF0",
    "X3": "0x0000000000000000",
    "X4": "0x0000000000000000",
    "X5": "0x0000000000000000",
    "X6": "0x0000000000000000",
    "X7": "0x0000000000000000"
  }
}
*/
// Test: ORN - bitwise OR NOT

.text
.global _start
_start:
    mov x0, #0xF0
    mov x1, #0xFF
    orn x2, x0, x1           // 0xF0 | ~0xFF = 0xF0 | 0xFFFFFFFFFFFFFF00
                             // = 0xFFFFFFFFFFFFFFF0
    mov x3, #0
    mov x4, #0
    mov x5, #0
    mov x6, #0
    mov x7, #0

    brk #0
