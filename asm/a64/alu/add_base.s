/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x000000000000002A",
    "X1": "0x0000000000000064",
    "X2": "0x000000000000008E",
    "X3": "0x0000000000000032",
    "X4": "0x000000000000044C",
    "X5": "0x0000000000000000",
    "X6": "0x0000000000000000",
    "X7": "0x0000000000000000"
  }
}
*/
// Test: ADD - basic register and immediate forms

.text
.global _start
_start:
    mov x0, #42
    mov x1, #100
    add x2, x0, x1          // 42 + 100 = 142
    add x3, x0, #8          // 42 + 8 = 50
    add x4, x1, #1000       // 100 + 1000 = 1100
    mov x5, #0
    mov x6, #0
    mov x7, #0

    brk #0
