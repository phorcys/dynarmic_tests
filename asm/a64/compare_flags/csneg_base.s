/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x000000000000002A",
    "X1": "0x000000000000000A",
    "X2": "0x0000000000000000",
    "X3": "0x000000000000002A",
    "X4": "0xFFFFFFFFFFFFFFF6",
    "X5": "0x0000000000000000",
    "X6": "0x0000000000000000",
    "X7": "0x0000000000000000"
  }
}
*/
// Test: CSNEG - conditional select negate

.text
.global _start
_start:
    mov x0, #42
    mov x1, #10
    mov x2, #0
    cmp x2, #0               // equal, EQ condition
    csneg x3, x0, x1, eq     // if EQ: x3 = x0 = 42
    csneg x4, x0, x1, ne     // if NE: x4 = -x1 = -10
    mov x5, #0
    mov x6, #0
    mov x7, #0

    brk #0
