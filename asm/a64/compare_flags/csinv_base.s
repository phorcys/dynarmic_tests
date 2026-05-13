/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x00000000000000FF",
    "X1": "0x0000000000000000",
    "X2": "0x0000000000000001",
    "X3": "0x00000000000000FF",
    "X4": "0xFFFFFFFFFFFFFFFF",
    "X5": "0x0000000000000000",
    "X6": "0x0000000000000000",
    "X7": "0x0000000000000000"
  }
}
*/
// Test: CSINV - conditional select invert

.text
.global _start
_start:
    mov x0, #0xFF
    mov x1, #0
    mov x2, #1
    cmp x2, #1               // equal, EQ condition
    csinv x3, x0, x1, eq     // if EQ: x3 = x0 = 0xFF
    csinv x4, x0, x1, ne     // if NE: x4 = ~x1 = ~0 = -1
    mov x5, #0
    mov x6, #0
    mov x7, #0

    brk #0
