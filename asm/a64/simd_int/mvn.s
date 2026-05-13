/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x00000000000000FF",
    "X1": "0xFFFFFFFFFFFFFF00",
    "X2": "0x000000000000000F",
    "X3": "0xFFFFFFFFFFFFFFF0",
    "X4": "0x0000000000000000",
    "X5": "0x0000000000000000",
    "X6": "0x0000000000000000",
    "X7": "0x0000000000000000"
  }
}
*/
// Test: MVN - move NOT

.text
.global _start
_start:
    mov x0, #0xFF
    mvn x1, x0               // x1 = ~0xFF
    mov x2, #0x0F
    mvn x3, x2               // x3 = ~0x0F
    mov x4, #0
    mov x5, #0
    mov x6, #0
    mov x7, #0

    brk #0
