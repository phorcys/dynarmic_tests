/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000064",
    "X1": "0x0000000000000007",
    "X2": "0x000000000000000E",
    "X3": "0x000000000000000E",
    "X4": "0xFFFFFFFFFFFFFF9C",
    "X5": "0xFFFFFFFFFFFFFFF2",
    "X6": "0x0000000000000000",
    "X7": "0x0000000000000000"
  }
}
*/
// Test: SDIV/UDIV - basic division

.text
.global _start
_start:
    mov x0, #100
    mov x1, #7
    udiv x2, x0, x1          // 100 / 7 = 14
    sdiv x3, x0, x1          // 100 / 7 = 14 (same for positive)
    mov x4, #-100
    sdiv x5, x4, x1          // -100 / 7 = -14
    mov x6, #0
    mov x7, #0

    brk #0
