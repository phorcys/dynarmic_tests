/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x00000000FFFFFFFE",
    "X1": "0x0000000000000000",
    "X2": "0x0000000000000003",
    "X3": "0x0000000080000000"
  }
}
*/
// SDIV 32-bit edge coverage: negative, divide-by-zero, overlap, INT_MIN/-1.

.text
.global _start
_start:
    mov w0, #-10
    mov w4, #5
    sdiv w0, w0, w4             // overlap: -10 / 5 = -2

    mov w1, #123
    mov w4, #0
    sdiv w1, w1, w4             // divide by zero -> 0

    mov w2, #10
    mov w4, #3
    sdiv w2, w2, w4             // trunc toward zero = 3

    mov w3, #1
    lsl w3, w3, #31             // INT_MIN
    mov w4, #-1
    sdiv w3, w3, w4             // overflow case -> INT_MIN

    brk #0
