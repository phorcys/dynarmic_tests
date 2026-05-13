/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x000000000000002A",
    "X1": "0xFFFFFFFFFFFFFFD6",
    "X2": "0x0000000000000000",
    "X3": "0x0000000000000000",
    "X4": "0x0000000000000000",
    "X5": "0x0000000000000000",
    "X6": "0x0000000000000000",
    "X7": "0x0000000000000000"
  }
}
*/
// Test: NEG - negate

.text
.global _start
_start:
    mov x0, #42
    neg x1, x0               // x1 = -42
    mov x2, #0
    neg x3, x2               // x3 = 0
    mov x4, #0
    mov x5, #0
    mov x6, #0
    mov x7, #0

    brk #0
