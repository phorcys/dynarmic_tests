/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x000000000000002A",
    "X1": "0x0000000000000042",
    "X2": "0x0000000000000AD4"
  }
}
*/

// Test: MUL instruction
// X0 = 42
// X1 = 66
// X2 = X0 * X1 = 2772 = 0xAD4

.text
.global _start

_start:
    mov x0, #42
    mov x1, #66
    mul x2, x0, x1
    brk #0
