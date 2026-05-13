/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x000000000000002A",
    "X1": "0x0000000000000032",
    "X2": "0x000000000000000A"
  }
}
*/

// Test: ADD instruction (register)
// X0 = 42
// X1 = X0 + 8 = 50
// X2 = 10

.text
.global _start

_start:
    mov x0, #42
    add x1, x0, #8
    mov x2, #10
    brk #0
