/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000003",
    "X1": "0x0000000000000004",
    "X2": "0x0000000000000064",
    "X3": "0x0000000000000070",
    "X4": "0x0000000000000000",
    "X5": "0x0000000000000000",
    "X6": "0x0000000000000000",
    "X7": "0x0000000000000000"
  }
}
*/
// Test: UMADDL - unsigned multiply-add long

.text
.global _start
_start:
    mov w0, #3
    mov w1, #4
    mov x2, #100
    umaddl x3, w0, w1, x2
    // x3 = 3 * 4 + 100 = 112
    mov x4, #0
    mov x5, #0
    mov x6, #0
    mov x7, #0

    brk #0
