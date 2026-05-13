/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0xFFFFFFFFFFFFFFFE",
    "X1": "0x0000000000000000",
    "X2": "0x0000000000000003",
    "X3": "0x8000000000000000"
  }
}
*/
// SDIV 64-bit edge coverage: negative, divide-by-zero, overlap, INT_MIN/-1.

.text
.global _start
_start:
    mov x0, #-10
    mov x4, #5
    sdiv x0, x0, x4             // overlap: -10 / 5 = -2

    mov x1, #123
    mov x4, #0
    sdiv x1, x1, x4             // divide by zero -> 0

    mov x2, #10
    mov x4, #3
    sdiv x2, x2, x4             // trunc toward zero = 3

    mov x3, #1
    lsl x3, x3, #63             // INT_MIN
    mov x4, #-1
    sdiv x3, x3, x4             // overflow case -> INT_MIN

    brk #0
