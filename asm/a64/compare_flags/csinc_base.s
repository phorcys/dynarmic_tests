/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000005",
    "X1": "0x000000000000000A",
    "X2": "0x0000000000000000",
    "X3": "0x0000000000000005",
    "X4": "0x000000000000000B",
    "X5": "0x0000000000000000",
    "X6": "0x0000000000000000",
    "X7": "0x0000000000000000"
  }
}
*/
// Test: CSINC - conditional select increment

.text
.global _start
_start:
    mov x0, #5
    mov x1, #10
    mov x2, #0
    cmp x2, #0               // equal, EQ condition
    csinc x3, x0, x1, eq     // if EQ: x3 = x0 = 5
    csinc x4, x0, x1, ne     // if NE: x4 = x1 + 1 = 11
    mov x5, #0
    mov x6, #0
    mov x7, #0

    brk #0
