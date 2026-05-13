/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000000",
    "X1": "0x000000000000002A",
    "X2": "0x000000000000003C",
    "X3": "0x0000000000000FFF",
    "X4": "0x0000000000000000",
    "X5": "0x0000000000000000",
    "X6": "0x0000000000000000",
    "X7": "0x0000000000000000"
  }
}
*/
// Test: ADD (immediate) - basic immediate values
// Covers a small immediate and the max unshifted 12-bit immediate.

.text
.global _start
_start:
    mov x0, #0
    mov x1, #42
    add x2, x1, #18
    mov x3, #0
    add x3, x3, #4095

    mov x4, #0
    mov x5, #0
    mov x6, #0
    mov x7, #0

    brk #0
